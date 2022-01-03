package com.bbq.chicken202001;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
//import android.support.v4.app.NotificationCompat;
//import android.support.v4.app.TaskStackBuilder;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;
import androidx.core.app.TaskStackBuilder;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.RemoteMessage;

import java.util.Map;
import java.util.Random;

//fcm 참조
//https://galid1.tistory.com/421

//알림설정관련
//https://duzi077.tistory.com/191

public class FirebaseMessagingService extends com.google.firebase.messaging.FirebaseMessagingService {

    public static final String TAG = FirebaseMessagingService.class.getSimpleName();
    public FirebaseMessagingService() {

    }

    @Override
    public void onCreate() {
        super.onCreate();
        Log.e(TAG, "===> log: onCreate()");
    }

    @Override
    public void onNewToken(String s) {
        super.onNewToken(s);
        Log.e(TAG, "====> onNewToken: " + s);
    }

    //경우에 따라 FCM에서 메시지를 전달하지 못할 수 있습니다.
    // 특정 기기가 연결될 때 앱에서 대기 중인 메시지가 너무 많거나(100개 초과) 기기가 한 달 이상 FCM에 연결되지 않았기 때문일 수 있습니다.
    // 이러한 경우 FirebaseMessagingService.onDeletedMessages()에 콜백이 수신될 수 있습니다.
    // 이 콜백을 수신한 앱 인스턴스는 앱 서버와 전체 동기화를 수행해야 합니다.
    // 해당 기기의 앱으로 메시지를 보낸 지 4주 이상 경과한 경우 FCM은 onDeletedMessages()를 호출하지 않습니다.

    @Override
    public void onDeletedMessages() {
        Log.e(TAG, "Messageon DeletedMessages");
    }

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        Log.d(TAG, "From: " + remoteMessage.getFrom());
        Log.d(TAG, "Data: " + remoteMessage.getData());
        super.onMessageReceived(remoteMessage);


        //백그라운드이면 notEmpty
        //백그라운드시에는 알람이 오지 않기 때문에 아래 내용을 참조해서 처리해야함 2019-05-17
        //https://layers7.tistory.com/46?category=723406
        //http://www.trandent.com/article/android/detail/744
        //https://ckbcorp.tistory.com/1115
        //https://blogdeveloperspot.blogspot.com/2018/03/fcm-notification-foreground-background.html
        //https://distriqt.github.io/ANE-PushNotifications/m.FCM-GCM%20Payload
        //https://yenne.tistory.com/5
        //https://okky.kr/article/496381
        //https://code.i-harness.com/ko-kr/q/23f6cea
        if(remoteMessage.getData().isEmpty()) {
            showNotification(remoteMessage.getNotification().getTitle(), remoteMessage.getNotification().getBody());
        }
        else
        {
            showNotification(remoteMessage.getData());
        }
    }

    private void showNotification(Map<String, String> data) {
        String title = data.get("title").toString();
        String body = data.get("body").toString();
        String pushtype = data.get("pushType").toString(); // push type
        // String body = data.get("message").toString(); // 인자값 수정작업 진행 by dodam 2019. 06.11

        //      push click시에 메인 액티비티 보여주기 :: by dodam 2019. 06.11


//        String from=remoteMessage.getFrom();
//        Map<String, String> data=remoteMessage.getData();
//        String msg=data.get("msg");

        NotificationManager notificationManager = (NotificationManager)getSystemService(Context.NOTIFICATION_SERVICE);
        String NOTIFICATION_CHANNEL_ID = "com.bbq.chicken2019.AndroidPush";

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
        {
            // NotificationChannel notificationChannel = new NotificationChannel(NOTIFICATION_CHANNEL_ID,"Notification", NotificationManager.IMPORTANCE_MAX);
            NotificationChannel notificationChannel = new NotificationChannel(NOTIFICATION_CHANNEL_ID,"Notification", NotificationManager.IMPORTANCE_HIGH);

            notificationChannel.setDescription("BBQ Chicken Channel");
            notificationChannel.enableLights(true);
            notificationChannel.setLightColor(Color.BLUE);
            notificationChannel.setVibrationPattern(new long[]{0,1000,500,1000});
            notificationManager.createNotificationChannel(notificationChannel);
        }




        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this,NOTIFICATION_CHANNEL_ID);
        notificationBuilder.setAutoCancel(true)
                .setDefaults(Notification.DEFAULT_ALL)
                .setWhen(System.currentTimeMillis())
                .setSmallIcon(R.drawable.ic_notification)
                .setContentTitle(title)

                .setContentInfo("Infobackground");

        if(!body.isEmpty())
        {
            notificationBuilder.setContentText(body);
        }
       // notificationBuilder.setContentText(msg);




// Test 코드
        Intent intent = new Intent(this,MainActivity.class);
        intent.putExtra("PUSHTYPE",pushtype);

        intent.setAction(Intent.ACTION_MAIN);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);

        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0 /* Request code */, intent,
                PendingIntent.FLAG_UPDATE_CURRENT);

           notificationBuilder.setContentIntent(pendingIntent);


        TaskStackBuilder stackBuilder = TaskStackBuilder.create(this);
        stackBuilder.addParentStack(MainActivity.class);
        stackBuilder.addNextIntent(intent);
        PendingIntent pi = stackBuilder.getPendingIntent(0,
                PendingIntent.FLAG_UPDATE_CURRENT);
        notificationBuilder.setContentIntent(pi);

        // mNM.notify(mId, builder.build());

//                .setContentIntent(pendingIntent);
// Test Code !!

        notificationManager.notify(new Random().nextInt(),notificationBuilder.build());
//        notificationManager.notify(1,notificationBuilder.build());





    }


    private void showNotification(String title, String body) {
        NotificationManager notificationManager = (NotificationManager)getSystemService(Context.NOTIFICATION_SERVICE);
        String NOTIFICATION_CHANNEL_ID = "com.bbq.chicken2019.AndroidPush";





        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
        {
            NotificationChannel notificationChannel = new NotificationChannel(NOTIFICATION_CHANNEL_ID,"Notification",NotificationManager.IMPORTANCE_HIGH);

            notificationChannel.setDescription("BBQ Chicken Channel");
            notificationChannel.enableLights(true);
            notificationChannel.setLightColor(Color.BLUE);
            notificationChannel.setVibrationPattern(new long[]{0,1000,500,1000});
            notificationManager.createNotificationChannel(notificationChannel);
        }

        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this,NOTIFICATION_CHANNEL_ID);
        notificationBuilder.setAutoCancel(true)
                .setDefaults(Notification.DEFAULT_ALL)
                .setWhen(System.currentTimeMillis())
                .setSmallIcon(R.drawable.ic_notification)
                .setContentTitle(title)
                .setContentInfo("Info");
        if(!body.isEmpty())
        {
            notificationBuilder.setContentText(body);
        }

        //Intent intent = new Intent(this,MainActivity.class);
        Intent intent = new Intent(this,MainActivity.class);
        intent.setAction(Intent.ACTION_MAIN);
        intent.setFlags( Intent.FLAG_ACTIVITY_SINGLE_TOP | Intent.FLAG_ACTIVITY_CLEAR_TOP);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0 /* Request code */, intent,
                PendingIntent.FLAG_UPDATE_CURRENT);
        notificationBuilder.setContentIntent(pendingIntent);




        notificationManager.notify(new Random().nextInt(),notificationBuilder.build());
      //  notificationManager.notify(1,notificationBuilder.build());

    }

}
