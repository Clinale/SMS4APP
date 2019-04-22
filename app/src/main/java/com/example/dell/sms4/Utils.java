package com.example.dell.sms4;

import android.text.TextUtils;
import android.util.Log;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Utils {
    public static String checkSum(String filepath){
        FileInputStream inputStream;
        File file;
        byte[] content = new byte[1024];
        byte checksum = 0;

        try {
            file = new File(filepath);
            inputStream = new FileInputStream(file);


            int len = 0;
            while ((len = inputStream.read(content)) > 0) {
                for (int i = 0; i < len; i++) checksum ^= content[i];
            }

            inputStream.close();

        }catch(IOException e){
            Log.e("checkSum", e.toString());
            return "IOException";
        }
        return String.valueOf((int)(checksum));
    }

    public static String md5(String string){
        String defaultKey = "0123456789abcdeffedcba9876543210";
        if (TextUtils.isEmpty(string)) {
            return defaultKey;
        }
        MessageDigest md5 = null;
        try {
            md5 = MessageDigest.getInstance("MD5");
            byte[] bytes = md5.digest(string.getBytes());
            String result = "";
            for (byte b : bytes) {
                String temp = Integer.toHexString(b & 0xff);
                if (temp.length() == 1) {
                    temp = "0" + temp;
                }
                result += temp;
            }
            return result;
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return defaultKey;
    }
    public static String getFileName(String pathandname){

        int start=pathandname.lastIndexOf("/");
        //int end=pathandname.lastIndexOf(".");
        if(start!=-1){
            return pathandname.substring(start+1);
        }else{
            return null;
        }

    }
    public static String getFilePath(String pathandname){
        int start=pathandname.lastIndexOf("/");
        //int end=pathandname.lastIndexOf(".");
        if(start!=-1){
            return pathandname.substring(0,start);
        }else{
            return null;
        }
    }

    public static void writeFile(File file, String content){
        try {
            if (!file.exists()) {
                Log.d("TestFile", "Create the file:" + file.getName());
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            RandomAccessFile raf = new RandomAccessFile(file, "rwd");
            raf.seek(file.length());
            raf.write(content.getBytes());
            raf.close();
        } catch (Exception e) {
            Log.e("TestFile", "Error on write File:" + e);
        }

    }

    public static File createFile(String filePath, String fileName){
        if(filePath == null || filePath.length() == 0
                || fileName == null || fileName.length() == 0){
            return null;
        }
        try {
            //判断目录是否存在，如果不存在，递归创建目录
            File dir = new File(filePath);
            if(!dir.exists()){
                dir.mkdirs();
            }

            //组织文件路径
            StringBuilder sbFile = new StringBuilder(filePath);
            if(!filePath.endsWith("/")){
                sbFile.append("/");
            }
            sbFile.append(fileName);

            //创建文件并返回文件对象
            File file = new File(sbFile.toString());
            if(!file.exists()){
                file.createNewFile();
            }
            return file;
        }catch (Exception ex){
            ex.printStackTrace();
        }
        return null;
    }


    public static void deleteFile(String filePath) {
        if(filePath == null || filePath.length() == 0){
            return;
        }
        try {
            File file = new File(filePath);
            if(file.exists()){
                deleteFile(file);
            }
        }catch (Exception ex){
            ex.printStackTrace();
        }
    }

    private static void deleteFile(File file){
        //如果是文件直接删除
        if(file.isFile()){
            file.delete();
            return;
        }
        //如果是目录，递归判断，如果是空目录，直接删除，如果是文件，遍历删除
        if(file.isDirectory()){
            File[] childFile = file.listFiles();
            if(childFile == null || childFile.length == 0){
                file.delete();
                return;
            }
            for(File f : childFile){
                deleteFile(f);
            }
            file.delete();
        }
    }

    /*
    public static String getRealPathFromURI(Context context, Uri contentURI) {
        try{
        String result;
        Cursor cursor = context.getContentResolver().query(contentURI,
                new String[]{MediaStore.Images.ImageColumns.DATA},//
                null, null, null);
        if (cursor == null) result = contentURI.getPath();
        else {
            cursor.moveToFirst();
            int index = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA);
            result = cursor.getString(index);
            cursor.close();
        }
        return result;
        }
        catch(Exception e){
            Toast.makeText(context, e.toString(), Toast.LENGTH_SHORT).show();
            return "No file";
        }
    }
    */

}
