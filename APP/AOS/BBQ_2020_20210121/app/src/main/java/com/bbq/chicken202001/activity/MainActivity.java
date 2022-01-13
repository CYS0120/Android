package com.bbq.chicken202001.activity;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Build;
import android.os.Handler;
import android.os.Message;
import android.provider.Settings;
//import android.support.annotation.NonNull;
//import android.support.v4.app.ActivityCompat;
//import android.support.v4.content.ContextCompat;
//import android.support.v7.app.AlertDialog;
//import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.DecelerateInterpolator;
import android.webkit.CookieManager;
import android.webkit.GeolocationPermissions;
import android.webkit.JavascriptInterface;
import android.webkit.JsResult;
import android.webkit.PermissionRequest;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;


import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.bbq.chicken202001.QRScane;
import com.bbq.chicken202001.R;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.messaging.FirebaseMessaging;

import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLEncoder;
import java.util.Calendar;
import java.util.Stack;



public class MainActivity extends AppCompatActivity {

    private static final String TAG = MainActivity.class.getSimpleName();

    // webView
    static private WebView mWebView;
    private ProgressBar progressBar;
    TextView errorView;
    Boolean  goMain;
    private final Handler handler = new Handler();
    private   Toast bottomToast;
    private SharedPreferences pref;

    final Animation mfadeIn = new AlphaAnimation(0,1);
    final Animation mfadeOut = new AlphaAnimation(1,0);
    final AnimationSet maniSet =  new AnimationSet(false);

    public static Context mContext;
    public static String deviceId = "";

     int mYear,mMonth,mDay,mTime,mMin;
     boolean mCache;

     //파일업로드
    private ValueCallback<Uri> CallbackNormal;
    private ValueCallback<Uri[]> CallbackLollipop;;

    private final static int NORMAL_REQ_CODE = 1;
    private final static int LOLLIPOP_REQ_CODE = 2;

    boolean  mBarCode;

    DialogWebBridge dialogWebBridge;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Log.d(TAG, "onCreate");

        setContentView(R.layout.activity_main);
        checkLocationPermission();
        checkSelfPermission();
        goMain = false;

        bottomToast = Toast.makeText(getApplicationContext(),"처리중", Toast.LENGTH_LONG);


        errorView = (TextView) findViewById(R.id.network_error_view);
        // webView ---------------------------------------------------------------------------
        mWebView = (WebView) findViewById(R.id.activity_main_webview);



        /**
         * 앱실행시 한번만 스프레쉬가 페이드아웃되게
         */
        mfadeIn.setInterpolator(new DecelerateInterpolator());
        mfadeIn.setDuration(10);
        mfadeOut.setInterpolator(new AccelerateDecelerateInterpolator());
        mfadeOut.setStartOffset(1500);
        mfadeOut.setDuration(1000);
        maniSet.addAnimation(mfadeIn);
        maniSet.addAnimation(mfadeOut);

        //barCode,진입시 폴스,스캔시작전 트루
        mBarCode = false;

        //progressbar
        progressBar = (ProgressBar) findViewById(R.id.web_progress);
        //progressBar.setVisibility(View.GONE);


        // webView render
        mWebView.getSettings().setUseWideViewPort(true);
        mWebView.getSettings().setLoadWithOverviewMode(true);
        //웹뷰가 앤에 등록되어 있는 이미지리소스를 자동으로 로드하도록설정
        //mWebView.getSettings().setLoadsImagesAutomatically(true);
        // enable pinch-zooming
        mWebView.getSettings().setSupportZoom(true);
        mWebView.getSettings().setBuiltInZoomControls(true);
        mWebView.getSettings().setDisplayZoomControls(false);
        // payco
        mWebView.getSettings().setAppCacheEnabled(true);
        mWebView.getSettings().setDomStorageEnabled(true);
        // payco & windows open
        mWebView.getSettings().setJavaScriptEnabled(true);
        // location
        mWebView.getSettings().setGeolocationEnabled(true);
        mWebView.getSettings().setGeolocationDatabasePath( getFilesDir().getPath() );
        mWebView.getSettings().setDatabaseEnabled(true);



        //mWebView.addJavascriptInterface(new AndroidBridge(), "BBQAndroid");
        mWebView.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);
        // windows open 이것활성화 하면 로그인버튼 클릭시 로그인페이지 안들어감
       // mWebView.getSettings().setSupportMultipleWindows(true);


       // mWebView.clearCache(true);//추가 아래막음
      //  mWebView.getSettings().setCacheMode(WebSettings.LOAD_DEFAULT);
      //  mWebView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);                        // Cache
        mWebView.getSettings().setDefaultTextEncodingName("UTF-8");

        // UserAgent
        String userAgent = mWebView.getSettings().getUserAgentString();
       //mWebView.getSettings().setUserAgentString(userAgent+"aaa");
