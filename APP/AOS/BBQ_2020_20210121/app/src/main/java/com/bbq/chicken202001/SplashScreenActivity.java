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

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import java.io.IOException;
import java.util.regex.Pattern;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;

public class SplashScreenActivity extends AppCompatActivity {

    // Package Version Check
    String marketVersion, deviceVersion;
    AlertDialog.Builder mDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash_screen);

        // Package Version Check
        try {
            PackageInfo pinfo = getPackageManager().getPackageInfo(getPackageName(), PackageManager.GET_META_DATA);

            String versionName = pinfo.versionName;         // versionName은 1.0.4와 version을 표시하는 String
            int versionCode = pinfo.versionCode;            // versionCode는 정수로 된 숫자
            //Log.e("version", "device_version >> versionName : " + pinfo.versionName + "  versionCode : " + pinfo.versionCode);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        mDialog = new AlertDialog.Builder(this);
        new getMarketVersion().execute();
    }

    private class splashhandler implements Runnable{
        @Override
        public void run() {
            Intent intent = new Intent(getApplicationContext(),
                    MainActivity.class);
            startActivity(intent);

            finish();
        }
    }

    @Override
    public void finish() {
        super.finish();

        this.overridePendingTransition(R.anim.fade_in, R.anim.fade_out);
    }

    // Package Version Check
    private class getMarketVersion extends AsyncTask<Void, Void, String> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }

        @Override
        protected String doInBackground(Void... params) {

            try {
                Document doc = Jsoup
                        .connect("https://play.google.com/store/apps/details?id=com.bbq.chicken202001")
                        .get();
//                Elements Version = doc.select(".htlgb ");

                Elements VersionDiv= doc.select(".BgcNfc");
                Elements Version = doc.select("div.hAyfc div span.htlgb");
                for (int i =0; i<VersionDiv.size(); i++){
                    if(VersionDiv.get(i).text().equals("Current Version")){
                        return Version.get(i).text();
                    }
                }

//                for (int i = 0; i < 10; i++) {
//                    String compareVersion = Version.get(i).text();
//                    if (Pattern.matches("^[0-9]{1}.[0-9]{1}.[0-9]{1}$", compareVersion)) {
//                        marketVersion = Version.get(i).text();
//                        break;
//                    }
//                }
                //Log.e("marketVersion", "marketVersion : " + marketVersion);
                return marketVersion;
            } catch (IOException e) {
                e.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(String result) {

            PackageInfo pi = null;
            try {
                pi = getPackageManager().getPackageInfo(getPackageName(), 0);
            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
            }
            deviceVersion = pi.versionName;
            marketVersion = result;
            if (marketVersion != null) {
                if (!deviceVersion.equals(marketVersion)) {

                    if (versionCompare(marketVersion, deviceVersion) > 0) {
                        mDialog.setMessage("버전을 업데이트 후 사용해주세요.")
                                .setCancelable(true)
                                .setPositiveButton("바로가기",
                                        new DialogInterface.OnClickListener() {
                                            public void onClick(DialogInterface dialog,
                                                                int id) {
                                                Intent marketLaunch = new Intent(
                                                        Intent.ACTION_VIEW);
                                                marketLaunch.setData(Uri
                                                        .parse("https://play.google.com/store/apps/details?id=com.bbq.chicken202001"));
                                                startActivity(marketLaunch);
                                                finish();
                                            }
                                        });
                        AlertDialog alert = mDialog.create();
                        alert.setTitle("안 내");
                        alert.show();
                    } else {
                        // Splash Screen
                        Handler handler = new Handler();
                        handler.postDelayed(new splashhandler(), 2000);

                        //goMainActivity();
                    }
                } else {
                    // Splash Screen
                    Handler handler = new Handler();
                    handler.postDelayed(new splashhandler(), 2000);

                    //goMainActivity();
                }
            }

            super.onPostExecute(result);
        }
    }


    // Package Version Check
    public int versionCompare(String storeVersion, String currentVersion) {
        String[] vals1 = storeVersion.split("\\.");
        String[] vals2 = currentVersion.split("\\.");

        int i = 0;
        // set index to first non-equal ordinal or length of shortest version string
        while (i < vals1.length && i < vals2.length && vals1[i].equals(vals2[i])) {
            i++;
        }

        // compare first non-equal ordinal number
        if (i < vals1.length && i < vals2.length) {
            int diff = Integer.valueOf(vals1[i]).compareTo(Integer.valueOf(vals2[i]));
            return Integer.signum(diff);
        }

        // the strings are equal or one string is a substring of the other
        // e.g. "1.2.3" = "1.2.3" or "1.2.3" < "1.2.3.4"
        return Integer.signum(vals1.length - vals2.length);
    }

}
