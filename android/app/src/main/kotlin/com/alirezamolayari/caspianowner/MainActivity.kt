package com.alirezamolayari.caspianowner

import android.content.ActivityNotFoundException
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import android.view.WindowManager
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

// FlutterFragmentActivity (not FlutterActivity) is required by local_auth.
class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger

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

        // Background notifications: what can stop the 15-minute check on
        // this phone, and the system pages that fix it
        // (Settings › «اعلان وقتی برنامه بسته است»).
        MethodChannel(messenger, "caspian/background").setMethodCallHandler { call, result ->
            when (call.method) {
                "status" -> {
                    val power = getSystemService(Context.POWER_SERVICE) as PowerManager
                    result.success(
                        mapOf(
                            "notificationsAllowed" to
                                NotificationManagerCompat.from(this).areNotificationsEnabled(),
                            "batteryUnrestricted" to
                                power.isIgnoringBatteryOptimizations(packageName),
                            "hasAutostart" to hasAutostartSwitch(),
                        )
                    )
                }
                "openNotificationSettings" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        openFirst(
                            Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                                .putExtra(Settings.EXTRA_APP_PACKAGE, packageName),
                            appDetails(),
                        )
                    } else {
                        openFirst(appDetails())
                    }
                    result.success(null)
                }
                "openBatterySettings" -> {
                    // Asks directly; if the phone blocks that, the full list.
                    openFirst(
                        Intent(
                            Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS,
                            Uri.parse("package:$packageName"),
                        ),
                        Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS),
                        appDetails(),
                    )
                    result.success(null)
                }
                "openAutostartSettings" -> {
                    // MIUI / HyperOS «Autostart» list; else the app's info page.
                    openFirst(
                        Intent().setComponent(
                            ComponentName(
                                "com.miui.securitycenter",
                                "com.miui.permcenter.autostart.AutoStartManagementActivity",
                            )
                        ),
                        appDetails(),
                    )
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    /// Xiaomi, Redmi and POCO phones never start the background check while
    /// the app's «Autostart» switch is off, and apps can't read that switch.
    private fun hasAutostartSwitch(): Boolean =
        Build.MANUFACTURER.lowercase() in setOf("xiaomi", "redmi", "poco")

    private fun appDetails(): Intent =
        Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse("package:$packageName"))

    /// Opens the first of [intents] this phone has.
    private fun openFirst(vararg intents: Intent) {
        for (intent in intents) {
            try {
                startActivity(intent)
                return
            } catch (e: ActivityNotFoundException) {
                // Not on this phone: try the next one.
            } catch (e: SecurityException) {
                // Not allowed for this app: try the next one.
            }
        }
    }
}