//        mWebView.getSettings().setUserAgentString(userAgent+"bbqAOS");
        mWebView.getSettings().setUserAgentString(userAgent + "bbqAOS/KB-STARGATE");

        mWebView.setWebViewClient(new CommonWebViewClient());
        // 브릿지 추가
        dialogWebBridge = new DialogWebBridge();
        mWebView.addJavascriptInterface(dialogWebBridge, "SGApp");
        dialogWebBridge.addParentWebView(mWebView);
        dialogWebBridge.setIsDialogWebView(false);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            // https -> http 호출 허용
            mWebView.getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);

            // 서드파티 쿠키 허용
            CookieManager cookieManager = CookieManager.getInstance();
            cookieManager.setAcceptCookie(true);
            cookieManager.setAcceptThirdPartyCookies(mWebView, true);
        }


        // Android Webview 디버깅 지원
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            WebView.setWebContentsDebuggingEnabled(true);
        }

        mWebView.setWebViewClient(new WebViewClient() {

            @Override
            public boolean shouldOverrideUrlLoading(final WebView view, String url) {
//                Log.e(this.getClass().getName(), "shouldOverrideUrlLoading() = "
//                        + url);
                /**
                 * 요기요 이벤트시 결제 진행이 안되는 부분 blank페이지계속 반복해서 띄는것을 예외 처리로 해결
                 */
                if(url.contains("yogiyoapp"))
                {
                    goMain = true;
                }
                if (url != null && !url.equals("about:blank")) {
                    if (!url.startsWith("http://") && !url.startsWith("https://") && !url.startsWith("javascript:")) {
                        //    Log.e("1번 intntent://", url);
                        Log.e(this.getClass().getName() , "http://" + url )	;
                        try {
                            Intent intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME);

                            // 보안 관련 추가 코드 : 2019.06.20 by dodam
                            intent.addCategory("android.intent.category.BROWSABLE");
                            intent.setComponent(null);
                            intent.setSelector(null); // 보안 추가 종료

                            Intent existPackage = getPackageManager().getLaunchIntentForPackage(intent.getPackage());
                            if (existPackage != null) {
                                view.getContext().startActivity(intent);
                            } else {
                                Intent marketIntent = new Intent(Intent.ACTION_VIEW);
                                marketIntent.setData(Uri.parse("market://details?id=" + intent.getPackage()));
                                view.getContext().startActivity(marketIntent);
                            }
                            return true;
                        } catch (Exception e) {
                            Log.e(this.getClass().getName(), e.getMessage());
                        }
                    } else if (url != null && url.startsWith("market://")) {
                        try {
                            Intent intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME);

                            // 보안 관련 추가 코드 : 2019.06.20 by dodam
                            intent.addCategory("android.intent.category.BROWSABLE");
                            intent.setComponent(null);
                            intent.setSelector(null); // 보안 추가 종료

                            if (intent != null) {
                                view.getContext().startActivity(intent);
                            }
                            return true;
                        } catch (URISyntaxException e) {
                            Log.e(this.getClass().getName(), e.getMessage());
                        }
                    } else {
                        // 인터넷 프로토콜 주소가 들어왔을 경우
                        view.loadUrl(url);
                        return true;
 //                       return super.shouldOverrideUrlLoading(view, url);
                    }
                }
                /**
                *결제 이후 blank화면을 알람을 띄워서 메인화면으로 이동되게 처리
                 */
                if(url.equals("about:blank"))
                {
                       if(goMain) {
                           goMain = false;

                           new AlertDialog.Builder(view.getContext())
                                   .setTitle("알림")
                                   .setMessage("메인화면으로 이동")
                                   .setPositiveButton(android.R.string.ok,
                                          new AlertDialog.OnClickListener(){
                                               public void onClick(DialogInterface dialog, int which) {
                                                   Log.e(this.getClass().getName(), "메인화면으로 이동= ");
                                                   view.loadUrl("https://m.bbq.co.kr/main.asp");
                                               }
                                           })
                                   .setCancelable(false)
                                   .create()
                                   .show();
                           return true;

//                           AlertDialog.Builder alertDialog = new AlertDialog.Builder(view.getContext());
//                           alertDialog.setMessage("메인화면으로 이동")
//                                       .setCancelable(false)
//                                        .setPositiveButton(" 확인",new DialogInterface.OnClickListener() {
//                                            public void onClick(DialogInterface dialog, int which) {
//                                                view.loadUrl("http://m.bbq.co.kr/");
//                                            }
//                                        }).create().show();
                      //     view.loadUrl("https://m.bbq.co.kr/");
                       }
                        return false;
                }
                return true;
            }



            //네트워크연결에러
            @Override
            public void onReceivedError(WebView view, int errorCode,String description, String failingUrl) {

                switch(errorCode) {
                    case ERROR_AUTHENTICATION: break;                   // 서버에서 사용자 인증 실패
                    case ERROR_BAD_URL: break;                          // 잘못된 URL
                    case ERROR_CONNECT: break;                          // 서버로 연결 실패
                    case ERROR_FAILED_SSL_HANDSHAKE: break;             // SSL handshake 수행 실패
                    case ERROR_FILE: break;                             // 일반 파일 오류
                    case ERROR_FILE_NOT_FOUND: break;                   // 파일을 찾을 수 없습니다
                    case ERROR_HOST_LOOKUP: break;                      // 서버 또는 프록시 호스트 이름 조회 실패
                    case ERROR_IO: break;                               // 서버에서 읽거나 서버로 쓰기 실패
                    case ERROR_PROXY_AUTHENTICATION: break;             // 프록시에서 사용자 인증 실패
                    case ERROR_REDIRECT_LOOP: break;                    // 너무 많은 리디렉션
                    case ERROR_TIMEOUT: break;                          // 연결 시간 초과
                    case ERROR_TOO_MANY_REQUESTS: break;                // 페이지 로드중 너무 많은 요청 발생
                    case ERROR_UNKNOWN: break;                          // 일반 오류
                    case ERROR_UNSUPPORTED_AUTH_SCHEME: break;          // 지원되지 않는 인증 체계
                    case ERROR_UNSUPPORTED_SCHEME: break;               // URI가 지원되지 않는 방식
                }

//                view.loadData("<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>" +
//                        "</head><body>"+"요청실패 : ("+errorCode+")" + description+"</body></html>", "text/html", "utf-8");
                super.onReceivedError(view, errorCode, description, failingUrl);
                Log.e(this.getClass().getName() , "onReceivedError = " + description )	;
                Log.e(this.getClass().getName() , "onReceivedError = " + failingUrl )	;

                mWebView.setVisibility(View.GONE);
                errorView.setVisibility(View.VISIBLE);
            }

            // 웹페이지 로딩 시작시 호출
            public void onPageStarted(WebView view, String url, Bitmap favicon){
                //progressBar.setVisibility(View.VISIBLE);
                //bottomToast.show();;



                mWebView.setAnimation(mfadeIn);
                mWebView.setVisibility(View.VISIBLE);
//                    mfadoutImageVeiw.postDelayed(new Runnable() {
//                        @Override
//                        public void run() {
//                            //mfadoutImageVeiw.setVisibility(View.GONE);
//                            mWebView.setAnimation(mfadeIn);
//                            mfadoutImageVeiw.setAnimation(mfadeOut);
//                            mWebView.setVisibility(View.VISIBLE);
//
//                        }
//                    },500);

                progressBar.setVisibility(View.VISIBLE);
                progressBar.setAnimation(mfadeIn);
                progressBar.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        progressBar.setAnimation(mfadeOut);
                        progressBar.setVisibility(View.GONE);
                    }
                },500);


            }

            // 웹페이지 로딩 종료시 호출
            @Override
            public void onPageFinished(WebView view, String url){
                //progressBar.setVisibility(View.GONE);
                //bottomToast.cancel();
               // mfadoutImageVeiw.setVisibility(View.GONE);
            }

        });

        // 웹뷰에서 자바스크립트 alert과 confirm이 동작하지 않는 것을 수정하기 위해 추가됨
        mWebView.setWebChromeClient(new WebChromeClient() {
            // Full Screen Mode 적용
            // mWebView.setWebChromeClient(new FullscreenableChromeClient(MainActivity.this) {

            // 다음 지도 팝업, 결제 모듈 팝업, sms 인증 팝업을 띄워야 할 때
            // 외부 브라우저를 호출한다. << 문제점

            @Override
            public boolean onCreateWindow(WebView view, boolean isDialog, boolean isUserGesture, Message resultMsg) {
                WebView newWebView = new WebView(MainActivity.this);
                WebSettings webSettings = newWebView.getSettings();
                webSettings.setJavaScriptEnabled(true);
                webSettings.setJavaScriptCanOpenWindowsAutomatically(true);
                webSettings.setSupportMultipleWindows(true);

                final Dialog dialog = new Dialog(MainActivity.this);
                dialog.setContentView(newWebView);
                dialog.show();

                newWebView.setWebChromeClient(new WebChromeClient() {
                    @Override public void onCloseWindow(WebView window) {
                        dialog.dismiss();
                    }

                });

                ((WebView.WebViewTransport)resultMsg.obj).setWebView(newWebView);
                resultMsg.sendToTarget();
                return true;
            }


            /*
            // 새창을 외부 브라우저로 띄우는 소스입니다.
            @Override
            public boolean onCreateWindow(WebView view, boolean dialog, boolean UserGesture, Message resultMsg) {
                WebView newWebView = new WebView(MainActivity.this);
                WebView.WebViewTransport transport = (WebView.WebViewTransport) resultMsg.obj;

                transport.setWebView(newWebView);
                resultMsg.sendToTarget();

                newWebView.setWebViewClient(new WebViewClient() {
                    @Override
                    public boolean shouldOverrideUrlLoading(WebView view, String url) {
                        Intent browserIntent = new Intent(Intent.ACTION_VIEW);
                        browserIntent.setData(Uri.parse(url));
                        startActivity(browserIntent);
                        return true;
                    }
                });

                return true;
            }
            */

            @Override
            public void onPermissionRequest(final PermissionRequest request) {
                Log.d("PermissionRequest","onPermissionRequest");
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    request.grant(request.getResources());
                }
            }

            //alert 처리
            @Override
            public boolean onJsAlert(WebView view, String url, String message, final JsResult result) {
                new AlertDialog.Builder(view.getContext())
                        .setTitle("Alert")
                        .setMessage(message)
                        .setPositiveButton(android.R.string.ok,
                                new AlertDialog.OnClickListener(){
                                    public void onClick(DialogInterface dialog, int which) {
                                        result.confirm();
                                    }
                                })
                        .setCancelable(false)
                        .create()
                        .show();
                return true;
            }

            // For Android < 3.0
            public void openFileChooser( ValueCallback<Uri> uploadMsg) {
                Log.d("MainActivity", "3.0 <");
                openFileChooser(uploadMsg, "");
            }
            // For Android 3.0+
            public void openFileChooser( ValueCallback<Uri> uploadMsg, String acceptType) {
                Log.d("MainActivity", "3.0+");
                CallbackNormal = uploadMsg;
                Intent i = new Intent(Intent.ACTION_GET_CONTENT);
                i.addCategory(Intent.CATEGORY_OPENABLE);
                i.setType("image/*");
                // i.setType("video/*");
                startActivityForResult(Intent.createChooser(i, "File Chooser"), NORMAL_REQ_CODE);
            }
            // For Android 4.1+
            public void openFileChooser(ValueCallback<Uri> uploadMsg, String acceptType, String capture) {
                Log.d("MainActivity", "4.1+");
                openFileChooser(uploadMsg, acceptType);
            }


            // For Android 5.0+

            public boolean onShowFileChooser(
                    WebView webView, ValueCallback<Uri[]> filePathCallback,
                    WebChromeClient.FileChooserParams fileChooserParams) {
                Log.d("MainActivity", "5.0+");
                if (CallbackLollipop != null) {
                    CallbackLollipop.onReceiveValue(null);
                    CallbackLollipop = null;
                }

                CallbackLollipop = filePathCallback;

 //               String text = "Text";
//                Uri pictureUri = Uri.parse("file://my_picture");

//                Cursor cursor = getContentResolver().query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, null, null, null, null);
//                cursor.moveToNext(); int id = cursor.getInt(cursor.getColumnIndex("_id"));
//                Uri uri = ContentUris.withAppendedId(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, id);
//                intent.setType(android.provider.MediaStore.Images.Media.CONTENT_TYPE);
//                 intent.setData(android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);



//                Intent i = new Intent(Intent.ACTION_GET_CONTENT);
//                i.addCategory(Intent.CATEGORY_OPENABLE);
                Intent i = new Intent();

                i.setAction(Intent.ACTION_GET_CONTENT);
                i.addCategory(Intent.CATEGORY_OPENABLE);
                i.setType(android.provider.MediaStore.Images.Media.CONTENT_TYPE);
                i.setData(android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);


                i.setType("image/*");
                //i.setType("*/*");
                startActivityForResult(Intent.createChooser(i, "File Chooser"), LOLLIPOP_REQ_CODE);

                return true;
            }

            public boolean openFileChooser(
                    WebView webView, ValueCallback<Uri[]> filePathCallback,
                    WebChromeClient.FileChooserParams fileChooserParams) {
                Log.d("MainActivity", "5.0+");
                if (CallbackLollipop != null) {
                    CallbackLollipop.onReceiveValue(null);
                    CallbackLollipop = null;
                }

                CallbackLollipop = filePathCallback;

                Intent i = new Intent(Intent.ACTION_GET_CONTENT);
                i.addCategory(Intent.CATEGORY_OPENABLE);
               i.setType("image/*");
               // i.setType("*/*");
                startActivityForResult(Intent.createChooser(i, "File Chooser"), LOLLIPOP_REQ_CODE);

                return true;
            }
            //confirm 처리
            @Override
            public boolean onJsConfirm(WebView view, String url, String message, final JsResult result) {
                new AlertDialog.Builder(view.getContext())
                        .setTitle("Confirm")
                        .setMessage(message)
                        .setPositiveButton("Yes",
                                new AlertDialog.OnClickListener(){
                                    public void onClick(DialogInterface dialog, int which) {
                                        result.confirm();
                                    }
                                })
                        .setNegativeButton("No",
                                new AlertDialog.OnClickListener(){
                                    public void onClick(DialogInterface dialog, int which) {
                                        result.cancel();
                                    }
                                })
                        .setCancelable(false)
                        .create()
                        .show();
                return true;
            }

            @Override
            public void onGeolocationPermissionsShowPrompt(String origin, GeolocationPermissions.Callback callback) {
                super.onGeolocationPermissionsShowPrompt(origin, callback);
                callback.invoke(origin, true, false);
            }

        });


        mContext = this;
        deviceId = Settings.Secure.getString(mContext.getContentResolver(), Settings.Secure.ANDROID_ID);

        FirebaseMessaging.getInstance().getToken()
                .addOnCompleteListener(new OnCompleteListener<String>() {
                    @Override
                    public void onComplete(@NonNull Task<String> task) {
                        if (!task.isSuccessful()) {
                            Log.w(TAG, "Fetching FCM registration token failed", task.getException());
                            return;
                        }

                        // Get new FCM registration token
                        String token        = task.getResult();
                        String pushType     = "";
                        String appVersion   = "";

                        try {
                            PackageInfo pInfo = getPackageManager().getPackageInfo(getPackageName(), PackageManager.GET_META_DATA);
                            appVersion = pInfo.versionName;         // versionName은 1.0.4와 version을 표시하는 String
                        } catch (PackageManager.NameNotFoundException e) {
                            e.printStackTrace();
                        }


                        Intent intent = getIntent();

                        //
                        // deepLink 처리 (bbqchickenapp://bbqmain?pushType=COUPON)
                        //
                        if (intent.getAction() == intent.ACTION_VIEW) {
                            Uri data = intent.getData();
                            pushType = data.getQueryParameter("pushType");
                        }

                        //
                        // push를 통한 앱 처리
                        //
                        else {
                            if(intent.getStringExtra("PUSHTYPE") != null) {
                                pushType = intent.getStringExtra("PUSHTYPE");
                            }
                        }


                        //
                        // url 이동
                        //
                        mWebView.loadUrl("https://m.bbq.co.kr/main.asp?deviceId="+deviceId+"&token="+token+"&osTypeCd=ANDROID&pushtype="+pushType+"&version="+appVersion); // 실서버 보안연결
                        progressBar.setVisibility(View.VISIBLE);
                        mWebView.setVisibility(View.VISIBLE);
                    }
                });



        /*
        Intent pushtype = getIntent();
        String pushType = "";
        if(pushtype.getStringExtra("PUSHTYPE") != null) {
            pushType = pushtype.getStringExtra("PUSHTYPE");
        }

//        mWebView.loadUrl("https://map.kakao.com/");
        mWebView.loadUrl("https://m.bbq.co.kr/main.asp?deviceId="+deviceId+"&token="+token+"&osTypeCd=ANDROID&pushtype="+pushType); // 실서버 보안연결
//        mWebView.loadUrl("http://1087.g2i.co.kr/main.asp?deviceId="+deviceId+"&token="+token+"&osTypeCd=ANDROID&pushtype="+pushType); // 실서버 보안연결
        // mWebView.loadUrl("http://m.bbq.co.kr/main.asp"); // 실서버
       // mWebView.loadUrl("http://www.google.co.kr");
//        mWebView.loadUrl("https://1087.g2i.co.kr"); //  테스트 모바일

        progressBar.setVisibility(View.VISIBLE);
        mWebView.setVisibility(View.VISIBLE);
         */
    }
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        //권한을 허용 했을 경우
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == 1) {
            int length = permissions.length;
            for (int i = 0; i < length; i++) {
                if (grantResults[i] == PackageManager.PERMISSION_GRANTED) {
                    // 동의
                    Log.d("MainActivity", "권한 허용 : " + permissions[i]);
                }
            }
        }
    }
    public void checkLocationPermission() {
        String temp = "";
        //위치 권한 확인
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            temp += Manifest.permission.ACCESS_COARSE_LOCATION + " ";
        }
        if (TextUtils.isEmpty(temp) == false) {
            // 권한 요청
            ActivityCompat.requestPermissions(this, temp.trim().split(" "), 1);
        } else {
            // 모두 허용 상태
        }
    }

    public void checkSelfPermission() {
        String temp = "";
        //카메라 권한 확인
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
            temp += Manifest.permission.CAMERA + " ";
        }
        if (TextUtils.isEmpty(temp) == false) {
            // 권한 요청
            ActivityCompat.requestPermissions(this, temp.trim().split(" "), 1);
        } else {
            // 모두 허용 상태
        }
    }
    public void checkCameraPermission() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
            Toast.makeText(this, "카메라 권한이 필요합니다.", Toast.LENGTH_SHORT).show();
            if (mWebView.canGoBack()) {
                mWebView.goBack();
            }
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {


        //barCodeResult
        if(mBarCode == true) {

//            IntentResult result = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
////            if(result != null) {
////                if(result.getContents() == null) {
////                    Toast.makeText(this, "Cancelled", Toast.LENGTH_LONG).show();
////                } else {
////                    Toast.makeText(this, "Scanned: " + result.getContents(), Toast.LENGTH_LONG).show();
////                }
////            } else {
////                super.onActivityResult(requestCode, resultCode, data);
////            }
////
            if (requestCode == 0) {

                if (resultCode == RESULT_OK) {

                    String contents = data.getStringExtra("SCAN_RESULT");
                    // String format = data.getStringExtra("SCAN_RESULT_FORMAT");
                    mWebView.loadUrl("javascript:barCodeData('"+contents+"')"); // web의 javascript 호출
                    Log.d("Barcode barCodeData 호출", contents);

                } else if (resultCode == RESULT_CANCELED) {

                }
            }
            mBarCode = false;
        }

        if (resultCode == RESULT_OK) {


             if (requestCode == NORMAL_REQ_CODE) {
                if (CallbackNormal == null) return ;
                Uri result = (data == null || resultCode != RESULT_OK) ? null : data.getData();
                 CallbackNormal.onReceiveValue(result);
                 CallbackNormal = null;
            } else if (requestCode == LOLLIPOP_REQ_CODE) {
                if (CallbackLollipop == null) return ;
                 CallbackLollipop.onReceiveValue(WebChromeClient.FileChooserParams.parseResult(resultCode, data));
                 CallbackLollipop = null;
            }
        } else {
            if (CallbackLollipop != null) {
                CallbackLollipop.onReceiveValue(null);
                CallbackLollipop = null;
            }
        }
        super.onActivityResult(requestCode, resultCode, data);

    }

    @Override
    public void onStart()
    {
        super.onStart();

        Log.d(TAG, "onStart");

        Calendar cal = Calendar.getInstance();
        //년
        int year = cal.get(cal.YEAR);
        //달 1월은 0
        int month = cal.get(cal.MONTH) +1;
        //날
        int date  = cal.get(cal.DATE);

        //시 24시간
        int hour = cal.get(cal.HOUR_OF_DAY);
        //분
        int min = cal.get(cal.MINUTE);

        pref = getSharedPreferences("BBQINFO", Context.MODE_PRIVATE);

        mYear  = pref.getInt("YEAR",1);
        mMonth = pref.getInt("MONTH",1);
        mDay = pref.getInt("DAY",1);
        mTime = pref.getInt("TIME",0);
        mMin  = pref.getInt("MIN",1);
        mCache = pref.getBoolean("Cache",true);

        SharedPreferences.Editor editor = pref.edit();


        //최초 실행은 캐싱으로
        if(mCache ==true)
        {
            mWebView.getSettings().setCacheMode(WebSettings.LOAD_DEFAULT);
            editor.putInt("YEAR",year);
            editor.putInt("MONTH",month);
            editor.putInt("DAY",date);
            editor.putInt("TIME",hour);
            editor.putInt("MIN",min);
            editor.putBoolean("Cache",false);

        }
        else {

            if (year > mYear) {
                editor.putInt("YEAR",year);
                editor.putInt("MONTH",month);
                editor.putInt("DAY",date);
                editor.putInt("TIME",hour);
                editor.putInt("MIN",min);
                mWebView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
                editor.putBoolean("Cache", false);

            } else {
                if (month > mMonth) {//디폴트캐쉬로 설정한 이후 한달이상으로 지났다면
                    mWebView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
                    editor.putBoolean("Cache", false);
                    editor.putInt("YEAR",year);
                    editor.putInt("MONTH",month);
                    editor.putInt("DAY",date);
                    editor.putInt("TIME",hour);
                    editor.putInt("MIN",min);

                } else if (month == mMonth) {//같은달에서

                    if (date > mDay) {//하루이상이 지났다면
                        mWebView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
                        editor.putBoolean("Cache", false);
                        editor.putInt("YEAR",year);
                        editor.putInt("MONTH",month);
                        editor.putInt("DAY",date);
                        editor.putInt("TIME",hour);
                        editor.putInt("MIN",min);

                    } else {

                        //3시간 이상일때만 리셋
                        if (hour >= mTime + 3) {//
                            Log.e(this.getClass().getName() , " if (hour >= mTime + 3) {  exceed 3 time")	;
                            if (min > mMin) {//3시간초과 캐싱안하는 상태로 설정
                                mWebView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
                                editor.putBoolean("Cache", false);
                                editor.putInt("TIME",hour);
                                editor.putInt("MIN",min);

                            } else {
                                mWebView.getSettings().setCacheMode(WebSettings.LOAD_DEFAULT);

                            }
                        }
                        else//3시간 이하일때는 캐싱을 한것을 사용
                        {
                            mWebView.getSettings().setCacheMode(WebSettings.LOAD_DEFAULT);

                        }
                    }
                }
            }
        }
        editor.commit();
    }

    @Override
    public void onDestroy() {
        Log.d(TAG, "onDestroy");
        super.onDestroy();
    }

    @Override
    public void onResume() {
        super.onResume();

//        progressBar.setAnimation(mfadeIn);
//        progressBar.setVisibility(View.VISIBLE);
//        progressBar.postDelayed(new Runnable() {
//            @Override
//            public void run() {
//                progressBar.setAnimation(mfadeOut);
//                progressBar.setVisibility(View.GONE);
//            }
//        },500);
        //mWebView.setVisibility(View.VISIBLE);
        Log.d(this.getClass().getName() , "public void onResume()");
    }


    /**
     * 요기요 이벤트에서 안드로이드만 로그인이 안되는부분처리,
     * 로그인 화면으로 이동하지 않는것을 웹쪽을 앱쪽으로 들어와서 다시 웹쪽호출로 처리
     */
    public class AndroidBridge {
        @JavascriptInterface
        public void  AOSLogin(final String javascript) {

            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    Toast.makeText(getApplicationContext(),"로딩중입니다.", Toast.LENGTH_LONG).show();
                   // loadJavascript(javascript);
                    mWebView.loadUrl("javascript:"+javascript);

                }
            });
        }

        //barCodeScan

        /**
         * 바코드 스캔을 위해 액티비티 전환 하는 브릿지
         * @param arg
         */
        @JavascriptInterface
        // public void barCodeScan(final String javascript)
        public void barCodeScan(final String arg)
        {
//           runOnUiThread(new Runnable() {
//                @Override
//                public void run() {
//                     Log.e(this.getClass().getName() , " ***************************************************barCodeScan ***************************************************" )	;
//                    //스캔 시작시 트루
//                    mBarCode = true;
//                    Intent intent = new Intent("com.google.zxing.client.android.SCAN");
//                    intent.putExtra("SCAN_MODE","QR_CODE_MODE");
//                    startActivityForResult(intent,0);
//
//                }
//            });

            Log.e(this.getClass().getName() , " ***************************************************barCodeScan ***************************************************" )	;
            //스캔 시작시 트루
            mBarCode = true;

            Intent intent = new Intent(MainActivity.this, QRScane.class);
            startActivityForResult(intent,0);


//
//            Intent intent = new Intent("com.google.zxing.client.android.SCAN");
//            intent.putExtra("SCAN_MODE","ALL");
//            startActivityForResult(intent,0);
//            new IntentIntegrator(MainActivity.this).initiateScan();
//
//            String currentactivity ;
//
//            IntentIntegrator integrator = new IntentIntegrator(MainActivity.this);
//            integrator.setDesiredBarcodeFormats(IntentIntegrator.QR_CODE);
//            integrator.setPrompt("Scan a barcode");
//            integrator.setCameraId(0);  // Use a specific camera of the device
//            integrator.setBeepEnabled(false);
//            integrator.setBarcodeImageEnabled(true);
//            integrator.initiateScan();

            // IntentIntegrator integrator = new IntentIntegrator(MainActivity.this);

           // integrator.setDesiredBarcodeFormats(IntentIntegrator.DATA_MATRIX);
            // integrator.initiateScan();


//            IntentIntegrator integrator = new IntentIntegrator(MainActivity.this);
//
//            integrator.setCaptureActivity()
//            integrator.setDesiredBarcodeFormats(IntentIntegrator.DATA_MATRIX);
//
//            // QR Code Capture Activity Orientation Set : degree unit
//            integrator.setOrientation(90);
//
//            // Scan View finder size : pixel unit
//            integrator.addExtra(Intents.Scan.HEIGHT, 300);
//            integrator.addExtra(Intents.Scan.WIDTH, 300);
//
//            // Capture View Start
//            integrator.initiateScan();


        }
    }
    // webView
    // 웹뷰에서는 뒤로 가기를 눌렀을때 이전 페이지로 가지 않고, 앱이 닫혀 버리는 현상이 발생 합니다
