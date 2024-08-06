#include <jni.h>
#include "ferrum_FerrumEngine.h"

#include "engine.hpp"
#include <iostream>

static jfieldID engineFieldID;

JNIEXPORT jlong JNICALL Java_ferrum_FerrumEngine_init(JNIEnv* env, jclass cls, jstring path) {
  std::cout << "Initializing engine" << std::endl << "Converting path from JVM to C++" << std::endl;
  char* cpath;
  cpath = path ? (char*)env->GetStringUTFChars(path, NULL) : NULL;
  std::cout << "Converted" << std::endl << "Creating engine" << std::endl;
  Ferrum::MetalEngine* engine = new Ferrum::MetalEngine(cpath);
  std::cout << "Got engine" << std::endl;
  env->ReleaseStringUTFChars(path, cpath);
  // This will stay valid while the engine class is loaded. There is no harm is setting it again.
  std::cout << "Setting engine field" << std::endl;
  engineFieldID = env->GetFieldID(cls, "engine", "J");
  std::cout << "returning engine handle" << std::endl;
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
  jfloatArray result = env->NewFloatArray(len);
  jfloat *aa = env->GetFloatArrayElements(a, NULL);
  jfloat *bb = env->GetFloatArrayElements(b, NULL);
  jfloat *res = env->GetFloatArrayElements(result, NULL);
  engine->vect_add(aa, lena, bb, lenb, res, len);
  env->ReleaseFloatArrayElements(a, aa, JNI_ABORT);
  env->ReleaseFloatArrayElements(b, bb, JNI_ABORT);
  env->ReleaseFloatArrayElements(result, res, 0);
  return result;
}

