package com.bbq.chicken202001;

import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.AsyncTask;

import android.os.Handler;
//import android.support.v7.app.AlertDialog;
//import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.remoteconfig.FirebaseRemoteConfig;
import com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings;
//import com.google.firebase.remoteconfig.FirebaseRemoteConfig;
//import com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings;

import java.io.IOException;
import java.util.HashMap;
import java.util.regex.Pattern;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;



public class SplashScreenActivity extends AppCompatActivity {

    // Package Version Check
    String marketVersion, deviceVersion;
    final String marketURL = "https://play.google.com/store/apps/details?id=com.bbq.chicken202001";


    //
    // override
    //

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash_screen);

        //
        // 1. Package Version Check
        //
        try {
            PackageInfo pInfo = getPackageManager().getPackageInfo(getPackageName(), PackageManager.GET_META_DATA);
            deviceVersion = pInfo.versionName;         // versionName은 1.0.4와 version을 표시하는 String
            //Log.e("version", "device_version >> versionName : " + pinfo.versionName + "  versionCode : " + pinfo.versionCode);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        //
        // 2. cloud 버전 획득
        //
        getMarketVersion();
    }

    @Override
    public void finish() {
        super.finish();
        this.overridePendingTransition(R.anim.fade_in, R.anim.fade_out);
    }


    //
    // private 함수 정의
    //


    /*-----------------------------------------------------------------------
     * firebase 버전 정보 획득
     *-----------------------------------------------------------------------*/
    private void getMarketVersion() {
        // [파이어베이스에 등록된 key 정의]
        String key   = "AosVersion";
        String value = "0.0.0";

        //
        // 1. 파이어베이스 리모트 객체 생성 실시 (TODO:
        //
        FirebaseRemoteConfig config = FirebaseRemoteConfig.getInstance();
        FirebaseRemoteConfigSettings configSettings = new FirebaseRemoteConfigSettings
                .Builder()
                .setMinimumFetchIntervalInSeconds(60*10*6*24)
                .build();

        // setMinimumFetchIntervalInSeconds(0)       // 실행시마다 체크
        // setMinimumFetchIntervalInSeconds(60 * 10) // 10 mins

        //
        // 2. 디폴트 값 삽입
        //
        HashMap defaultMap = new HashMap <String, String>();
        defaultMap.put(key, value);
        config.setDefaultsAsync(defaultMap);
        config.setConfigSettingsAsync(configSettings);


        //
        // 3. 최신 앱 버전 확인 이벤트 리스너 수행 실시
        //
        config.fetchAndActivate().addOnCompleteListener(
                SplashScreenActivity.this, // [액티비티]
                new OnCompleteListener<Boolean>() { // [이벤트 리스너]
                    @Override
                    public void onComplete(@NonNull Task<Boolean> task) {

                        // 3.1 해당 키값 확인 성공
                        if (task.isSuccessful()) {
                            marketVersion = config.getString("AosVersion");
                        }
                        // 3.2 해당 키값 확인 실패
                        else {
                            marketVersion = "";
                        }

                        // 3.3 버전 비교
                        compareVersion();
                    }
                });

    }


    /*-----------------------------------------------------------------------
     * 버전 비교
     *-----------------------------------------------------------------------*/
    private void compareVersion() {

        if (marketVersion.equals("")) {
            goMain();
            return;
        }

        //
        // 버전같은 경우 - 메인으로 이동
        //
        if (marketVersion.equals(deviceVersion)) {
            goMain();
        }

        //
        // 버전 다른 경우
        //
        else {
            showAlert();
        }
    }


    private void goMain() {
        Intent intent = new Intent(getApplicationContext(), MainActivity.class);
        System.out.println("================ startActivity(main) ==================");
        startActivity(intent);
        Log.e(this.getClass().getName() , "===========startActivity"  );
        finish();
    }


    /*-----------------------------------------------------------------------
     * alert 보여준다. (play store로 이동)
     *-----------------------------------------------------------------------*/
    private void showAlert() {
        AlertDialog.Builder dialog;
        dialog = new AlertDialog.Builder(this);

        dialog.setMessage("버전을 업데이트 후 사용해주세요.")
                .setCancelable(true)
                .setPositiveButton("바로가기",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog,
                                                int id) {
                                Intent marketLaunch = new Intent(Intent.ACTION_VIEW);
                                marketLaunch.setData(Uri
                                        .parse(marketURL));
                                startActivity(marketLaunch);
                                finish();
                            }
                        })/*.setNegativeButton("닫기", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialogInterface, int i) {
                dialogInterface.dismiss();
//                Handler handler = new Handler();
//                handler.postDelayed(new splashhandler(), 2000);
            }
        })*/;
        AlertDialog alert = dialog.create();
        alert.setTitle("안 내");
        alert.show();
    }


