package com.aeos.konata

import android.content.Context
import android.media.AudioManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import android.util.Log
import android.os.Build
import android.app.NotificationManager
import android.content.Intent

class MainActivity: FlutterActivity(){
    private val CHANNEL = "com.aeos.konata/audio_manager"

    private var currentRinVolume: Int = 0
    private var currentNotificationVolume: Int = 0
    private var currentSystemVolume: Int = 0
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "muteRingtone") {
                muteRingtone()
                result.success(null)
            }
            else if (call.method == "unmuteRingtone") {
                unmuteRingtone()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun muteRingtone() {
        
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager              
        
        //before mutes get current volume
        if(currentRinVolume == 0)
            currentRinVolume = audioManager.getStreamVolume(AudioManager.STREAM_RING)
        if(currentNotificationVolume == 0)
            currentNotificationVolume = audioManager.getStreamVolume(AudioManager.STREAM_NOTIFICATION)
        if(currentSystemVolume == 0)            
            currentSystemVolume = audioManager.getStreamVolume(AudioManager.STREAM_SYSTEM)        

        Log.d("TAG", "RING" + currentRinVolume.toString());
        Log.d("TAG", "NOTIFICATION" + currentNotificationVolume.toString());
        Log.d("TAG", "SYSTEM" + currentSystemVolume.toString());

        //audioManager.setRingerMode(AudioManager.RINGER_MODE_SILENT);   
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            audioManager.adjustStreamVolume(AudioManager.STREAM_NOTIFICATION, AudioManager.ADJUST_MUTE, AudioManager.FLAG_REMOVE_SOUND_AND_VIBRATE)        
            audioManager.adjustStreamVolume(AudioManager.STREAM_SYSTEM, AudioManager.ADJUST_MUTE, AudioManager.FLAG_REMOVE_SOUND_AND_VIBRATE)
            audioManager.adjustStreamVolume(AudioManager.STREAM_RING, AudioManager.ADJUST_MUTE, AudioManager.FLAG_REMOVE_SOUND_AND_VIBRATE)
        }
        else {
            audioManager.adjustStreamVolume(AudioManager.STREAM_NOTIFICATION, AudioManager.ADJUST_MUTE, 0)        
            audioManager.adjustStreamVolume(AudioManager.STREAM_SYSTEM, AudioManager.ADJUST_MUTE, 0)
            audioManager.adjustStreamVolume(AudioManager.STREAM_RING, AudioManager.ADJUST_MUTE, 0)

            //audioManager.adjustStreamVolume(AudioManager.STREAM_ALARM, AudioManager.ADJUST_MUTE, 0)
            //audioManager.adjustStreamVolume(AudioManager.STREAM_DTMF, AudioManager.ADJUST_MUTE, 0)
            //audioManager.adjustStreamVolume(AudioManager.STREAM_ALARM, AudioManager.ADJUST_MUTE, 0)
            //audioManager.setStreamVolume(AudioManager.STREAM_MUSIC, AudioManager.ADJUST_MUTE, 0);  

            //audioManager.setStreamMute(AudioManager.STREAM_RING, true)
            //audioManager.setStreamMute(AudioManager.STREAM_NOTIFICATION, true)        
            //audioManager.setStreamMute(AudioManager.STREAM_SYSTEM, true)
        }                         
        Log.d("TAG", "your log message");
    }    
    
    /**
     * unmuteRingtone
     * 
     * Restore the volume of the ringtone, notification and system to the value before calling muteRingtone().
     */
    private fun unmuteRingtone() {        
        Log.d("TAG", "RING-2:" + currentRinVolume.toString());
        Log.d("TAG", "NOTIFICATION-2:" + currentNotificationVolume.toString());
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        audioManager.setStreamVolume(AudioManager.STREAM_RING, currentRinVolume, 0)
        audioManager.setStreamVolume(AudioManager.STREAM_NOTIFICATION, currentNotificationVolume, 0)
        audioManager.setStreamVolume(AudioManager.STREAM_SYSTEM, currentSystemVolume, 0)
    }
}
