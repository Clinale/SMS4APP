package com.example.dell.sms4;


import android.content.Intent;
import android.net.Uri;
import android.provider.MediaStore;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;

public class MainActivity extends AppCompatActivity {

    //private static final int SELECT_IMAGE_RESULT_CODE = 1;
    //String[] proj = {MediaStore.MediaColumns.DATA};
    //private static final String TAG = "MainActivity";
    public static int ENC_MODE = 1;
    public static int DEC_MODE = 0;

    private String filepath="";
    private TextView tv;

    @Override
    protected void onCreate (Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        tv = findViewById(R.id.tv);

        Button button1 = (Button) findViewById(R.id.button_1);
        button1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
                intent.setType("text/plain");
                startActivityForResult(intent, 1);
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK && requestCode == 1) {
            try {
                //String filepath;
                Uri uri = data.getData();
                filepath = uri.getPath();
                tv.setText(filepath);

                filepath = "/storage/emulated/0/" + filepath.substring(10);



                Toast.makeText(this, "文件路径：" + filepath, Toast.LENGTH_SHORT).show();

                findViewById(R.id.button_2).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        String message = SMS4FromJNI.sm4_encrypt_ecb(ENC_MODE, filepath);
                        String path = Utils.getFilePath(filepath);
                        String name = Utils.getFileName(filepath);
                        //String newfilepath = path+"/"+name+".enc";
                        File file = Utils.createFile(path, name+".enc");
                        Utils.writeFile(file, message);

                        //Utils.deleteFile(filepath);

                        Toast.makeText(MainActivity.this, "加密成功", Toast.LENGTH_SHORT).show();
                        //Toast.makeText(MainActivity.this, "文件校验和：" + Utils.checkSum(filepath), Toast.LENGTH_SHORT).show();
                    }
                });

                findViewById(R.id.button_3).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        String ext = filepath.substring(filepath.length()-4, filepath.length());
                        if(! ext.equals(".enc")){
                            Toast.makeText(MainActivity.this, "该文件不是加密文件", Toast.LENGTH_SHORT).show();
                            Log.e("dec_mode", ext);
                            return;
                        }

                        String message = SMS4FromJNI.sm4_encrypt_ecb(DEC_MODE, filepath);
                        String path = Utils.getFilePath(filepath);
                        String name = Utils.getFileName(filepath);
                        //String newfilepath = path+"/"+name+".enc";
                        File file = Utils.createFile(path+"_dec", name.substring(0, name.length()-4));

                        Utils.writeFile(file, message);

                        Utils.deleteFile(filepath);

                        Toast.makeText(MainActivity.this, "解密成功", Toast.LENGTH_SHORT).show();
                        //Toast.makeText(MainActivity.this, "文件校验和：" + Utils.checkSum(filepath), Toast.LENGTH_SHORT).show();
                    }
                });

            }catch(NullPointerException e){
                Log.e("onActivityResult", e.toString());
            }
        }
    }




}
