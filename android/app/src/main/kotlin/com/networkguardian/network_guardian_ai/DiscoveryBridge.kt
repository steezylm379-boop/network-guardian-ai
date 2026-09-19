package com.networkguardian.network_guardian_ai

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.net.*
import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import android.net.wifi.WifiInfo
import android.os.*
import android.system.ErrnoException
import android.system.OsConstants
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.net.*
import java.util.concurrent.*
import java.util.concurrent.atomic.AtomicBoolean
import java.util.concurrent.atomic.AtomicInteger

class DiscoveryBridge(private val activity: FlutterActivity, messenger: io.flutter.plugin.common.BinaryMessenger) {
    private val cm = activity.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
    private val handler = Handler(Looper.getMainLooper())
    private val coordinator = Executors.newSingleThreadExecutor()
    private var sink: EventChannel.EventSink? = null
    private var active: ScanRun? = null
    private var permissionResult: MethodChannel.Result? = null

    init {
        EventChannel(messenger, "network_guardian/events").setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) { sink = events }
            override fun onCancel(arguments: Any?) { sink = null }
        })

        MethodChannel(messenger, "network_guardian/discovery").setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "network" -> result.success(networkInfo(selectNetwork()))
                    "permission" -> {
                        if (permissionResult != null) {
                            result.error("busy", "Permission request already open", null)
                        } else {
                            val requested = mutableListOf(
                                Manifest.permission.ACCESS_FINE_LOCATION,
                                Manifest.permission.ACCESS_COARSE_LOCATION
                            )
                            if (Build.VERSION.SDK_INT >= 33) requested.add(Manifest.permission.NEARBY_WIFI_DEVICES)
                            val missing = requested.filter { activity.checkSelfPermission(it) != PackageManager.PERMISSION_GRANTED }
                            if (missing.isEmpty()) result.success(true)
                            else {
                                permissionResult = result
                                activity.requestPermissions(missing.toTypedArray(), 410)
                            }
                        }
                    }
                    "start" -> {
                        check(active == null) { "A scan is already running" }
                        val network = selectNetwork()
                        check(network.toString() == call.argument<String>("token")) { "Wi-Fi changed. Please scan again." }
                        val run = ScanRun(network, call.argument<String>("runId")!!)
                        active = run
                        coordinator.execute { run.execute() }
                        result.success(null)
                    }
                    "cancel" -> { active?.cancel(); active = null; result.success(null) }
                    else -> result.notImplemented()
                }
            } catch (e: Exception) { result.error("network_unavailable", e.message ?: "Network operation unavailable", null) }
        }
    }

    fun permissions(code: Int, grants: IntArray) {
        if (code == 410) { permissionResult?.success(grants.isNotEmpty() && grants.all { it == PackageManager.PERMISSION_GRANTED }); permissionResult = null }
    }

    fun dispose() { active?.cancel(); coordinator.shutdownNow(); permissionResult?.success(false); permissionResult = null }

    private fun selectNetwork(): Network = cm.allNetworks.firstOrNull {
        val caps = cm.getNetworkCapabilities(it)
        caps?.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) == true && !caps.hasTransport(NetworkCapabilities.TRANSPORT_VPN)
    } ?: throw IllegalStateException("No Wi-Fi network available. Connect to Wi-Fi; mobile data cannot be scanned.")

    private fun networkInfo(network: Network): Map<String, Any?> {
        val lp = cm.getLinkProperties(network) ?: error("Wi-Fi interface information is unavailable")
        val link = lp.linkAddresses.firstOrNull { it.address is Inet4Address && !it.address.isLoopbackAddress }
            ?: error("This Wi-Fi network has no IPv4 address. IPv6-only discovery is not implemented in this build.")
        val wifi = cm.getNetworkCapabilities(network)?.transportInfo as? WifiInfo
        @Suppress("DEPRECATION")
        val legacy = try { (activity.applicationContext.getSystemService(Context.WIFI_SERVICE) as android.net.wifi.WifiManager).connectionInfo } catch (_: SecurityException) { null }
        val ssid = (wifi?.ssid?.takeUnless { it == "<unknown ssid>" } ?: legacy?.ssid)
            ?.trim('"')?.takeUnless { it == "<unknown ssid>" || it.isBlank() }
        val bssid = (wifi?.bssid?.takeUnless { it == "02:00:00:00:00:00" } ?: legacy?.bssid)
            ?.takeUnless { it == "02:00:00:00:00:00" || it == "00:00:00:00:00:00" }
        return mapOf("ip" to link.address.hostAddress, "prefix" to link.prefixLength,
            "gateway" to lp.routes.firstOrNull { it.isDefaultRoute && it.hasGateway() && it.gateway is Inet4Address }?.gateway?.hostAddress,
            "interface" to (lp.interfaceName ?: error("Invalid Wi-Fi interface")), "ssid" to ssid, "bssid" to bssid,
            "token" to network.toString(), "boot" to android.provider.Settings.Global.getInt(activity.contentResolver, android.provider.Settings.Global.BOOT_COUNT, 0))
    }

    private fun emit(id: String, values: Map<String, Any?>) { handler.post { sink?.success(values + ("runId" to id)) } }

    private inner class ScanRun(val network: Network, val id: String) {
        val stopped = AtomicBoolean(false)
        val pool = Executors.newFixedThreadPool(32)
        val sockets = ConcurrentHashMap.newKeySet<Socket>()
        val datagrams = ConcurrentHashMap.newKeySet<DatagramSocket>()
        val found = ConcurrentHashMap.newKeySet<String>()
        val nsd = MdnsDiscoveryService(network, id, stopped) { ip, data ->
            if (inRange(ip)) { found.add(ip); event(data + mapOf("kind" to "device", "ip" to ip, "source" to "mDNS")) }
        }
        var first = 0L; var last = 0L
        var callback: ConnectivityManager.NetworkCallback? = null
        var intelligence: DeviceIntelligenceDiscovery? = null
        var multicastLock: android.net.wifi.WifiManager.MulticastLock? = null

        fun event(values: Map<String, Any?>) { if (!stopped.get()) emit(id, values) }

        fun inRange(ip: String): Boolean = try { numeric(ip) in first..last } catch (_: Exception) { false }

        @Synchronized
        fun releaseMulticastLock() {
            multicastLock?.let {
                try {
                    if (it.isHeld) it.release()
                } catch (_: Exception) {}
            }
            multicastLock = null
        }

        fun cancel() {
            stopped.set(true)
            intelligence?.cancel()
            releaseMulticastLock()
            sockets.forEach { try { it.close() } catch (_: Exception) {} }
            datagrams.forEach { try { it.close() } catch (_: Exception) {} }
            pool.shutdownNow()
            nsd.stop()
            callback?.let { try { cm.unregisterNetworkCallback(it) } catch (_: Exception) {} }; callback = null
        }

        fun execute() {
            try {
                if (stopped.get()) return
                val info = networkInfo(network)
                val local = info["ip"] as String
                val prefix = info["prefix"] as Int
                val mask = if (prefix == 0) 0L else (0xffffffffL shl (32 - prefix)) and 0xffffffffL
                val base = numeric(local) and mask
                val end = base or (mask xor 0xffffffffL)
                first = if (prefix >= 31) base else base + 1; last = if (prefix >= 31) end else end - 1
                check(last - first + 1 <= 4096) { "Subnet exceeds the 4,096-host scan limit" }
                val iface = NetworkInterface.getByName(info["interface"] as String) ?: error("Wi-Fi interface disappeared")
                val initial = "${info["ip"]}/${info["prefix"]}"

                callback = object : ConnectivityManager.NetworkCallback() {
                    override fun onLost(n: Network) { if (n == network) fail("Wi-Fi disconnected. Partial results retained.") }
                    override fun onLinkPropertiesChanged(n: Network, lp: LinkProperties) {
                        if (n == network && lp.linkAddresses.none { "${it.address.hostAddress}/${it.prefixLength}" == initial }) fail("Wi-Fi address changed. Scan stopped.")
                    }
                }
                cm.registerNetworkCallback(NetworkRequest.Builder().addTransportType(NetworkCapabilities.TRANSPORT_WIFI).build(), callback!!)

                nsd.start()

                val done = AtomicInteger(0)
                val jobs = (first..last).map { address -> pool.submit {
                    if (!stopped.get()) {
                        val ip = format(address)
                        if (ip == local || ReachabilityScanner(network, iface, sockets, stopped).reachable(ip)) {
                            found.add(ip); event(mapOf("kind" to "device", "ip" to ip, "source" to if (ip == local) "Local interface" else "Reachability"))
                        }
                        event(mapOf("kind" to "progress", "scanned" to done.incrementAndGet()))
                    }
                } }
                jobs.forEach { if (!stopped.get()) it.get() }
                if (stopped.get()) return

                event(mapOf("kind" to "phase", "phase" to "resolving"))
                ArpResolver().resolve(info["interface"] as String).let { entries ->
                    if (entries.isEmpty()) event(mapOf("kind" to "warning", "message" to "MAC/ARP information is unavailable or empty on this Android device."))
                    entries.filterKeys { it in found }.forEach { (ip, mac) ->
                        event(mapOf("kind" to "device", "ip" to ip, "mac" to mac, "source" to "ARP"))
                    }
                }

                nsd.awaitWindow()

                val dns = cm.getLinkProperties(network)?.dnsServers?.firstOrNull { it is Inet4Address }
                if (dns != null) found.toList().map { ip -> pool.submit {
                    if (!stopped.get()) HostnameResolver(network, dns, datagrams).resolve(ip)?.let {
                        event(mapOf("kind" to "device", "ip" to ip, "hostname" to it, "source" to "Reverse DNS"))
                    }
                } }.forEach { if (!stopped.get()) it.get() }

                if (!stopped.get()) {
                    event(mapOf("kind" to "phase", "phase" to "identifying"))
                    val wifi = activity.applicationContext.getSystemService(Context.WIFI_SERVICE) as? android.net.wifi.WifiManager
                    if (wifi != null) {
                        try {
                            multicastLock = wifi.createMulticastLock("guardian-ssdp-$id").apply {
                                setReferenceCounted(false)
                                acquire()
                            }
                        } catch (_: Exception) {}
                    }
                    val discovery = DeviceIntelligenceDiscovery(network, iface, first, last, stopped, datagrams, sockets) { data ->
                        (data["ip"] as? String)?.let { found.add(it) }
                        event(data)
                    }
                    intelligence = discovery
                    try {
                        discovery.discover()
                        discovery.portHints(found.toList().sorted())
                    } finally {
                        discovery.cancel()
                        releaseMulticastLock()
                    }
                }

                if (!stopped.get()) emit(id, mapOf("kind" to "completed"))
            } catch (e: Exception) { if (!stopped.get()) emit(id, mapOf("kind" to "error", "message" to (e.message ?: "Discovery failed"))) }
            finally { cancel(); handler.post { if (active === this) active = null } }
        }

        fun fail(message: String) { if (!stopped.get()) { emit(id, mapOf("kind" to "error", "message" to message)); cancel() } }
    }

    private inner class MdnsDiscoveryService(val network: Network, val id: String, val stopped: AtomicBoolean,
        val discovered: (String, Map<String, Any?>) -> Unit) {
        val manager = activity.getSystemService(Context.NSD_SERVICE) as NsdManager
        val listeners = CopyOnWriteArrayList<NsdManager.DiscoveryListener>()
        val resolver = Executors.newSingleThreadExecutor()
        val closed = AtomicBoolean(false)
        val queuedServices = ConcurrentHashMap.newKeySet<String>()
        var deadline = 0L

        @Synchronized fun start() {
            if (closed.get() || stopped.get()) return
            deadline = SystemClock.elapsedRealtime() + 8000
            listOf("_airplay._tcp.", "_googlecast._tcp.", "_printer._tcp.", "_ipp._tcp.", "_http._tcp.", "_https._tcp.", "_workstation._tcp.").forEach { type ->
                val listener = object : NsdManager.DiscoveryListener {
                    override fun onDiscoveryStarted(t: String) {}
                    override fun onDiscoveryStopped(t: String) {}
                    override fun onStartDiscoveryFailed(t: String, code: Int) { emit(id, mapOf("kind" to "warning", "message" to "mDNS discovery unavailable for $t (Android code $code).")) }
                    override fun onStopDiscoveryFailed(t: String, code: Int) {}
                    override fun onServiceLost(s: NsdServiceInfo) {}
                    override fun onServiceFound(s: NsdServiceInfo) {
                        if (closed.get() || stopped.get()) return
                        val name = s.serviceName ?: return
                        val typeStr = s.serviceType ?: return
                        if (queuedServices.size >= 128 || !queuedServices.add("$typeStr:$name")) return
                        try { resolver.execute { resolve(s) } } catch (_: RejectedExecutionException) {}
                    }
                }
                try {
                    listeners.add(listener)
                    manager.discoverServices(type, NsdManager.PROTOCOL_DNS_SD, network, activity.mainExecutor, listener)
                } catch (_: Exception) { emit(id, mapOf("kind" to "warning", "message" to "Android could not start mDNS for $type")) }
            }
        }

        @Suppress("DEPRECATION")
        fun resolve(service: NsdServiceInfo) {
            if (closed.get() || stopped.get()) return
            val sName = service.serviceName?.takeIf { it.isNotBlank() && it.length <= 256 } ?: return
            val sType = service.serviceType?.takeIf { it.isNotBlank() && it.length <= 256 } ?: return

            val latch = CountDownLatch(1)
            val resolved = AtomicBoolean(false)
            val listener = object : NsdManager.ResolveListener {
                override fun onResolveFailed(s: NsdServiceInfo, code: Int) { latch.countDown() }
                override fun onServiceResolved(s: NsdServiceInfo) {
                    if (!closed.get() && !stopped.get() && resolved.compareAndSet(false, true)) {
                        val host = s.host
                        val port = s.port
                        if (host is Inet4Address && port in 1..65535) {
                            val cleanName = s.serviceName?.take(256) ?: sName
                            val cleanType = s.serviceType?.take(256) ?: sType
                            val safeAttrs = try {
                                s.attributes.entries.take(32).mapNotNull { (k, v) ->
                                    if (k.isNotBlank() && k.length <= 128 && v != null && v.size <= 1024) {
                                        k to android.util.Base64.encodeToString(v, android.util.Base64.NO_WRAP)
                                    } else null
                                }.toMap()
                            } catch (_: Exception) { emptyMap() }

                            discovered(host.hostAddress!!, mapOf(
                                "mdns" to cleanName,
                                "service" to mapOf(
                                    "name" to cleanName,
                                    "type" to cleanType,
                                    "port" to port,
                                    "attributes" to safeAttrs
                                )
                            ))
                        }
                    }
                    latch.countDown()
                }
            }

            try {
                manager.resolveService(service, listener)
                // Watchdog: bound maximum time for resolve listener to 2000ms
                val completed = latch.await(2000, TimeUnit.MILLISECONDS)
                if (!completed) {
                    resolved.set(false)
                }
            } catch (_: Exception) {}
            finally {
                if (Build.VERSION.SDK_INT >= 34) try { manager.stopServiceResolution(listener) } catch (_: Exception) {}
            }
        }

        fun awaitWindow() {
            while (!stopped.get() && SystemClock.elapsedRealtime() < deadline) Thread.sleep(100)
            stopListeners()
            resolver.shutdown()
            try { resolver.awaitTermination(3, TimeUnit.SECONDS) } catch (_: Exception) {}
            stop()
        }

        private fun stopListeners() {
            listeners.forEach { try { manager.stopServiceDiscovery(it) } catch (_: Exception) {} }
            listeners.clear()
        }

        @Synchronized fun stop() {
            if (!closed.compareAndSet(false, true)) return
            stopListeners()
            resolver.shutdownNow()
        }
    }

    companion object {
        fun numeric(ip: String): Long {
            val parts = ip.split('.'); require(parts.size == 4)
            return parts.fold(0L) { result, part -> val v = part.toInt(); require(v in 0..255); (result shl 8) or v.toLong() }
        }

        fun format(n: Long): String = listOf(24, 16, 8, 0).joinToString(".") { ((n shr it) and 255).toString() }
    }
}

