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

// vector function implementations

template <typename CallWithArgs>
JNIEXPORT jfloatArray JNICALL vect1(JNIEnv* env, jobject obj, jstring fn,
                                    jfloatArray a,
                                    CallWithArgs call) {
  const char* cfn = env->GetStringUTFChars(fn, NULL);
  Ferrum::FunctionID fnId = Ferrum::getFunctionID(cfn);
  if (fnId == Ferrum::FunctionID::UNKNOWN) {
    std::string msg = "Unknown function: " + std::string(cfn);
    env->ReleaseStringUTFChars(fn, cfn);
    env->ThrowNew(env->FindClass(ILLEGAL_ARG_EX), msg.c_str());
    return NULL;
  }
  env->ReleaseStringUTFChars(fn, cfn);
  Ferrum::MetalEngine* engine = reinterpret_cast<Ferrum::MetalEngine*>(env->GetLongField(obj, engineFieldID));
  int len = env->GetArrayLength(a);
  jfloat *aa = env->GetFloatArrayElements(a, NULL);
  jfloatArray jresult = env->NewFloatArray(len);
  jfloat *res = env->GetFloatArrayElements(jresult, NULL);
  call(engine, fnId, aa, len, res);
  env->ReleaseFloatArrayElements(a, aa, JNI_ABORT);
  env->ReleaseFloatArrayElements(jresult, res, 0);
  return jresult;
}

enum class ArgSelection { A, B };

template <typename CallWithArgs>
JNIEXPORT jfloatArray JNICALL vect2(JNIEnv* env, jobject obj, jstring fn,
                                    jfloatArray a, jfloatArray b,
                                    CallWithArgs call) {
  const char* cfn = env->GetStringUTFChars(fn, NULL);
  Ferrum::FunctionID fnId = Ferrum::getFunctionID(cfn);
  if (fnId == Ferrum::FunctionID::UNKNOWN) {
    std::string msg = "Unknown function: " + std::string(cfn);
    env->ReleaseStringUTFChars(fn, cfn);
    env->ThrowNew(env->FindClass(ILLEGAL_ARG_EX), msg.c_str());
    return NULL;
  }
  env->ReleaseStringUTFChars(fn, cfn);
  Ferrum::MetalEngine* engine = reinterpret_cast<Ferrum::MetalEngine*>(env->GetLongField(obj, engineFieldID));
  int lena = env->GetArrayLength(a);
  int lenb = env->GetArrayLength(b);
  // take on the same shape as the shorter of the two
  int lenr;
  ArgSelection args;
  if (lena < lenb) {
    lenr = lena;
    args = ArgSelection::A;
  } else {
    lenr = lenb;
    args = ArgSelection::B;
  }
  int len = lena < lenb ? lena : lenb;
  jfloat *aa = env->GetFloatArrayElements(a, NULL);
  jfloat *bb = env->GetFloatArrayElements(b, NULL);
  jfloatArray jresult = env->NewFloatArray(len);
  jfloat *res = env->GetFloatArrayElements(jresult, NULL);
  int keep = call(engine, fnId, aa, lena, bb, lenb, res, lenr, args);
  env->ReleaseFloatArrayElements(a, aa, JNI_ABORT);
  env->ReleaseFloatArrayElements(b, bb, keep);
  env->ReleaseFloatArrayElements(jresult, res, 0);
  return jresult;
}

JNIEXPORT jfloatArray JNICALL Java_ferrum_FerrumEngine_vect_1bB
  (JNIEnv* env, jobject obj, jstring fn, jfloatArray a, jint offset_a, jint stride_a) {
  return vect1(env, obj, fn, a,
               [=](Ferrum::MetalEngine* engine, Ferrum::FunctionID fnId, jfloat* a, int len, jfloat* res) {
                 engine->vect_bB(fnId, a, len, offset_a, stride_a, res, len, offset_a, stride_a);
               });
}

JNIEXPORT jfloatArray JNICALL Java_ferrum_FerrumEngine_vect_1bfB
  (JNIEnv* env, jobject obj, jstring fn, jfloatArray a, jint offset_a, jint stride_a, jfloat sa) {
  return vect1(env, obj, fn, a,
               [=](Ferrum::MetalEngine* engine, Ferrum::FunctionID fnId, jfloat* a, int len, jfloat* res) {
                 engine->vect_bfB(fnId, a, len, offset_a, stride_a, sa, res, len, offset_a, stride_a);
               });
}

