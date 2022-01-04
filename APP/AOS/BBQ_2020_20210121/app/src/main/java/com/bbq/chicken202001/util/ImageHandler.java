package com.bbq.chicken202001.util;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Environment;
import android.util.Log;


import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class ImageHandler {

    /*-----------------------------------------------------------------------
     * sd카드 BBQ 폴더에 이미지 저장
     *-----------------------------------------------------------------------*/
    static public Boolean save(Bitmap bitmap, String name) {
        Boolean ret = false;

        //
        // directory 생성
        //
        File myDir = new File(Environment.getExternalStorageDirectory().getAbsolutePath() + "/BBQ");
        myDir.mkdir();

        File imgFile = new File(myDir, name);

        //
        // 기존 이미지 삭제
        //
        if (imgFile.exists ())
            imgFile.delete ();

        //
        // 이미지 생성
        //
        try {
            imgFile.createNewFile();
            FileOutputStream outStream = new FileOutputStream(imgFile);
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, outStream);
            outStream.flush();
            outStream.close();
            ret = true;
        } catch (FileNotFoundException e) {
            Log.e("saveBitmapToJpg","FileNotFoundException : " + e.getMessage());
        } catch (IOException e) {
            Log.e("saveBitmapToJpg","IOException : " + e.getMessage());
        }

        return ret;
    }


    /*-----------------------------------------------------------------------
     * sd카드 BBQ 폴더로부터 이미지 로드
     *-----------------------------------------------------------------------*/
    static public Bitmap load(String name) {
        String filePath = Environment.getExternalStorageDirectory().getAbsolutePath() + "/BBQ/" + name;
        File   imgFile  = new File(filePath);

        Bitmap bmp = BitmapFactory.decodeFile(imgFile.getAbsolutePath());
        return bmp;
    }
}