//    private class splashhandler implements Runnable{
//        @Override
//        public void run() {
//            System.out.println("================ SplashScreenActivity run ==================");
//            Intent intent = new Intent(getApplicationContext(),
//                    MainActivity.class);
//            System.out.println("================ startActivity(main) ==================");
//            startActivity(intent);
//            Log.e(this.getClass().getName() , "===========startActivity"  );
//            finish();
//        }
//    }


    // Package Version Check
//    private class getMarketVersion extends AsyncTask<Void, Void, String> {
//
//        @Override
//        protected void onPreExecute() {
//            super.onPreExecute();
//        }
//
//        @Override
//        protected String doInBackground(Void... params) {
//            try {

                /*
                Document doc = Jsoup
                        .connect("https://play.google.com/store/apps/details?id=com.bbq.chicken202001")
                        .get();

                Elements VersionDiv= doc.select(".BgcNfc");
                Elements Version = doc.select("div.hAyfc div span.htlgb");
                for (int i =0; i<VersionDiv.size(); i++){
                    if(VersionDiv.get(i).text().equals("Current Version")){
                        return Version.get(i).text();
                    }
                }
                */

                /*
                // [파이어베이스에 등록된 key 정의]
                String key = "app_version_aos";
                String value = "0.0.0";


                // [파이어베이스 리모트 객체 생성 실시]
                FirebaseRemoteConfig config = FirebaseRemoteConfig.getInstance();
                FirebaseRemoteConfigSettings configSettings = new FirebaseRemoteConfigSettings
                        .Builder()
                        .setMinimumFetchIntervalInSeconds(0)
                        .build();


                // [해당 키값이 없을 경우 디폴트 값 삽입]
                HashMap defaultMap = new HashMap <String, String>();
                //defaultMap.put("app_version_aos", "0.0.0");
                defaultMap.put(key, value);
                config.setDefaultsAsync(defaultMap);
                config.setConfigSettingsAsync(configSettings);


                // [최신 앱 버전 확인 이벤트 리스너 수행 실시]
                config.fetchAndActivate().addOnCompleteListener(
                        SplashScreenActivity.this, // [액티비티]
                        new OnCompleteListener<Boolean>() { // [이벤트 리스너]
                            @Override
                            public void onComplete(@NonNull Task<Boolean> task) {
                                if (task.isSuccessful()) { // [해당 키값 확인 성공]
                                    Log.i("---","---");
                                    Log.w("//===========//","================================================");
                                    Log.i("","\n"+"[A_Intro >> checkUpdateMobileVersion() :: 파이어베이스 리모트 앱 최신 버전 체크 성공]");
                                    Log.i("","\n"+"[version :: "+String.valueOf(config.getString("app_version_aos"))+"]");
                                    Log.w("//===========//","================================================");
                                    Log.i("---","---");
                                    String version = config.getString("AosVersion");
                                    Log.d("smpark", version);
                                }
                                else { // [해당 키값 확인 실패]
                                    Log.i("---","---");
                                    Log.e("//===========//","================================================");
                                    Log.i("","\n"+"[A_Intro >> checkUpdateMobileVersion() :: 파이어베이스 리모트 앱 최신 버전 체크 실패]");
                                    Log.i("","\n"+"[default :: "+String.valueOf(defaultMap.toString())+"]");
                                    Log.e("//===========//","================================================");
                                    Log.i("---","---");
                                }
                            }
                        });
                */


                /*Document doc = Jsoup
                            .connect("http://mtest.bbq.co.kr/app_version.htm")
                            .get();

                Elements VersionDiv= doc.select("div");
                Elements Version = doc.select("span");
                System.out.println("============VersionDiv.size():"+ VersionDiv.size());
                for (int i =0; i<VersionDiv.size(); i++){
                    if(VersionDiv.get(i).text().contains("Current Version")){
                        return Version.get(i).text();
                    }
                }*/




