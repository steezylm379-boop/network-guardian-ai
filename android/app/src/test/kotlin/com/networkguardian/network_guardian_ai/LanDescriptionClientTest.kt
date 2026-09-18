package com.networkguardian.network_guardian_ai

import org.junit.Assert.*
import org.junit.Test
import java.net.HttpURLConnection
import java.net.URI
import java.net.URL
import java.io.InputStream
import java.io.ByteArrayInputStream
import java.io.IOException
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicBoolean

class LanDescriptionClientTest {
    private val uri = URI("http://192.168.1.2/root.xml")
    private open class Response(private val status: Int = 200, private val data: ByteArray = "<root><device><modelName>Example</modelName></device></root>".toByteArray()) : HttpURLConnection(URL("http://192.168.1.2/root.xml")) {
        var disconnected = false; var readBody = false
        override fun connect() {}
        override fun disconnect() { disconnected = true }
        override fun usingProxy() = false
        override fun getResponseCode() = status
        override fun getContentLengthLong() = data.size.toLong()
        override fun getInputStream(): InputStream { readBody = true; return ByteArrayInputStream(data) }
    }
    @Test fun rejectsAllRedirectsWithoutReadingOrFollowingLocation() {
        for (code in listOf(301, 302, 303, 307, 308)) {
            val response = Response(code); var opens = 0
            val client = LanDescriptionClient(AtomicBoolean(false), { 0L }) { opens++; response }
            assertNull(client.fetch(uri, 1000)); assertFalse(response.instanceFollowRedirects)
            assertFalse(response.readBody); assertEquals(1, opens); assertTrue(response.disconnected)
        }
    }
    @Test fun fetchesBoundedDescriptionAndAlwaysCloses() {
        val response = Response()
        val client = LanDescriptionClient(AtomicBoolean(false), { 0L }) { response }
        assertEquals("Example", client.fetch(uri, 1000)!!["modelName"])
        assertEquals(800, response.connectTimeout); assertEquals(800, response.readTimeout); assertTrue(response.disconnected)
    }
    @Test fun rejectsOversizedResponseAndExpiredDeadline() {
        val large = Response(data = ByteArray(IntelligenceParsers.MAX_XML + 1))
        val client = LanDescriptionClient(AtomicBoolean(false), { 0L }) { large }
        assertNull(client.fetch(uri, 1000)); assertFalse(large.readBody)
        var opened = false
        val expired = LanDescriptionClient(AtomicBoolean(false), { 1000L }) { opened = true; Response() }
        assertNull(expired.fetch(uri, 1000)); assertFalse(opened)
    }
    @Test fun cancellationDisconnectsPendingPhaseTwoRequest() {
        val started = CountDownLatch(1); val closed = CountDownLatch(1); val finished = CountDownLatch(1)
        val stopped = AtomicBoolean(false)
        val response = object : Response() {
            override fun getInputStream(): InputStream = object : InputStream() {
                override fun read(): Int { started.countDown(); closed.await(2, TimeUnit.SECONDS); throw IOException("closed") }
            }
            override fun disconnect() { super.disconnect(); closed.countDown() }
        }
        val client = LanDescriptionClient(stopped, { 0L }) { response }
        val worker = Thread { try { assertNull(client.fetch(uri, 1000)) } finally { finished.countDown() } }
        worker.start(); assertTrue(started.await(2, TimeUnit.SECONDS))
        stopped.set(true); client.cancel()
        assertTrue(finished.await(2, TimeUnit.SECONDS)); assertTrue(response.disconnected)
    }
}
