#include <jni.h>
#include "ferrum_FerrumEngine.h"

#include "engine.hpp"
#include <iostream>

#define ILLEGAL_ARG_EX "java/lang/IllegalArgumentException"

static jfieldID engineFieldID;

JNIEXPORT jlong JNICALL Java_ferrum_FerrumEngine_init(JNIEnv* env, jclass cls, jstring path) {
  DBG("Initializing engine");
  DBG("Converting path from JVM to C++");
  char* cpath;
  cpath = path ? (char*)env->GetStringUTFChars(path, NULL) : NULL;
  DBG("Converted path");
  DBG("Creating engine");
  Ferrum::MetalEngine* engine = new Ferrum::MetalEngine(cpath);
  DBG("Created engine");
  env->ReleaseStringUTFChars(path, cpath);
  // This will stay valid while the engine class is loaded. There is no harm is setting it again.
  DBG("Getting engine field ID, and saving");
  engineFieldID = env->GetFieldID(cls, "engineHandle", "J");
  DBG("returning engine handle");
  return reinterpret_cast<jlong>(engine);
}

JNIEXPORT void JNICALL Java_ferrum_FerrumEngine_close(JNIEnv* env, jclass cls, jlong engine) {
  Ferrum::MetalEngine* e = reinterpret_cast<Ferrum::MetalEngine*>(engine);
  delete e;
}

JNIEXPORT jfloatArray JNICALL Java_ferrum_FerrumEngine_vect_1bB
  (JNIEnv* env, jobject obj, jstring fn, jfloatArray a, jint offset_a, jint stride_a) {
  return NULL;
}

JNIEXPORT jfloatArray JNICALL Java_ferrum_FerrumEngine_vect_1bfB
  (JNIEnv* env, jobject obj, jstring fn, jfloatArray a, jint offset_a, jint stride_a, jfloat sa) {
  return NULL;
}

JNIEXPORT jfloatArray JNICALL Java_ferrum_FerrumEngine_vect_1fbB
  (JNIEnv* env, jobject obj, jstring fn, jfloat sa, jfloatArray a, jint offset_a, jint stride_a) {
  return NULL;
}

JNIEXPORT jfloatArray JNICALL Java_ferrum_FerrumEngine_vect_1bbB
  (JNIEnv* env, jobject obj, jstring fn, jfloatArray a, jint offset_a, jint stride_a, jfloatArray b, jint offset_b, jint stride_b) {
  const char* cfn = env->GetStringUTFChars(fn, NULL);
  Ferrum::FunctionID fnId = Ferrum::getFunctionID(cfn);
  if (fnId == Ferrum::FunctionID::UNKNOWN) {
    std::string msg = "Unknown function:" + std::string(cfn);
    env->ReleaseStringUTFChars(fn, cfn);
    env->ThrowNew(env->FindClass(ILLEGAL_ARG_EX), msg.c_str());
    return NULL;
  }
  env->ReleaseStringUTFChars(fn, cfn);
  Ferrum::MetalEngine* engine = reinterpret_cast<Ferrum::MetalEngine*>(env->GetLongField(obj, engineFieldID));
  int lena = env->GetArrayLength(a);
  int lenb = env->GetArrayLength(b);
  int len = lena < lenb ? lena : lenb;
  jfloat *aa = env->GetFloatArrayElements(a, NULL);
  jfloat *bb = env->GetFloatArrayElements(b, NULL);
  jfloatArray jresult = env->NewFloatArray(len);
  jfloat *res = env->GetFloatArrayElements(jresult, NULL);
  engine->vect_bbB(fnId, aa, lena, 0, 1, bb, lenb, 0, 1, res, len, 0, 1);
  env->ReleaseFloatArrayElements(a, aa, JNI_ABORT);
  env->ReleaseFloatArrayElements(b, bb, JNI_ABORT);
  env->ReleaseFloatArrayElements(jresult, res, 0);
  return jresult;
}

JNIEXPORT jfloatArray JNICALL Java_ferrum_FerrumEngine_vect_1bBB
  (JNIEnv* env, jobject obj, jstring fn, jfloatArray a, jint offset_a, jint stride_a, jfloatArray b, jint offset_b, jint stride_b) {
  return NULL;
}

JNIEXPORT jfloatArray JNICALL Java_ferrum_FerrumEngine_vect_1bffffB
  (JNIEnv* env, jobject obj, jstring fn, jfloatArray a, jint offset_a, jint stride_a, jfloat sa, jfloat sha, jfloat sb, jfloat shb) {
  return NULL;
}

JNIEXPORT jfloatArray JNICALL Java_ferrum_FerrumEngine_vect_1bbffffB
  (JNIEnv* env, jobject obj, jstring fn, jfloatArray a, jint offset_a, jint stride_a, jfloatArray b, jint offset_b, jint stride_b,
   jfloat sa, jfloat sha, jfloat sb, jfloat shb) {
  return NULL;
}

