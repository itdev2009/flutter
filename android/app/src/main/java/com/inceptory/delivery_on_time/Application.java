package com.inceptory.delivery_on_time;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.graphics.Color;
import android.os.Build;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
//import io.inway.ringtone.player.FlutterRingtonePlayerPlugin;
import me.carda.awesome_notifications.AwesomeNotificationsPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;


public class Application extends FlutterApplication implements PluginRegistrantCallback {
    @Override
    public void onCreate() {
        super.onCreate();
        //this.createChannel();
        FlutterFirebaseMessagingService.setPluginRegistrant(this);
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
//        PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
        //FlutterRingtonePlayerPlugin.registerWith(registry.registrarFor("io.inway.ringtone.player.FlutterRingtonePlayerPlugin"));
        AwesomeNotificationsPlugin.registerWith(registry.registrarFor("me.carda.awesome_notifications.AwesomeNotificationsPlugin"));
        SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    }
//    private void createChannel(){
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            // Create the NotificationChannel
//            String name = getString(R.string.default_notification_channel_id1);
//            NotificationChannel channel = new NotificationChannel(name, "default", NotificationManager.IMPORTANCE_HIGH);
//            NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
//
////            Notification notification = new Notification.Builder(MainActivity.this)
////                    .setSmallIcon(R.drawable.res_launcher_icondotmer)
////                    .build();
//
//            notificationManager.createNotificationChannel(channel);
//
//        }
//    }
}