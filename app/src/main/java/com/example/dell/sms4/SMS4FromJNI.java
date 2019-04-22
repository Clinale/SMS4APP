package com.example.dell.sms4;

import android.util.Log;
import android.widget.Toast;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

public class SMS4FromJNI {

    static {
        System.loadLibrary("SMS4JNI"); // 加载库文件
    }

    public static native void sm4_setkey_enc_jni(String initKey); // 设置加密密钥
    public static native void sm4_setkey_dec_jni(String initKey); // 设置解密密钥
    public static native String sm4_crypt_ecb_jni( int mode, int length, String input); // 返回加密或解密的结果

    public static String sm4_encrypt_ecb(int mode, String filepath){ //initKey = md5(filepath)
        FileInputStream inputStream;
        File file;
        String encrypted_message = "";
        String input="";
        String initKey ="";

        byte[] content = new byte[16];

        try {
            if (mode == MainActivity.DEC_MODE) {
                initKey = filepath.substring(0, filepath.length() - 4); //去掉后缀.enc
                sm4_setkey_dec_jni(initKey);
            } else sm4_setkey_enc_jni(initKey);
        }catch(Exception e){
            //Toast.makeText(MainActivity, e.toString(), Toast.LENGTH_SHORT).show();
            Log.d("sm4_encrypt_ecb", e.toString());
        }

        try {
            file = new File(filepath);
            inputStream = new FileInputStream(file);
            int len = 0;
            while ((len = inputStream.read(content)) > 0) {
                for(int i=0; i<16; i++){
                    if(i<len) input += String.valueOf((char)content[i]);
                    else input+="0";
                }
                encrypted_message += sm4_crypt_ecb_jni(mode, 16, input);
                input="";
            }
            inputStream.close();

        }catch(IOException e){
            Log.e("sm4_encrypt_ecb", e.toString());
            return "IOException";
        }
        return encrypted_message;
    }
}
