package com.networkguardian.network_guardian_ai

import org.junit.Assert.*
import org.junit.Test

class IntelligenceParsingTest {
    @Test fun parsesSsdpHeadersCaseInsensitively() {
        val headers = IntelligenceParsers.ssdp("HTTP/1.1 200 OK\r\nST: upnp:rootdevice\r\nUsn: uuid:abc\r\nLOCATION: http://192.168.1.2/root.xml\r\nSERVER: test\r\nCACHE-CONTROL: max-age=1800\r\nEXT:\r\n\r\n".toByteArray())!!
        assertEquals("uuid:abc", headers["usn"]); assertEquals("", headers["ext"])
        assertEquals(6, headers.size)
    }
    @Test fun rejectsMalformedSsdp() {
        for (raw in listOf("garbage", "HTTP/1.1 404 Missing\r\n", "HTTP/1.1 200 OK\r\nBad Header\r\n", "HTTP/1.1 200 OK\r\nST: root\r\nUSN: x\r\nLOCATION: a\r\nLOCATION: b\r\n")) assertNull(IntelligenceParsers.ssdp(raw.toByteArray()))
        assertNull(IntelligenceParsers.ssdp(ByteArray(8193)))
    }
    @Test fun restrictsLocationToNumericResponderOnSelectedLan() {
        val first = IntelligenceParsers.ipv4("192.168.1.1")!!; val last = IntelligenceParsers.ipv4("192.168.1.254")!!
        assertNotNull(IntelligenceParsers.location("http://192.168.1.2:8080/root.xml", "192.168.1.2", first, last))
        for (url in listOf("http://8.8.8.8/a", "http://192.168.1.3/a", "http://localhost/a", "http://192.168.1.2.evil.test/a", "http://user:pass@192.168.1.2/a", "file:///etc/passwd", "http://127.0.0.1/a", "http://192.168.1.2:0/a", "http://192.168.1.2/a#fragment", "http://3232235778/a")) assertNull(url, IntelligenceParsers.location(url, "192.168.1.2", first, last))
    }
    @Test fun parsesRootDescriptionWithoutMixingEmbeddedDevice() {
        val xml = """<root xmlns="urn:schemas-upnp-org:device-1-0"><device><deviceType>urn:schemas-upnp-org:device:MediaRenderer:1</deviceType><friendlyName>Living &amp; Room</friendlyName><manufacturer>Sony</manufacturer><manufacturerURL>https://example.com</manufacturerURL><modelDescription>TV</modelDescription><modelName>Reported Model</modelName><modelNumber>123</modelNumber><modelURL>/model</modelURL><serialNumber>serial</serialNumber><UDN>uuid:device-123</UDN><presentationURL>/</presentationURL><serviceList><service><serviceType>RenderingControl</serviceType><serviceId>control</serviceId><SCPDURL>/service.xml</SCPDURL><controlURL>/control</controlURL><eventSubURL>/events</eventSubURL></service></serviceList><deviceList><device><modelName>Wrong embedded model</modelName></device></deviceList></device></root>"""
        val result = IntelligenceParsers.description(xml.toByteArray())!!
        assertEquals("Living & Room", result["friendlyName"]); assertEquals("Reported Model", result["modelName"])
        assertEquals(12, result.size); assertEquals(1, (result["serviceList"] as List<*>).size)
    }
    @Test fun rejectsMalformedOversizedAndExternalEntityXml() {
        assertNull(IntelligenceParsers.description("<root><device>".toByteArray()))
        assertNull(IntelligenceParsers.description(ByteArray(IntelligenceParsers.MAX_XML + 1)))
        assertNull(IntelligenceParsers.description("<!DOCTYPE root [<!ENTITY x SYSTEM 'file:///etc/passwd'>]><root><device><modelName>&x;</modelName></device></root>".toByteArray()))
        assertNull(IntelligenceParsers.description("<root><device/><device/></root>".toByteArray()))
    }
}