internal class ReachabilityScanner(val network: Network, val iface: NetworkInterface,
    val sockets: MutableSet<Socket>, val stopped: AtomicBoolean) {
    fun reachable(ip: String): Boolean {
        if (stopped.get()) return false
        val address = InetAddress.getByName(ip)
        try { if (address.isReachable(iface, 1, 250)) return true } catch (_: Exception) {}
        for (port in listOf(80, 443)) {
            if (stopped.get()) return false
            val socket = Socket(); sockets.add(socket)
            try {
                network.bindSocket(socket)
                socket.connect(InetSocketAddress(address, port), 350)
                return true
            } catch (e: Exception) {
                var cause: Throwable? = e
                while (cause != null) {
                    if (cause is ErrnoException && cause.errno == OsConstants.ECONNREFUSED) return true
                    cause = cause.cause
                }
            } finally { sockets.remove(socket); try { socket.close() } catch (_: Exception) {} }
        }
        return false
    }
}

internal class ArpResolver {
    fun resolve(iface: String): Map<String, String> = try {
        File("/proc/net/arp").readLines().drop(1).mapNotNull { line ->
            val p = line.trim().split(Regex("\\s+"))
            if (p.size >= 6 && p[5] == iface && p[2] == "0x2" && p[3] != "00:00:00:00:00:00") p[0] to p[3] else null
        }.toMap()
    } catch (_: Exception) { emptyMap() }
}

