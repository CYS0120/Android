package com.bbq.chicken202001;

import android.content.Intent;
//import android.support.v7.app.AppCompatActivity;

import android.os.Bundle;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.bbq.chicken202001.activity.MainActivity;
import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;

public class QRScane extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_qrscane);
        new IntentIntegrator(this).initiateScan();
    }

    /**
     * 이곳이 결과를 리턴해 주는 곳
     * @param requestCode
     * @param resultCode
     * @param data
     */
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        IntentResult result = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
        if(result != null) {
            if(result.getContents() == null) {
                Toast.makeText(this, "Cancelled", Toast.LENGTH_LONG).show();
            } else {
                Toast.makeText(this, "Scanned: " + result.getContents(), Toast.LENGTH_LONG).show();

                //메인 엑티비티에 결과 전달.
                MainActivity.sendBarcodeToWeb(result.getContents());
//                Log.d("barCodeData 호출..", result.getContents());

//                Intent intent = new Intent(getApplicationContext(), MainActivity.class);
//                intent.putExtra("code",result.getContents()); /*송신*/
//                startActivity(intent);


            }
        } else {
            super.onActivityResult(requestCode, resultCode, data);
        }
        finish();
    }
}
