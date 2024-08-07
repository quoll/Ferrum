#include <jni.h>
#include "ferrum_FerrumEngine.h"

#include "functions.hpp"
#include "engine.hpp"
#include <iostream>

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

JNIEXPORT jfloatArray JNICALL Java_ferrum_FerrumEngine_add_1vect(JNIEnv* env, jobject obj, jfloatArray a, jfloatArray b) {
  Ferrum::MetalEngine* engine = reinterpret_cast<Ferrum::MetalEngine*>(env->GetLongField(obj, engineFieldID));
  int lena = env->GetArrayLength(a);
  int lenb = env->GetArrayLength(b);
  int len = lena < lenb ? lena : lenb;
  jfloat *aa = env->GetFloatArrayElements(a, NULL);
  jfloat *bb = env->GetFloatArrayElements(b, NULL);
  jfloatArray jresult = env->NewFloatArray(len);
  jfloat *res = env->GetFloatArrayElements(jresult, NULL);
  engine->vect_add(aa, lena, bb, lenb, res, len);
  env->ReleaseFloatArrayElements(a, aa, JNI_ABORT);
  env->ReleaseFloatArrayElements(b, bb, JNI_ABORT);
  env->ReleaseFloatArrayElements(jresult, res, 0);
  return jresult;
}

