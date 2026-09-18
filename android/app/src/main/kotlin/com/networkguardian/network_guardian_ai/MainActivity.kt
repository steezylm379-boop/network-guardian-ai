package com.networkguardian.network_guardian_ai

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var discovery: DiscoveryBridge? = null
    private var diagnostics: DiagnosticsBridge? = null
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        discovery = DiscoveryBridge(this, flutterEngine.dartExecutor.binaryMessenger)
        diagnostics = DiagnosticsBridge(this, flutterEngine.dartExecutor.binaryMessenger)
    }
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        discovery?.permissions(requestCode, grantResults)
    }
    override fun onDestroy() { discovery?.dispose(); diagnostics?.dispose(); super.onDestroy() }
}