JNIEXPORT jfloatArray JNICALL Java_ferrum_FerrumEngine_vect_1fbB
  (JNIEnv* env, jobject obj, jstring fn, jfloat sa, jfloatArray a, jint offset_a, jint stride_a) {
  return vect1(env, obj, fn, a,
               [=](Ferrum::MetalEngine* engine, Ferrum::FunctionID fnId, jfloat* a, int len, jfloat* res) {
                 engine->vect_fbB(fnId, sa, a, len, offset_a, stride_a, res, len, offset_a, stride_a);
               });
}

JNIEXPORT jfloatArray JNICALL Java_ferrum_FerrumEngine_vect_1bbB
  (JNIEnv* env, jobject obj, jstring fn, jfloatArray a, jint offset_a, jint stride_a, jfloatArray b, jint offset_b, jint stride_b) {
  return vect2(env, obj, fn, a, b,
               [=](Ferrum::MetalEngine* engine, Ferrum::FunctionID fnId, jfloat* a, int lena, jfloat* b, int lenb, jfloat* res, int lenr, ArgSelection args) {
                 int offset, stride;
                 if (args == ArgSelection::A) {
                   offset = offset_a;
                   stride = stride_a;
                 } else {
                   offset = offset_b;
                   stride = stride_b;
                 }
                 engine->vect_bbB(fnId, a, lena, offset_a, stride_a, b, lenb, offset_b, stride_b, res, lenr, offset, stride);
                 return JNI_ABORT;  // free the b array
               });
}

JNIEXPORT jfloatArray JNICALL Java_ferrum_FerrumEngine_vect_1bBB
  (JNIEnv* env, jobject obj, jstring fn, jfloatArray a, jint offset_a, jint stride_a, jfloatArray b, jint offset_b, jint stride_b) {
  return vect2(env, obj, fn, a, b,
               [=](Ferrum::MetalEngine* engine, Ferrum::FunctionID fnId, jfloat* a, int lena, jfloat* b, int lenb, jfloat* res, int lenr, ArgSelection args) {
                 int offset, stride;
                 if (args == ArgSelection::A) {
                   offset = offset_a;
                   stride = stride_a;
                 } else {
                   offset = offset_b;
                   stride = stride_b;
                 }
                 engine->vect_bBB(fnId, a, lena, offset_a, stride_a, b, lenb, offset_b, stride_b, res, lenr, offset, stride);
                 return 0;  // keep the b array
               });
}

JNIEXPORT jfloatArray JNICALL Java_ferrum_FerrumEngine_vect_1bffffB
  (JNIEnv* env, jobject obj, jstring fn, jfloatArray a, jint offset_a, jint stride_a, jfloat sa, jfloat sha, jfloat sb, jfloat shb) {
  return vect1(env, obj, fn, a,
               [=](Ferrum::MetalEngine* engine, Ferrum::FunctionID fnId, jfloat* a, int len, jfloat* res) {
                 engine->vect_bffffB(fnId, a, len, offset_a, stride_a,
                                     sa, sha, sb, shb,
                                     res, len, offset_a, stride_a);
               });
}

JNIEXPORT jfloatArray JNICALL Java_ferrum_FerrumEngine_vect_1bbffffB
  (JNIEnv* env, jobject obj, jstring fn, jfloatArray a, jint offset_a, jint stride_a, jfloatArray b, jint offset_b, jint stride_b,
   jfloat sa, jfloat sha, jfloat sb, jfloat shb) {
  return vect2(env, obj, fn, a, b,
               [=](Ferrum::MetalEngine* engine, Ferrum::FunctionID fnId, jfloat* a, int lena, jfloat* b, int lenb, jfloat* res, int lenr, ArgSelection args) {
                 int offset, stride;
                 if (args == ArgSelection::A) {
                   offset = offset_a;
                   stride = stride_a;
                 } else {
                   offset = offset_b;
                   stride = stride_b;
                 }
                 engine->vect_bbffffB(fnId, a, lena, offset_a, stride_a, b, lenb, offset_b, stride_b,
                                      sa, sha, sb, shb,
                                      res, lenr, offset, stride);
                 return JNI_ABORT;  // free the b array
               });
}