/** Minimal bounded PTR query, bound to the selected Wi-Fi network's DNS server. */
internal class HostnameResolver(val network: Network, val dns: InetAddress, val sockets: MutableSet<DatagramSocket>) {
    fun resolve(ip: String): String? {
        val socket = DatagramSocket(); sockets.add(socket)
        return try {
            network.bindSocket(socket); socket.soTimeout = 600; socket.connect(dns, 53)
            val id = java.security.SecureRandom().nextInt(65536)
            val query = java.io.ByteArrayOutputStream()
            val out = java.io.DataOutputStream(query)
            out.writeShort(id); out.writeShort(0x0100); out.writeShort(1); repeat(3) { out.writeShort(0) }
            (ip.split('.').reversed() + listOf("in-addr", "arpa")).forEach { out.writeByte(it.length); out.writeBytes(it) }
            out.writeByte(0); out.writeShort(12); out.writeShort(1)
            val request = query.toByteArray(); socket.send(DatagramPacket(request, request.size))
            val packet = DatagramPacket(ByteArray(4096), 4096); socket.receive(packet)
            parsePtr(packet.data.copyOf(packet.length), id)
        } catch (_: Exception) { null } finally { sockets.remove(socket); socket.close() }
    }

    companion object {
        fun parsePtr(bytes: ByteArray, id: Int): String? {
            fun u16(p: Int): Int { require(p + 1 < bytes.size); return ((bytes[p].toInt() and 255) shl 8) or (bytes[p + 1].toInt() and 255) }
            fun name(start: Int): Pair<String, Int> {
                var pos = start; var consumed = -1; var hops = 0; val labels = mutableListOf<String>()
                while (true) {
                    require(pos < bytes.size && hops++ < 128)
                    val length = bytes[pos].toInt() and 255
                    if (length == 0) return labels.joinToString(".") to if (consumed < 0) pos + 1 else consumed
                    if (length and 0xc0 == 0xc0) { if (consumed < 0) consumed = pos + 2; pos = u16(pos) and 0x3fff }
                    else { require(length <= 63 && pos + length < bytes.size); labels.add(String(bytes, pos + 1, length, Charsets.UTF_8)); pos += length + 1 }
                }
            }
            return try {
                require(bytes.size >= 12 && u16(0) == id && u16(2) and 0x800f == 0x8000)
                var p = 12
                repeat(u16(4)) { p = name(p).second + 4 }
                repeat(u16(6)) {
                    p = name(p).second
                    val type = u16(p); val size = u16(p + 8); p += 10
                    require(p + size <= bytes.size)
                    if (type == 12) return name(p).first.takeIf { it.isNotBlank() && it.length <= 253 }
                    p += size
                }
                null
            } catch (_: Exception) { null }
        }
    }
}