//    @Override
//    public boolean onKeyDown(int keyCode, KeyEvent event) {
//        if (keyCode == KeyEvent.KEYCODE_BACK) {
//            if (mWebView.canGoBack()) {
//                mWebView.goBack();
//                return false;
//            }
//        }
//        return super.onKeyDown(keyCode, event);
//    }

    @Override
    public void onBackPressed() {
        if (mWebView.canGoBack()) {
            mWebView.goBack();
            return;
        }

        super.onBackPressed();
    }

    // 바코드 스캔값을 QRScane에서  받는다.

    /**
     * 바코드 스캔 결과를 리턴 받는 곳.
     * @param code
     */
    static public void sendBarcodeToWeb(String code) {
        Log.d("Barcode barCodeData 출력", code);
        mWebView.loadUrl("javascript:barCodeData('"+code+"')"); // web의 javascript 호출
    }


    /**
     * 다이얼로그안에 웹뷰를 띄우기 위한 브릿지
     */
    public class DialogWebBridge {
        private boolean isDialogWebView; // 브릿지객체 생성시 넘겨 받는 webview가 dialogWebview인지 판단함
        private Stack<WebViewDialog> webViewDialogList;   // 새로운 웹뷰를 띄우기 위한 다이얼로그
        private Stack<WebView> parentWebViewList;  // 부모웹뷰, 페이지 뎁스에 따라 다이얼로그 웹뷰가 부모가 되는 경우가 있음
        // 특정화면을 새로운 웹뷰에서 호출하기 위해 사용하는 다이얼로그

        public DialogWebBridge() {
            if (parentWebViewList == null) {
                parentWebViewList = new Stack<WebView>();
            }
            if (webViewDialogList == null) {
                webViewDialogList = new Stack<WebViewDialog>();
            }
        }

        public Stack<WebView> getParentWebViewList() {
            return parentWebViewList;
        }

        public void addParentWebView(WebView parentWebView) {
            parentWebViewList.push(parentWebView);
        }

        public void addDialog(WebViewDialog dialog) {
            webViewDialogList.push(dialog);
        }

        public void setIsDialogWebView(boolean isDialogWebView) {
            this.isDialogWebView = isDialogWebView;
        }

        @JavascriptInterface
        public void openPopup(final String url, String ci) {   // 웹뷰팝업을 생성
            Log.i(TAG, "openPopup");
            Log.i(TAG, "url = " + url);
            Log.i(TAG, "ci = " + ci);
            showDialogWebView(url, ci);
        }


        @JavascriptInterface
        public void openPopup(final String url) {   // 웹뷰팝업을 생성
            Log.i(TAG, "openPopup");
            Log.i(TAG, "url = " + url);
            showDialogWebView(url, null);
        }

        private void showDialogWebView(String url, String param) {
            Log.i(TAG, "showDialogWebView");
            Log.i(TAG, "url = " + url);
            runOnUiThread(() -> {
                Uri parentUri = Uri.parse(mWebView.getUrl());
                Uri uri = Uri.parse(url);

                Uri mUri;
                if (uri.getScheme() != null) {
                    mUri = uri;
                } else {
                    mUri = new Uri.Builder()
                            .scheme(parentUri.getScheme())
                            .encodedAuthority(parentUri.getEncodedAuthority())
                            .encodedPath(url)
                            .build();
                }
                Log.i(TAG, "mUri = " + mUri);
                // 다이얼로그안에서 사용하는 웹뷰
                WebView dialogWebView = new WebView(MainActivity.this);
                WebViewDialog webViewDialog = new WebViewDialog(MainActivity.this, R.style.FullScreen);
                WebSettings webSettings = dialogWebView.getSettings();
                webSettings.setJavaScriptEnabled(true);
                webSettings.setJavaScriptCanOpenWindowsAutomatically(true);
                webSettings.setSupportMultipleWindows(true);
                webSettings.setPluginState(WebSettings.PluginState.ON);
                webSettings.setDomStorageEnabled(true);
                // UserAgent 추가
                String userAgent = dialogWebView.getSettings().getUserAgentString();
                dialogWebView.getSettings().setUserAgentString(userAgent + "bbqAOS/KB-STARGATE");
                dialogWebView.addJavascriptInterface(dialogWebBridge, "SGApp");
                // 커스텀 webviewclient추가
                dialogWebView.setWebViewClient(new CommonWebViewClient());
                dialogWebView.setWebChromeClient(new WebChromeClient() {
                    @Override
                    public boolean onJsAlert(WebView view, String url, String message, JsResult result) {
                        return super.onJsAlert(view, url, message, result);
                    }
                });
                dialogWebBridge.addParentWebView(dialogWebView);
                dialogWebBridge.addDialog(webViewDialog);
                isDialogWebView = true;
                dialogWebView.loadUrl(mUri.toString());
                webViewDialog.setContentView(dialogWebView);
                webViewDialog.show();
            });

        }

        @JavascriptInterface
        public boolean existOpener() {  // 부모페이지가 존재하는지 확인
            Log.i(TAG, "existOpener");
            boolean ret = false;
            if (isDialogWebView) {
                ret = true;
            }
            return ret;
        }

        @JavascriptInterface
        public void refreshOpener() { // 부모페이지 리프레쉬
            Log.i(TAG, "refreshOpener");
            runOnUiThread(() -> {
                if (parentWebViewList != null && parentWebViewList.size() > 1) {
                    WebView webView = parentWebViewList.get(parentWebViewList.size() - 2);
                    webView.reload();
                }
            });
        }

        @JavascriptInterface
        public void openerACheck(String data) {
            Log.i(TAG, "openerACheck");
            mWebView.post(new Runnable() {
                @Override
                public void run() {
                    WebView webView = parentWebViewList.get(parentWebViewList.size() - 2);
                    webView.loadUrl("javascript:setACheck('"+data+"')");
                }
            });
        }

        @JavascriptInterface
        public void getCPermission() {
            Log.i(TAG, "getCPermission");
            mWebView.post(new Runnable() {
                @Override
                public void run() {
                    checkCameraPermission();
                    WebSettings mWebSettings = mWebView.getSettings();
                    mWebSettings.setMediaPlaybackRequiresUserGesture(false);
                    mWebSettings.setJavaScriptEnabled(true);
                    mWebView.loadUrl("javascript:go_reload()");
                }
            });
        }

        @JavascriptInterface
        public void openergoback(String data) {
            Log.i(TAG, "openergoback");
            mWebView.post(new Runnable() {
                @Override
                public void run() {
                    if (mWebView.canGoBack()) {
                        mWebView.goBack();
                        if(data.equals("card")){
                            mWebView.goBack();
                        }
                    }
                }
            });
        }
        @JavascriptInterface
        public void closeSelf() { // 다이얼로그 종료
            Log.i(TAG, "closeSelf");
            runOnUiThread(() -> {
                if (webViewDialogList != null) {
                    if (webViewDialogList.peek().isShowing()) {
                        if (!webViewDialogList.empty()) {
                            webViewDialogList.peek().dismiss();
                            webViewDialogList.pop();
                        }
                        if (!parentWebViewList.empty())
                            parentWebViewList.pop();
                        if (parentWebViewList.size() == 1) {
                            isDialogWebView = false;
                        }
                    } else {
                        Log.i(TAG, "dialog has not find");
                    }

                }
            });
        }

        @JavascriptInterface
        public void redirectOpener(String url) {  // 부모페이지 리다이렉트
            Log.i(TAG, "redirectOpener");
            runOnUiThread(() -> {
                if (parentWebViewList != null && parentWebViewList.size() > 1) {

                    WebView webView = parentWebViewList.get(parentWebViewList.size() - 2);
                    webView.loadUrl(url);
                }
            });
        }

        @JavascriptInterface
        public void callOpenerFunction(String functionName) { // 부모페이지의 펑션호출
            Log.i(TAG, "callOpenerFunction functionName = " + functionName);
            runOnUiThread(() -> {
                if (parentWebViewList != null && parentWebViewList.size() > 1) {
                    WebView webView = parentWebViewList.get(parentWebViewList.size() - 2);
                    webView.evaluateJavascript("javascript:" + functionName + "()", null);
                }

            });
        }

        @JavascriptInterface
        public void changeOpenerValueById2(String id, String value) { // 부모페이지의 속성변경
            Log.i(TAG, "callOpenerFunction id, value = " + id + "   " + value);
            runOnUiThread(() -> {
                if (parentWebViewList != null && parentWebViewList.size() > 1) {
                    WebView webView = parentWebViewList.get(parentWebViewList.size() - 2);
                    webView.evaluateJavascript("javascript:document.getElementById('" + id + "').value = '" + value + "';", null);
                }
            });
        }

        @JavascriptInterface
        public void changeOpenerValueById(String id, String value) { // 부모페이지의 속성변경
            Log.i(TAG, "callOpenerFunction id, value = " + id + "   " + value);
            runOnUiThread(() -> {
                if (parentWebViewList != null && parentWebViewList.size() > 1) {
                    WebView webView = parentWebViewList.get(parentWebViewList.size() - 2);
                    webView.evaluateJavascript("javascript:document.getElementById('" + id + "').value = '" + value + "';", null);
                }
            });
        }

        @JavascriptInterface
        public void changeOpenerStyleById(String id, String name, String value) { // 부모페이지의 속성변경
            Log.i(TAG, "changeOpenerStyleById id, name, value = " + id + "    " + name + "    " + value);
            runOnUiThread(() -> {
                if (parentWebViewList != null && parentWebViewList.size() > 1) {
                    WebView webView = parentWebViewList.get(parentWebViewList.size() - 2);
                    webView.evaluateJavascript("javascript:document.getElementById('" + id + "').style." + name + " = '" + value + "'", null);
                }

            });
        }

        @JavascriptInterface
        public void changeOpenerTextById(String id, String text) { // 부모페이지의 속성변경
            Log.i(TAG, "changeOpenerStyleById id, name, value = " + id + "    " + text);
            runOnUiThread(() -> {
                if (parentWebViewList != null && parentWebViewList.size() > 1) {
                    WebView webView = parentWebViewList.get(parentWebViewList.size() - 2);
                    webView.evaluateJavascript("javascript:document.getElementById('" + id + "').innerText = '" + text + "'", null);
                }

            });
        }

        @JavascriptInterface
        public void changeOpenerHtmlById(String id, String html) { // 부모페이지의 속성변경
            Log.i(TAG, "changeOpenerStyleById id, html = " + id + "    " + html);
            runOnUiThread(() -> {
                if (parentWebViewList != null && parentWebViewList.size() > 1) {
                    WebView webView = parentWebViewList.get(parentWebViewList.size() - 2);
                    webView.evaluateJavascript("javascript:document.getElementById('" + id + "').innerHTML = '" + html + "'", null);
                }

            });
        }

        @JavascriptInterface
        public void openPostUrl(String url, String params) { // post방식으로 호출
            Log.i(TAG, "openPostUrl = " + url);
            runOnUiThread(() -> {
                if (parentWebViewList != null && parentWebViewList.size() > 1) {


                    WebView webView = parentWebViewList.peek();
                    try {
                        webView.postUrl(url, URLEncoder.encode(params, "UTF-8").getBytes());
                    } catch (UnsupportedEncodingException e) {
                        e.printStackTrace();
                        // TODO:
                    }
                }

            });
        }

        public class WebViewDialog extends Dialog {
            public WebViewDialog(@NonNull Context context, int themeResId) {
                super(context, themeResId);
            }

            @Override
            public void onBackPressed() {
                // 다이얼로그 웹뷰안에서 물리 백버튼을 누른 경우 처리
                if(dialogWebBridge.isDialogWebView) {
                    if(dialogWebBridge.getParentWebViewList().peek().canGoBack()) {
                        dialogWebBridge.getParentWebViewList().peek().goBack();
                    } else {
                        dialogWebBridge.closeSelf();
                    }
                } else {
                    super.onBackPressed();
                }
            }
        }
    }


    private String getCookie(String siteName) {
        String cookieValue = null;
        CookieManager cookieManager = CookieManager.getInstance();
        String cookies = cookieManager.getCookie(siteName);
        return cookies;
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        mWebView.loadUrl(intent.toString());
        //loadUrl(intent);
    }

    private class CommonWebViewClient extends WebViewClient {
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            view.loadUrl(url);
            return true;
        }

        @TargetApi(Build.VERSION_CODES.LOLLIPOP)
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {

            Log.i(TAG, "shouldOverrideUrlLoading = " + request.getUrl());
            Uri uri = request.getUrl();
            String urlScheme = uri.getScheme();
            Log.i(TAG, "urlScheme = " + urlScheme);

            return super.shouldOverrideUrlLoading(view, request);
//            }

        }

        @Override
        public void onPageFinished(WebView view, String url) {
            Log.i(TAG, "[ onPageFinished ] url = " + url);
            super.onPageFinished(view, url);
        }

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            Log.i(TAG, "[ onPageStarted ] url = " + url);
            Log.i(TAG, "getCookie = " + getCookie(url));

            super.onPageStarted(view, url, favicon);
        }

        @Override
        public void onFormResubmission(WebView view, Message dontResend, Message resend) {
            Log.i(TAG, "onFormResubmission called~~~~!");
            resend.sendToTarget();
        }
    }

    private void loadUrl(Intent data) {
        Uri url = data.getData();

        Log.i(TAG, "loadUrl url = " + url);

        if (url != null && !url.equals("")) {
            mWebView.loadUrl(url.toString());
        } else {
            finish();
        }
    }
}
