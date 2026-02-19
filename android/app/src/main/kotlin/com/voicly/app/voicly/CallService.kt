package com.voicly.app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.IBinder

class CallService : Service() {
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == "STOP") {
            stopForeground(STOP_FOREGROUND_REMOVE)
            stopSelf()
            return START_NOT_STICKY
        }
        val channel = NotificationChannel(
            "voicly_call",
            "Active Call",
            NotificationManager.IMPORTANCE_MIN
        )
        channel.setShowBadge(false)
        channel.setSound(null, null)
        getSystemService(NotificationManager::class.java)
            .createNotificationChannel(channel)

        val notification = Notification.Builder(this, "voicly_call")
            .setContentTitle("Voicly")
            .setContentText("Call in progress")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setVisibility(Notification.VISIBILITY_SECRET)
            .build()

        startForeground(888, notification,
            android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE)

        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null
}