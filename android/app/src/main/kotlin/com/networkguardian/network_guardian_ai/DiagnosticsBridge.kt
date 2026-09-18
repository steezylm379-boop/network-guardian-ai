package com.networkguardian.network_guardian_ai

import android.content.Context
import android.net.ConnectivityManager
import android.net.LinkAddress
import android.net.Network
import android.net.NetworkCapabilities
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.net.DatagramPacket
import java.net.DatagramSocket
import java.net.Inet4Address
import java.net.InetAddress
import java.net.InetSocketAddress
import java.net.NetworkInterface
import java.net.Socket
import java.util.concurrent.Executors
import kotlin.math.max

class DiagnosticsBridge(
    private val activity: FlutterActivity,
    messenger: io.flutter.plugin.common.BinaryMessenger
) {
    private val cm = activity.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
    private val executor = Executors.newCachedThreadPool()
    private val channel = MethodChannel(messenger, "network_guardian/diagnostics")

    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "ping" -> executor.execute {
                    try {
                        val ip = requireLanIp(call.argument<String>("ip"))
                        val count = (call.argument<Int>("count") ?: 4).coerceIn(1, 10)
                        val payload = ping(ip, count)
                        activity.runOnUiThread { result.success(payload) }
                    } catch (e: Exception) {
                        activity.runOnUiThread { result.error("diagnostic_failed", e.message, null) }
                    }
                }
                "probeServices" -> executor.execute {
                    try {
                        val ip = requireLanIp(call.argument<String>("ip"))
                        val payload = probeServices(ip)
                        activity.runOnUiThread { result.success(payload) }
                    } catch (e: Exception) {
                        activity.runOnUiThread { result.error("diagnostic_failed", e.message, null) }
                    }
                }
                "wakeOnLan" -> executor.execute {
                    try {
                        val mac = call.argument<String>("mac") ?: error("MAC address is required")
                        wake(mac)
                        activity.runOnUiThread { result.success(null) }
                    } catch (e: Exception) {
                        activity.runOnUiThread { result.error("diagnostic_failed", e.message, null) }
                    }
                }
                "networkStatus" -> executor.execute {
                    try {
                        val payload = networkStatus()
                        activity.runOnUiThread { result.success(payload) }
                    } catch (e: Exception) {
                        activity.runOnUiThread { result.error("diagnostic_failed", e.message, null) }
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
        executor.shutdownNow()
    }

    private fun wifiNetwork(): Network = cm.allNetworks.firstOrNull {
        val caps = cm.getNetworkCapabilities(it)
        caps?.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) == true &&
            !caps.hasTransport(NetworkCapabilities.TRANSPORT_VPN)
    } ?: error("Connect to Wi-Fi before running diagnostics")

    private fun ipv4Link(network: Network): LinkAddress =
        cm.getLinkProperties(network)?.linkAddresses?.firstOrNull {
            it.address is Inet4Address && !it.address.isLoopbackAddress
        } ?: error("Wi-Fi IPv4 information is unavailable")

    private fun ipv4Number(address: InetAddress): Long {
        val b = address.address
        require(b.size == 4) { "IPv4 address required" }
        return ((b[0].toLong() and 255) shl 24) or
            ((b[1].toLong() and 255) shl 16) or
            ((b[2].toLong() and 255) shl 8) or
            (b[3].toLong() and 255)
    }

    private fun requireLanIp(raw: String?): String {
        val ip = raw?.trim() ?: error("IP address is required")
        val addr = InetAddress.getByName(ip)
        require(addr is Inet4Address) { "Only IPv4 LAN diagnostics are supported" }
        val network = wifiNetwork()
        val link = ipv4Link(network)
        val prefix = link.prefixLength
        val mask = if (prefix == 0) 0L else (0xffffffffL shl (32 - prefix)) and 0xffffffffL
        require((ipv4Number(addr) and mask) == (ipv4Number(link.address) and mask)) {
            "Diagnostics are limited to the connected Wi-Fi subnet"
        }
        return ip
    }

    private fun ping(ip: String, count: Int): Map<String, Any?> {
        val times = mutableListOf<Double>()
        try {
            val process = ProcessBuilder("/system/bin/ping", "-c", count.toString(), "-W", "1", ip)
                .redirectErrorStream(true).start()
            val output = process.inputStream.bufferedReader().readText()
            process.waitFor()
            Regex("time[=<]([0-9.]+)\\s*ms").findAll(output).forEach {
                it.groupValues.getOrNull(1)?.toDoubleOrNull()?.let(times::add)
            }
            if (times.isNotEmpty() || output.contains("packets transmitted")) {
                return mapOf(
                    "sent" to count,
                    "received" to times.size,
                    "minMs" to times.minOrNull(),
                    "avgMs" to times.takeIf { it.isNotEmpty() }?.average(),
                    "maxMs" to times.maxOrNull(),
                    "method" to "ICMP"
                )
            }
        } catch (_: Exception) {
            // Fall through to Android reachability below.
        }

        val network = wifiNetwork()
        val link = ipv4Link(network)
        val iface = NetworkInterface.getByName(cm.getLinkProperties(network)?.interfaceName)
        val target = InetAddress.getByName(ip)
        repeat(count) {
            val start = System.nanoTime()
            val ok = target.isReachable(iface, 64, 1000)
            val elapsed = (System.nanoTime() - start) / 1_000_000.0
            if (ok) times.add(elapsed)
        }
        return mapOf(
            "sent" to count,
            "received" to times.size,
            "minMs" to times.minOrNull(),
            "avgMs" to times.takeIf { it.isNotEmpty() }?.average(),
            "maxMs" to times.maxOrNull(),
            "method" to "Android reachability"
        )
    }

    private fun probeServices(ip: String): List<Map<String, Any>> {
        val network = wifiNetwork()
        val ports = linkedMapOf(
            22 to "SSH", 53 to "DNS", 80 to "HTTP", 443 to "HTTPS",
            445 to "SMB", 554 to "RTSP", 631 to "IPP",
            3389 to "Remote Desktop", 8008 to "Chromecast/HTTP",
            8009 to "Chromecast", 9100 to "Printer (JetDirect)"
        )
        val open = mutableListOf<Map<String, Any>>()
        for ((port, name) in ports) {
            val socket = Socket()
            try {
                network.bindSocket(socket)
                socket.connect(InetSocketAddress(ip, port), 350)
                open.add(mapOf("port" to port, "name" to name))
            } catch (_: Exception) {
                // Closed/unreachable is a normal result.
            } finally {
                try { socket.close() } catch (_: Exception) {}
            }
        }
        return open
    }

    private fun networkStatus(): Map<String, Any?> {
        val network = wifiNetwork()
        val caps = cm.getNetworkCapabilities(network) ?: error("Wi-Fi capabilities are unavailable")
        val props = cm.getLinkProperties(network)
        return mapOf(
            "validatedInternet" to caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED),
            "internetCapability" to caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET),
            "metered" to !caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_NOT_METERED),
            "dnsServers" to (props?.dnsServers?.map { it.hostAddress ?: it.toString() } ?: emptyList<String>()),
            "interfaceName" to props?.interfaceName
        )
    }

    private fun wake(rawMac: String) {
        val clean = rawMac.replace("-", ":").uppercase()
        require(Regex("^([0-9A-F]{2}:){5}[0-9A-F]{2}$").matches(clean)) { "Invalid MAC address" }
        val mac = clean.split(":").map { it.toInt(16).toByte() }.toByteArray()
        val packet = ByteArray(6 + 16 * 6)
        for (i in 0 until 6) packet[i] = 0xff.toByte()
        for (i in 6 until packet.size step 6) mac.copyInto(packet, i)

        val network = wifiNetwork()
        val link = ipv4Link(network)
        val prefix = link.prefixLength
        val mask = if (prefix == 0) 0L else (0xffffffffL shl (32 - prefix)) and 0xffffffffL
        val broadcast = (ipv4Number(link.address) and mask) or (mask xor 0xffffffffL)
        val bytes = byteArrayOf(
            ((broadcast shr 24) and 255).toByte(),
            ((broadcast shr 16) and 255).toByte(),
            ((broadcast shr 8) and 255).toByte(),
            (broadcast and 255).toByte()
        )
        val address = InetAddress.getByAddress(bytes)
        val socket = DatagramSocket(null)
        try {
            socket.reuseAddress = true
            socket.broadcast = true
            socket.bind(InetSocketAddress(0))
            network.bindSocket(socket)
            socket.send(DatagramPacket(packet, packet.size, address, 9))
        } finally {
            socket.close()
        }
    }
}
