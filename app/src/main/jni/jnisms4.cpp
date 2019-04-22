#include <jni.h>
#include <stdio.h>
#include <string.h>

#include "com_example_dell_sms4_SMS4FromJNI.h"
#include "sms4.h"


sm4_context ctx;

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

/*
 * Class:     com_example_dell_sms4_SMS4FromJNI
 * Method:    sm4_crypt_ecb
 * Signature: (IILjava/lang/String;)Ljava/lang/String;
 */
JNIEXPORT jstring JNICALL Java_com_example_dell_sms4_SMS4FromJNI_sm4_1crypt_1ecb_1jni
  (JNIEnv *env, jclass jclass, jint jmode, jint jlength, jstring jplain){

  unsigned char rtn[16];

  ctx.mode = (int)jmode;
  int length = (int)jlength;

  const char *plain = env->GetStringUTFChars(jplain, 0);
  sm4_crypt_ecb( &ctx, (int)jmode, length, (const unsigned char*)plain, rtn);
  env->ReleaseStringUTFChars(jplain, plain);

  //return env->NewStringUTF((const char *)rtn);
  return stoJstring(env, (const char*)rtn);

  }