//                Log.e("marketVersion", "marketVersion : " + marketVersion);
//                return marketVersion;
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
//            return null;
//        }
//
//        @Override
//        protected void onPostExecute(String result) {
//
//            PackageInfo pi = null;
//            try {
//                pi = getPackageManager().getPackageInfo(getPackageName(), 0);
//
//                Log.e(this.getClass().getName() , "=========== pi " + pi);
//            } catch (PackageManager.NameNotFoundException e) {
//                e.printStackTrace();
//            }
//            deviceVersion = pi.versionName;
//            Log.e(this.getClass().getName() , "=========== deviceVersion " + deviceVersion);
//            marketVersion = result;
//            Log.e(this.getClass().getName() , "=========== result " + result);
//            if (marketVersion != null) {
//                if (!deviceVersion.equals(marketVersion)) {
//                    if (marketVersion.compareTo(deviceVersion) > 0) {
//                        mDialog.setMessage("버전을 업데이트 후 사용해주세요.")
//                                .setCancelable(true)
//                                .setPositiveButton("바로가기",
//                                        new DialogInterface.OnClickListener() {
//                                            public void onClick(DialogInterface dialog,
//                                                                int id) {
//                                                Intent marketLaunch = new Intent(
//                                                        Intent.ACTION_VIEW);
//                                                marketLaunch.setData(Uri
//                                                        .parse("https://play.google.com/store/apps/details?id=com.bbq.chicken202001"));
//                                                startActivity(marketLaunch);
//                                                finish();
//                                            }
//                                        }).setNegativeButton("닫기", new DialogInterface.OnClickListener() {
//                            @Override
//                            public void onClick(DialogInterface dialogInterface, int i) {
//                                dialogInterface.dismiss();
//                                Handler handler = new Handler();
//                                handler.postDelayed(new splashhandler(), 2000);
//                            }
//                        });
//                        AlertDialog alert = mDialog.create();
//                        alert.setTitle("안 내");
//                        alert.show();
//                    } else {
//                        // Splash Screen
//                        Handler handler = new Handler();
//                        handler.postDelayed(new splashhandler(), 2000);
//
//                        //goMainActivity();
//                    }
//                } else {
//                    // Splash Screen
//                    Handler handler = new Handler();
//                    handler.postDelayed(new splashhandler(), 2000);
//
//                    //goMainActivity();
//                }
//            }else {
//                Handler handler = new Handler();
//                handler.postDelayed(new splashhandler(), 2000);
//            }
//
//            super.onPostExecute(result);
//        }
//    }

//
//    // Package Version Check
//    public int versionCompare(String storeVersion, String currentVersion) {
//        String[] vals1 = storeVersion.split("\\.");
//        String[] vals2 = currentVersion.split("\\.");
//
//        int i = 0;
//        // set index to first non-equal ordinal or length of shortest version string
//        while (i < vals1.length && i < vals2.length && vals1[i].equals(vals2[i])) {
//            i++;
//        }
//
//        // compare first non-equal ordinal number
//        if (i < vals1.length && i < vals2.length) {
//            int diff = Integer.valueOf(vals1[i]).compareTo(Integer.valueOf(vals2[i]));
//            return Integer.signum(diff);
//        }
//
//        // the strings are equal or one string is a substring of the other
//        // e.g. "1.2.3" = "1.2.3" or "1.2.3" < "1.2.3.4"
//        return Integer.signum(vals1.length - vals2.length);
//    }
}
