package com.bbq.chicken202001.activity;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.net.Uri;

import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.animation.AlphaAnimation;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import com.bbq.chicken202001.R;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.gif.GifDrawable;
import com.bumptech.glide.request.target.CustomTarget;
import com.bumptech.glide.request.target.DrawableImageViewTarget;
import com.bumptech.glide.request.transition.Transition;
import com.google.firebase.remoteconfig.FirebaseRemoteConfig;
import com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings;

import java.util.HashMap;


public class SplashScreenActivity extends AppCompatActivity {

    private Context   context;
    private ImageView imgView;
    private ImageView imgBaseView;

    private String marketVersion;
    private String deviceVersion;
    private String imgUrl;

    private final String marketURL  = "https://play.google.com/store/apps/details?id=com.bbq.chicken202001";
    private final String splashKey  = "SplashImage";
    private final String versionKey = "AosVersion";

    private Boolean gifFinish = false;
    private Boolean downloadFinish = false;
    private Bitmap  bitmap = null;


    //
    // override
    //


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash_screen);

        context     = this;
        imgView     = findViewById(R.id.splash_img);
        imgBaseView = findViewById(R.id.base_img);
        imgView.setScaleType(ImageView.ScaleType.FIT_XY);
        imgBaseView.setScaleType(ImageView.ScaleType.FIT_XY);


        //
        // 1. glide image load 및 gif 1번만 발생
        //
        Glide.with(this)
                .load(R.drawable.splash_animation)
                .into(new DrawableImageViewTarget(imgBaseView) {
                    @Override public void onResourceReady(Drawable resource, @Nullable Transition<? super Drawable> transition) {
                        if (resource instanceof GifDrawable) {
                            ((GifDrawable)resource).setLoopCount(1);
                        }
                        super.onResourceReady(resource, transition);
                    }
                });


        //
        // 2. gif 애니메이션 완료 처리
        //
        final Handler handler = new Handler();
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                gifFinish = true;
                showDownloadImage();
            }
        }, 1000);


        //
        // 3. Package Version Check
        //
        try {
            PackageInfo pInfo = getPackageManager().getPackageInfo(getPackageName(), PackageManager.GET_META_DATA);
            deviceVersion = pInfo.versionName;         // version name 은 1.0.4와 version 을 표시하는 String
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }


        //
        // 4. cloud 버전 획득
        //
        getCloudInfo();
    }


    @Override
    public void finish() {
        super.finish();
        this.overridePendingTransition(R.anim.fade_in, R.anim.fade_out);
    }


    //
    // private 함수 정의
    //


    /**
     * firebase 버전 정보 획득
     */
    private void getCloudInfo() {
        //
        // 1. 파이어베이스 리모트 객체 생성
        //
        FirebaseRemoteConfig config = FirebaseRemoteConfig.getInstance();
        FirebaseRemoteConfigSettings configSettings = new FirebaseRemoteConfigSettings
                .Builder()
                .setMinimumFetchIntervalInSeconds(0)    // 실행시마다 체크
                .build();

        // setMinimumFetchIntervalInSeconds(60*10*6*24) // 하루에 한번
        // setMinimumFetchIntervalInSeconds(0)          // 실행시마다 체크
        // setMinimumFetchIntervalInSeconds(60 * 10)    // 10 mins

        //
        // 2. 디폴트 값 삽입
        //
        HashMap defaultMap = new HashMap <String, String>();
        defaultMap.put(versionKey, "0.0.0");
        config.setDefaultsAsync(defaultMap);
        config.setConfigSettingsAsync(configSettings);


        //
        // 3. 최신 앱 버전 확인 이벤트 리스너 수행 실시
        //
        // [이벤트 리스너]
        config.fetchAndActivate().addOnCompleteListener(
                SplashScreenActivity.this, // [액티비티]
                task -> {

                    // 3.1 해당 키값 확인 성공
                    if (task.isSuccessful()) {
                        marketVersion = config.getString(versionKey);
                        imgUrl        = config.getString(splashKey);

                        downloadImage();
                    }
                    // 3.2 해당 키값 확인 실패
                    else {
//                            marketVersion = "";
                        compareVersion();
                    }
                });
    }


    /**
     * gif animation 이후에 download image 보여준다.
     */
    private void showDownloadImage() {
        if (downloadFinish && gifFinish) {
            final Handler handler = new Handler();
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    // alpha 애니메이션 적용
                    imgView.setImageBitmap(bitmap);
                    imgView.setAlpha(1.0f);

                    AlphaAnimation animation = new AlphaAnimation(0.0f, 1.0f);
                    animation.setDuration(1000);
                    animation.setStartOffset(0);
                    animation.setFillAfter(true);
                    imgView.startAnimation(animation);

                    // 버전 비교
                    final Handler delayHandler = new Handler();
                    delayHandler.postDelayed(() -> compareVersion(), 1000);
                }
            }, 1800);
        }
    }


    /**
     * Glide 이용하여 이미지 다운로드 한다.
     */
    private void downloadImage() {
        Glide.with(context)
                .asBitmap()
                .load(imgUrl)
                .into(new CustomTarget<Bitmap>() {
                    @Override
                    public void onResourceReady(@NonNull Bitmap resource, @Nullable Transition<? super Bitmap> transition) {
                        downloadFinish = true;
                        bitmap = resource;
                        showDownloadImage();
                    }

                    @Override
                    public void onLoadFailed(@Nullable Drawable errorDrawable) {
                        compareVersion();
                    }

                    @Override
                    public void onLoadCleared(@Nullable Drawable placeholder) {

                    }
                });
    }


    /**
     * 버전 비교
     */
    private void compareVersion() {
        //
        // 마켓 버전정보 없는 경우
        //
        if (marketVersion.equals("")) {
            goMain();
            return;
        }

        //
        // 마켓에 있는 앱 정보가 디바이스 앱 정보보다 큰 경우 업데이트 알림창
        //
        int market = Integer.parseInt(marketVersion.replace(".", ""));
        int device = Integer.parseInt(deviceVersion.replace(".", ""));
        if (market>device) {
            showAlert();
        } else {
            goMain();
        }
    }


    /**
     * 메인화면으로 이동한다.
     */
    private void goMain() {
        Handler delayHandler = new Handler();
        delayHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                Intent intent = new Intent(getApplicationContext(), MainActivity.class);
                startActivity(intent);
                Log.e(this.getClass().getName() , "===========startActivity"  );
                finish();
            }
        }, 1000); // 1초 지연을 준 후 시작
    }


    /**
     * alert 보여준다. (play store 로 이동)
     */
    private void showAlert() {
        AlertDialog.Builder dialog;
        dialog = new AlertDialog.Builder(this);

        dialog.setMessage("버전을 업데이트 후 사용해주세요.")
                .setCancelable(true)
                .setPositiveButton("바로가기",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int id) {
                                Intent marketLaunch = new Intent(Intent.ACTION_VIEW);
                                marketLaunch.setData(Uri.parse(marketURL));
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
}
