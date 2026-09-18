package com.networkguardian.network_guardian_ai

import org.junit.Assert.*
import org.junit.Test

class DiscoveryParsingTest {
    @Test fun ipv4RoundTrip() {
        assertEquals(3232236290L, DiscoveryBridge.numeric("192.168.3.2"))
        assertEquals("192.168.3.2", DiscoveryBridge.format(3232236290L))
    }
    @Test fun ptrRejectsMismatchedTransactionAndTruncation() {
        assertNull(HostnameResolver.parsePtr(byteArrayOf(0, 1, 2), 1))
        val reply = byteArrayOf(0, 2, 0x80.toByte(), 0, 0, 0, 0, 0, 0, 0, 0, 0)
        assertNull(HostnameResolver.parsePtr(reply, 1))
    }
    @Test fun ptrExtractsAnswerAndRejectsCompressionLoop() {
        val bytes = java.io.ByteArrayOutputStream()
        val out = java.io.DataOutputStream(bytes)
        out.writeShort(123); out.writeShort(0x8180); out.writeShort(0); out.writeShort(1)
        out.writeShort(0); out.writeShort(0)
        out.writeByte(0); out.writeShort(12); out.writeShort(1); out.writeInt(60)
        out.writeShort(10); out.writeByte(2); out.writeBytes("tv"); out.writeByte(5); out.writeBytes("local"); out.writeByte(0)
        assertEquals("tv.local", HostnameResolver.parsePtr(bytes.toByteArray(), 123))
        val loop = bytes.toByteArray(); loop[12] = 0xc0.toByte(); loop[13] = 12
        assertNull(HostnameResolver.parsePtr(loop, 123))
    }
}
