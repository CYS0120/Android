package com.bbq.chicken202001.util;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Environment;
import android.provider.MediaStore;
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

        File folder = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS), "BBQ");
        if (!folder.exists()) {
            if (!folder.mkdir()) {
                return false;
            }
        }

        File file = new File(folder, name);

        //
        // 기존 이미지 삭제
        //
        if (file.exists())
            file.delete();

        //
        // 이미지 생성
        //
        try {
            file.createNewFile();
            FileOutputStream outStream = new FileOutputStream(file);
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

    /*
    File folder = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS), "BBQ");
        if (!folder.exists()) {
            if (!folder.mkdir()) {
                return false;
            }
        }
     */

    /*-----------------------------------------------------------------------
     * sd카드 BBQ 폴더로부터 이미지 로드
     *-----------------------------------------------------------------------*/
    static public Bitmap load(String name) {
        String filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).toString() + "/BBQ/" + name;
        File   imgFile  = new File(filePath);

        Bitmap bmp = BitmapFactory.decodeFile(imgFile.getAbsolutePath());
        return bmp;
    }
}
