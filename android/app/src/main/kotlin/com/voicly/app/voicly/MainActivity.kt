package com.voicly.app
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.voicly.app/call_service")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startCallService" -> {
                        startService(Intent(this, CallService::class.java))
                        result.success(null)
                    }
                    "stopCallService" -> {
                        val intent = Intent(this, CallService::class.java)
                        intent.action = "STOP"
                        startService(intent)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}