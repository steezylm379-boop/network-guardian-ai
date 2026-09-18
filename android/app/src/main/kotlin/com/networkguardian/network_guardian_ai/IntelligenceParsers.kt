package com.networkguardian.network_guardian_ai

import java.net.URI
import java.io.StringReader
import java.nio.ByteBuffer
import java.nio.charset.CodingErrorAction
import org.xml.sax.InputSource
import javax.xml.parsers.DocumentBuilderFactory
import org.w3c.dom.Element

internal object IntelligenceParsers {
    const val MAX_XML = 131072
    fun ssdp(bytes: ByteArray): Map<String, String>? {
        if (bytes.size > 8192) return null
        val lines = bytes.toString(Charsets.ISO_8859_1).split("\r\n")
        if (!lines.first().matches(Regex("HTTP/1\\.[01] 200(?: .*)?"))) return null
        val result = linkedMapOf<String, String>()
        for (line in lines.drop(1)) {
            if (line.isEmpty()) break
            val colon = line.indexOf(':'); if (colon <= 0) return null
            val key = line.substring(0, colon).trim().lowercase()
            val value = line.substring(colon + 1).trim()
            if (value.any { it.code < 32 }) return null
            if (key in setOf("st", "usn", "location", "server", "cache-control", "ext")) {
                if (result.containsKey(key) && result[key] != value) return null
                result[key] = value
            }
        }
        return result.takeIf { !it["usn"].isNullOrBlank() && !it["st"].isNullOrBlank() }
    }
    fun ipv4(ip: String): Long? {
        if (!ip.matches(Regex("(?:0|[1-9][0-9]{0,2})(?:\\.(?:0|[1-9][0-9]{0,2})){3}"))) return null
        val parts = ip.split('.').map { it.toInt() }
        if (parts.any { it > 255 } || parts[0] == 0 || parts[0] == 127 || parts[0] >= 224) return null
        return parts.fold(0L) { n, v -> (n shl 8) or v.toLong() }
    }
    // Numeric responder-only URLs prevent DNS rebinding and cross-host fetches.
    // All redirects are rejected by the caller. Advertised service URLs are never fetched.
    fun location(raw: String, responder: String, first: Long, last: Long): URI? = try {
        val uri = URI(raw)
        val host = uri.host ?: ""
        val number = ipv4(host)
        uri.takeIf { raw.length <= 2048 && uri.scheme in setOf("http", "https") &&
            uri.rawUserInfo == null && uri.fragment == null && host == responder &&
            number != null && number in first..last && (uri.port == -1 || uri.port in 1..65535) }
    } catch (_: Exception) { null }

    fun description(bytes: ByteArray): Map<String, Any>? = try {
        require(bytes.size <= MAX_XML)
        // Decode once and parse the SAME characters. Reject UTF-16/other byte
        // encodings, NULs and DTD declarations before Android's DOM parser.
        val xml = Charsets.UTF_8.newDecoder().onMalformedInput(CodingErrorAction.REPORT)
            .decode(ByteBuffer.wrap(bytes)).toString().removePrefix("\uFEFF")
        require(!xml.contains('\u0000') && !xml.contains(Regex("<!\\s*(DOCTYPE|ENTITY)", RegexOption.IGNORE_CASE)))
        val factory = DocumentBuilderFactory.newInstance()
        factory.isNamespaceAware = true
        factory.isExpandEntityReferences = false
        val builder = factory.newDocumentBuilder()
        builder.setEntityResolver { _, _ -> throw IllegalArgumentException("External entities prohibited") }
        val root = builder.parse(InputSource(StringReader(xml))).documentElement
        fun children(e: Element, name: String): List<Element> = (0 until e.childNodes.length)
            .mapNotNull { e.childNodes.item(it) as? Element }.filter { (it.localName ?: it.tagName) == name }
        require((root.localName ?: root.tagName) == "root")
        val device = children(root, "device").single()
        val result = linkedMapOf<String, Any>()
        for (key in listOf("deviceType", "friendlyName", "manufacturer", "manufacturerURL", "modelDescription", "modelName", "modelNumber", "modelURL", "serialNumber", "UDN", "presentationURL")) {
            val value = children(device, key).firstOrNull()?.textContent?.trim()
            if (!value.isNullOrEmpty() && value.length <= 2048) result[key] = value
        }
        val services = children(device, "serviceList").flatMap { children(it, "service") }.take(64).map { service ->
            listOf("serviceType", "serviceId", "SCPDURL", "controlURL", "eventSubURL").mapNotNull { key ->
                children(service, key).firstOrNull()?.textContent?.trim()?.take(2048)?.let { key to it }
            }.toMap()
        }
        result["serviceList"] = services
        result
    } catch (_: Exception) { null }
}
