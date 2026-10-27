package com.alirezamolayari.caspianowner

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import androidx.core.content.ContextCompat
import androidx.core.os.BundleCompat
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status
import io.flutter.plugin.common.MethodChannel

/**
 * SMS User Consent API: when the code SMS arrives, Android asks the owner
 * once whether the app may read that one message. No SMS permission.
 * Channel `caspian/sms_consent`: `start` answers with the message text
 * (or null: declined, timed out, no Google Play services), `stop` gives up.
 *
 * Uses `play-services-auth-api-phone`, the app's only Google Play services
 * library. Phones without it simply get null and the owner types the code.
 */
class SmsConsent(private val activity: Activity) {
    private var pending: MethodChannel.Result? = null
    private var receiver: BroadcastReceiver? = null

    // Each start() is one wait; late callbacks of an older wait (e.g. after
    // «ارسال دوباره کد») must not end the newer one.
    private var attempt = 0

    fun start(result: MethodChannel.Result) {
        finish(null)
        val current = ++attempt
        pending = result
        val listener = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                if (intent.action != SmsRetriever.SMS_RETRIEVED_ACTION) return
                val extras = intent.extras ?: return finish(null)
                val status = BundleCompat.getParcelable(
                    extras, SmsRetriever.EXTRA_STATUS, Status::class.java,
                )
                if (status?.statusCode != CommonStatusCodes.SUCCESS) return finish(null)
                val consent = BundleCompat.getParcelable(
                    extras, SmsRetriever.EXTRA_CONSENT_INTENT, Intent::class.java,
                )
                if (consent == null || !fromPlayServices(consent)) return finish(null)
                try {
                    @Suppress("DEPRECATION")
                    activity.startActivityForResult(consent, REQUEST_CONSENT)
                } catch (e: ActivityNotFoundException) {
                    finish(null)
                }
            }
        }
        try {
            ContextCompat.registerReceiver(
                activity,
                listener,
                IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION),
                SmsRetriever.SEND_PERMISSION,
                null,
                ContextCompat.RECEIVER_EXPORTED,
            )
            receiver = listener
            SmsRetriever.getClient(activity)
                .startSmsUserConsent(null)
                .addOnFailureListener { if (attempt == current) finish(null) }
        } catch (e: RuntimeException) {
            // No Google Play services on this phone.
            finish(null)
        }
    }

    fun stop() = finish(null)

    /** True when [requestCode] was ours. */
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST_CONSENT) return false
        finish(
            if (resultCode == Activity.RESULT_OK) {
                data?.getStringExtra(SmsRetriever.EXTRA_SMS_MESSAGE)
            } else {
                null
            },
        )
        return true
    }

    private fun finish(message: String?) {
        receiver?.let { runCatching { activity.unregisterReceiver(it) } }
        receiver = null
        pending?.success(message)
        pending = null
    }

    // Only open the consent screen if it really is Google Play services
    // (and it asks for no file access): another app can't slip in its own.
    private fun fromPlayServices(intent: Intent): Boolean {
        val target = intent.resolveActivity(activity.packageManager) ?: return false
        val grants = Intent.FLAG_GRANT_READ_URI_PERMISSION or
            Intent.FLAG_GRANT_WRITE_URI_PERMISSION
        return target.packageName == "com.google.android.gms" && intent.flags and grants == 0
    }

    private companion object {
        const val REQUEST_CONSENT = 4271
    }
}
