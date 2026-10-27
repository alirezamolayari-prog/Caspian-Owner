package com.alirezamolayari.caspianowner

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.view.WindowManager
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

// FlutterFragmentActivity (not FlutterActivity) is required by local_auth.
class MainActivity : FlutterFragmentActivity() {
    private val smsConsent = SmsConsent(this)

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger

        // Fills in the SMS code after the owner allows reading that message.
        MethodChannel(messenger, "caspian/sms_consent").setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> smsConsent.start(result)
                "stop" -> {
                    smsConsent.stop()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        // Blocks screenshots and the recent-apps preview on sensitive screens.
        MethodChannel(messenger, "caspian/secure_screen").setMethodCallHandler { call, result ->
            when (call.method) {
                "setSecure" -> {
                    if (call.arguments as? Boolean == true) {
                        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    } else {
                        window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    }
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        // In-app updates: hands the verified APK to the system installer.
        MethodChannel(messenger, "caspian/installer").setMethodCallHandler { call, result ->
            when (call.method) {
                "canRequestInstall" -> result.success(
                    Build.VERSION.SDK_INT < Build.VERSION_CODES.O ||
                        packageManager.canRequestPackageInstalls()
                )
                "openInstallSettings" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startActivity(
                            Intent(
                                Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
                                Uri.parse("package:$packageName"),
                            )
                        )
                    }
                    result.success(null)
                }
                "install" -> {
                    val path = call.arguments as? String
                    if (path == null) {
                        result.error("bad_args", "APK path missing", null)
                    } else {
                        val uri = FileProvider.getUriForFile(
                            this,
                            "$packageName.updates",
                            File(path),
                        )
                        startActivity(
                            Intent(Intent.ACTION_VIEW)
                                .setDataAndType(uri, "application/vnd.android.package-archive")
                                .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        )
                        result.success(null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    @Deprecated("Needed for the SMS consent screen's result")
    @Suppress("DEPRECATION")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (!smsConsent.onActivityResult(requestCode, resultCode, data)) {
            super.onActivityResult(requestCode, resultCode, data)
        }
    }

    override fun onDestroy() {
        smsConsent.stop()
        super.onDestroy()
    }
}
