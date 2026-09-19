package com.networkguardian.network_guardian_ai

import java.net.HttpURLConnection
import java.net.URI
import java.io.ByteArrayOutputStream
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.atomic.AtomicBoolean

/** Called only with LOCATION URIs already checked against the selected LAN. */
internal class LanDescriptionClient(
    private val stopped: AtomicBoolean,
    private val now: () -> Long,
    private val open: (URI) -> HttpURLConnection
) {
    private val connections = ConcurrentHashMap.newKeySet<HttpURLConnection>()

    fun cancel() {
        connections.forEach {
            try { it.disconnect() } catch (_: Exception) {}
        }
        connections.clear()
    }

    fun fetch(uri: URI, deadline: Long): Map<String, Any>? {
        var connection: HttpURLConnection? = null
        return try {
            if (stopped.get() || now() >= deadline) return null
            connection = open(uri)
            connections.add(connection)
            if (stopped.get()) return null

            connection.instanceFollowRedirects = false
            connection.connectTimeout = 800
            connection.readTimeout = 800
            connection.useCaches = false
            connection.setRequestProperty("Accept", "text/xml, application/xml")
            connection.setRequestProperty("User-Agent", "NetworkGuardian/1.3")

            val responseCode = connection.responseCode
            if (responseCode != 200) return null

            val length = connection.contentLengthLong
            if (length > IntelligenceParsers.MAX_XML) return null

            val contentType = connection.contentType?.lowercase() ?: ""
            if (contentType.isNotEmpty() && !contentType.contains("xml") && !contentType.contains("text/plain")) {
                return null
            }

            val out = ByteArrayOutputStream()
            connection.inputStream.use { input ->
                val buffer = ByteArray(4096)
                while (!stopped.get() && !Thread.currentThread().isInterrupted && now() < deadline) {
                    val count = input.read(buffer)
                    if (count < 0) return IntelligenceParsers.description(out.toByteArray())
                    if (out.size() + count > IntelligenceParsers.MAX_XML) return null
                    out.write(buffer, 0, count)
                }
            }
            null
        } catch (_: Exception) {
            null
        } finally {
            connection?.let {
                connections.remove(it)
                try { it.disconnect() } catch (_: Exception) {}
            }
        }
    }
}
