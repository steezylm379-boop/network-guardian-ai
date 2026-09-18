package com.networkguardian.network_guardian_ai

import android.net.Network
import android.os.SystemClock
import java.net.*
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicBoolean

internal class DeviceIntelligenceDiscovery(
    private val network: Network,
    private val iface: NetworkInterface,
    private val first: Long,
    private val last: Long,
    private val stopped: AtomicBoolean,
    private val datagrams: MutableSet<DatagramSocket>,
    private val sockets: MutableSet<Socket>,
    private val emit: (Map<String, Any?>) -> Unit
) {
    private val client = LanDescriptionClient(stopped, { SystemClock.elapsedRealtime() }) { uri -> network.openConnection(uri.toURL(), Proxy.NO_PROXY) as HttpURLConnection }
    private val workers = Executors.newFixedThreadPool(4)
    fun cancel() { client.cancel(); workers.shutdownNow() }
    fun discover() {
        if (stopped.get()) return
        val locations = linkedMapOf<String, Pair<String, URI>>()
        val socket = MulticastSocket(null)
        datagrams.add(socket)
        try {
            if (stopped.get()) return
            socket.bind(InetSocketAddress(0)); network.bindSocket(socket)
            socket.networkInterface = iface; socket.timeToLive = 2; socket.soTimeout = 250
            for (target in listOf("ssdp:all", "upnp:rootdevice")) {
                val message = "M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMAN: \"ssdp:discover\"\r\nMX: 2\r\nST: $target\r\n\r\n".toByteArray(Charsets.US_ASCII)
                socket.send(DatagramPacket(message, message.size, InetAddress.getByName("239.255.255.250"), 1900))
            }
            val deadline = SystemClock.elapsedRealtime() + 3500
            var responses = 0
            val seen = mutableSetOf<String>()
            while (!stopped.get() && SystemClock.elapsedRealtime() < deadline && responses < 128) {
                val packet = DatagramPacket(ByteArray(8193), 8193)
                try { socket.receive(packet) } catch (_: SocketTimeoutException) { continue }
                responses++
                val ip = packet.address.hostAddress ?: continue
                val number = IntelligenceParsers.ipv4(ip) ?: continue
                if (number !in first..last) continue
                val headers = IntelligenceParsers.ssdp(packet.data.copyOf(packet.length)) ?: continue
                if (!seen.add("$ip:${headers["usn"]}:${headers["st"]}")) continue
                emit(mapOf("kind" to "device", "ip" to ip, "source" to "SSDP", "ssdp" to headers))
                val raw = headers["location"] ?: continue
                val uri = IntelligenceParsers.location(raw, ip, first, last) ?: continue
                if (locations.size < 32) locations[uri.toString()] = ip to uri
            }
        } catch (_: Exception) {
            if (!stopped.get()) emit(mapOf("kind" to "warning", "message" to "SSDP discovery unavailable on this Wi-Fi interface; other discovery results are retained."))
        } finally { datagrams.remove(socket); socket.close() }
        val deadline = SystemClock.elapsedRealtime() + 12000
        val jobs = locations.values.map { (ip, uri) -> workers.submit {
            if (!stopped.get() && SystemClock.elapsedRealtime() < deadline) client.fetch(uri, deadline)?.let {
                if (!stopped.get()) emit(mapOf("kind" to "device", "ip" to ip, "source" to "UPnP", "upnp" to it))
            }
        } }
        for (job in jobs) {
            if (stopped.get()) break
            try { job.get((deadline - SystemClock.elapsedRealtime()).coerceAtLeast(1), TimeUnit.MILLISECONDS) }
            catch (_: Exception) { job.cancel(true) }
        }
        client.cancel()
    }
    fun portHints(hosts: List<String>) {
        val deadline = SystemClock.elapsedRealtime() + 10000
        val jobs = hosts.take(128).map { ip -> workers.submit {
            for (port in listOf(22, 53, 80, 443, 445, 554, 631, 8008, 8009, 9100, 62078)) {
                if (stopped.get() || Thread.currentThread().isInterrupted || SystemClock.elapsedRealtime() >= deadline) break
                val socket = Socket(); sockets.add(socket)
                try {
                    if (stopped.get()) break
                    network.bindSocket(socket); socket.connect(InetSocketAddress(ip, port), 200)
                    if (!stopped.get()) emit(mapOf("kind" to "device", "ip" to ip, "source" to "TCP hint", "openPort" to port))
                } catch (_: Exception) { /* Only a successful connection is an open port. */ }
                finally { sockets.remove(socket); try { socket.close() } catch (_: Exception) {} }
            }
        } }
        for (job in jobs) {
            if (stopped.get()) break
            try { job.get((deadline - SystemClock.elapsedRealtime()).coerceAtLeast(1), TimeUnit.MILLISECONDS) }
            catch (_: Exception) { job.cancel(true) }
        }
    }
}

