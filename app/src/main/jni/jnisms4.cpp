#include <jni.h>
#include <stdio.h>
#include <string.h>

#include "com_example_dell_sms4_SMS4FromJNI.h"
#include "sms4.h"

#define MyException "java.io.FileNotFoundException"

sm4_context ctx;

void
 JNU_ThrowByName(JNIEnv *env, const char *name, const char *msg)
 {
     jclass cls = env->FindClass(name);
     /* if cls is NULL, an exception has already been thrown */
     if (cls != NULL) {
         (env)->ThrowNew(cls, msg);
     }
     /* free the local ref */
     (env)->DeleteLocalRef(cls);
 }

jstring stoJstring(JNIEnv* global_env, const char* chm_pcText)
  {
  jclass strClass = global_env->FindClass("java/lang/String");
  jmethodID ctorID = global_env->GetMethodID(strClass, "<init>", "([BLjava/lang/String;)V");
  jstring encoding = global_env->NewStringUTF("utf-8");

  jbyteArray bytes = global_env->NewByteArray(strlen(chm_pcText));
  global_env->SetByteArrayRegion(bytes, 0, strlen(chm_pcText), (jbyte*)chm_pcText);
  return (jstring)global_env->NewObject(strClass, ctorID, bytes, encoding);
  }

/*
 * Class:     com_example_dell_sms4_SMS4FromJNI
 * Method:    sm4_setkey_enc
 * Signature: (Ljava/lang/String;)V
 */
JNIEXPORT void JNICALL Java_com_example_dell_sms4_SMS4FromJNI_sm4_1setkey_1enc_1jni
  (JNIEnv *env, jclass jclass, jstring initKey){
  unsigned char key[16];

  const char *nativeString = env->GetStringUTFChars(initKey, 0);
  for(int i=0; i<16; i++){
    key[i] = (nativeString[(i<<1)]<<4) + nativeString[(i<<1)+1];
  }
  env->ReleaseStringUTFChars( initKey, nativeString);

  sm4_setkey_enc( &ctx, key );

  }

/*
 * Class:     com_example_dell_sms4_SMS4FromJNI
 * Method:    sm4_setkey_dec
 * Signature: (Ljava/lang/String;)V
 */
JNIEXPORT void JNICALL Java_com_example_dell_sms4_SMS4FromJNI_sm4_1setkey_1dec_1jni
  (JNIEnv *env, jclass jclass, jstring initKey){
  unsigned char key[16];

  const char *nativeString = env->GetStringUTFChars(initKey, 0);
  for(int i=0; i<16; i++){
      key[i] = (nativeString[(i<<1)]<<4) + nativeString[(i<<1)+1];
  }
  env->ReleaseStringUTFChars(initKey, nativeString);

  sm4_setkey_dec( &ctx, key );

  }

void getFilePath(JNIEnv *env, int mode, char* filepath, char* cryptpath, jstring jpath, jstring jname){

  const char* path = env->GetStringUTFChars(jpath, 0);
    const char* name = env->GetStringUTFChars(jname, 0);
    strcpy(filepath, path);
    strcat(filepath, "/");
    strcat(filepath, name);

    if(mode==SM4_DECRYPT){
      strcpy(cryptpath, path);
      strcat(cryptpath, "/dec_");
      strcat(cryptpath, name);
      cryptpath[strlen(cryptpath)-4]='\0'; //去掉后缀.enc
    }else{
      strcpy(cryptpath, filepath);
      strcat(cryptpath, ".enc"); //加密后缀为.enc
    }

    env->ReleaseStringUTFChars(jpath, path);
    env->ReleaseStringUTFChars(jname, name);
}
/*
 * Class:     com_example_dell_sms4_SMS4FromJNI
 * Method:    sm4_crypt_ecb
 * Signature: (IILjava/lang/String;)Ljava/lang/String;
 */
JNIEXPORT void JNICALL Java_com_example_dell_sms4_SMS4FromJNI_sm4_1crypt_1ecb_1jni
  (JNIEnv *env, jclass jclass, jint jmode, jstring jpath, jstring jname){

  char rtn[16];
  char buffer[17];
  char filepath[100], cryptpath[100]; //存储路径

  FILE *fin, *fout;
  ctx.mode = (int)jmode;

  getFilePath(env, (int)jmode, filepath, cryptpath, jpath, jname);

  if((fin=fopen(filepath, "rb"))==NULL || (fout=fopen(cryptpath, "wb"))==NULL){
    JNU_ThrowByName(env, MyException, "cannot open file");
  }

  fseek(fin, 0, SEEK_END);
  int nFileLen = ftell(fin); // 文件长度
  fseek(fin, 0, SEEK_SET); // 定位文件开始
  int nHandleLen=0;
  while(nHandleLen!=nFileLen){
    int nRead = nFileLen-nHandleLen>=16?16:nFileLen-nHandleLen;
    int tmp = fread(buffer, 1, nRead, fin); //读取16个字节
    for(int i=tmp; i<16; i++) buffer[i] = 0; //填充0

    sm4_crypt_ecb(&ctx, (int)jmode, 16, (const unsigned char*)buffer, (unsigned char*)rtn);

    fwrite((const unsigned char*)rtn, 1, 16, fout); //写入加密结果

    nHandleLen += nRead;
  }

  fclose(fin);
  fclose(fout);



  //return env->NewStringUTF((const char *)rtn);
  //return stoJstring(env, (const char*)rtn);

  }


