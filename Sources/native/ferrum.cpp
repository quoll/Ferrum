#include <jni.h>
#include "ferrum_FerrumEngine.h"

JNIEXPORT jfloatArray JNICALL Java_ferrum_FerrumEngine_add (JNIEnv *env, jobject nt, jfloatArray a, jfloatArray b) {
  int lena = env->GetArrayLength(a);
  int lenb = env->GetArrayLength(b);
  int len = lena < lenb ? lena : lenb;
  jfloatArray result = env->NewFloatArray(len);
  jfloat *aa = env->GetFloatArrayElements(a, NULL);
  jfloat *bb = env->GetFloatArrayElements(b, NULL);
  jfloat *res = env->GetFloatArrayElements(result, NULL);
  for (int i = 0; i < len; i++) {
    res[i] = aa[i] + bb[i];
  }
  env->ReleaseFloatArrayElements(a, aa, JNI_ABORT);
  env->ReleaseFloatArrayElements(b, bb, JNI_ABORT);
  env->ReleaseFloatArrayElements(result, res, 0);
  return result;
}

