#define NS_PRIVATE_IMPLEMENTATION
#define MTL_PRIVATE_IMPLEMENTATION

#include <iostream>
#include <string>
#include <unordered_map>
#include <Metal/Metal.hpp>
#include <MetalKit/MetalKit.hpp>
#include <simd/simd.h>

#include "metal-compute.hpp"
#include "FoundationEx.hpp"

const char* LIB_NAME = "libferrum";
const char* LIB_TYPE = "metallib";
const char* FERRUM_LIB = "FERRUM_LIB";

const char* str(const NS::String* s);
MTL::Device* getDevice();
MTL::Library* initLibrary(MTL::Device* device, const char* path);


// constructor for Ferrum::MetalEngine
Ferrum::MetalEngine::MetalEngine(const char* path) {
  this.device = getDevice();
  this.library = initLibrary(device, path);
  if (this.library == nullptr) {
    std::cerr << "Error: Failed to initialize Metal library" << std::endl;
    return;
  }

  this.commandQueue = device->newCommandQueue();

  NS::Array* functions = library->functionNames();
  int fnCount = functions->count();
  if (fnCount == 0) {
    std::cerr << "Error: No functions found in library" << std::endl;
    return;
  }
  this.kernelFunctions = new MTL::Function*[fnCount];
  this.pipelineStates = new MTL::ComputePipelineState*[fnCount];
  NS::Error* pError = nullptr;
  for (int i = 0; i < fnCount; i++) {
    NS::String* fnName = static_cast<NS::String*>(functions->object(i))
    this.kernelFunctions[i] = library->newFunction(fnName);
    if (this.kernelFunctions[i] == nullptr) {
      std::cerr << "Error: Failed to create function: " << str(fnName) << std::endl;
    }
    MTL::ComputePipelineState* pipelineState = device->newComputePipelineState(kernelFunction[i], &pError);
    if (pError != nullptr) {
      std::cerr << "Error: on function '" << str(fnName) << "': " << str(pError->localizedDescription()) << std::endl;
    } else if (pipelineState == nullptr) {
      std::cerr << "Error: Failed to create pipeline state for: " << str(fnName) << std::endl;
    }
  }
}


Ferrum::MetalEngine::~MetalEngine() {
  if (pipelineState != nullptr) {
    for (int i = 0; i < library->functionCount(); i++) {
      if (pipelineStates[i] != nullptr) {
        pipelineStates[i]->release();
      }
      if (kernelFunctions[i] != nullptr) {
        kernelFunctions[i]->release();
      }
    }
    delete[] pipelineStates;
    delete[] kernelFunctions;
  }
  if (commandQueue != nullptr) {
    commandQueue->release();
  }
  if (library != nullptr) {
    library->release();
  }
}


inline NS::String* nsStr(const char* s) {
  return NS::String::string(s, NS::UTF8StringEncoding);
}

const char* str(const NS::String* s) {
  return (s != nullptr) ? s->utf8String() : "<null>";
}

NS::String* metalExt = nsStr(LIB_TYPE);
NS::String* ferrumName = nsStr(LIB_NAME);

NS::String* getEnv(const char* name) {
  const char* value = std::getenv(name);
  return value != nullptr ? nsStr(value) : nullptr;
}

const NS::String* getLibPath(const char* path) {
  NS::String* resource = (path == nullptr) ? ferrumName : nsStr(path);
  // check in the bundle
  NS::BundleEx* mainBundle = NS::BundleEx::mainBundle();
  if (mainBundle != nullptr && mainBundle->bundlePath() != nullptr) {
    const NS::String* resource_path = mainBundle->pathForResource(resource, metalExt);
    if (resource_path != nullptr) {
      return resource_path;
    }
  }

  // not in the bundle, so check if the path points to the file
  bool isDir = false;
  NS::FileManager* fileManager = NS::FileManager::defaultManager();

  if (path != nullptr) {
    if (fileManager != nullptr && fileManager->fileExistsAtPath(resource, &isDir)) {
      // if it's not a directory, then it's the file
      if (!isDir) {
        return resource;
      }
      // it's a directory, so check if the file is in that directory
      const NS::String* lib_path = NS::StringEx::asStringEx(resource)
                                       ->stringByAppendingPathComponent(ferrumName)
                                       ->stringByAppendingPathExtension(metalExt);
      if (fileManager->fileExistsAtPath(lib_path, &isDir)) {
        if (!isDir) {
          return lib_path;
        }
      }
    }
    return nullptr;
  }

  NS::StringEx* resource_path = NS::StringEx::asStringEx(getEnv(FERRUM_LIB));
  if (resource_path != nullptr) {
    resource_path = NS::StringEx::asStringEx(resource_path)
                        ->stringByAppendingPathComponent(ferrumName)
                        ->stringByAppendingPathExtension(metalExt);
  } else {
    resource_path = NS::StringEx::asStringEx(nsStr("./lib"))
                        ->stringByAppendingPathComponent(ferrumName)
                        ->stringByAppendingPathExtension(metalExt);
  }
  if (fileManager != nullptr && fileManager->fileExistsAtPath(resource_path, &isDir)) {
    if (!isDir) {
      return resource_path;
    }
  }
  return nullptr;
}

MTL::Device* getDevice() {
  NS::Array* devices = MTL::CopyAllDevices();
  int length = devices != nullptr ? devices->count() : 0;
  if (length == 0) {
    std::cerr << "Metal is not supported on this device" << std::endl;
    return nullptr;
  }
  MTL::Device* device = devices->object<MTL::Device>(0);
  // std::cout << "Running on device: " << device->name()->utf8String() << std::endl;
  return device;
}

MTL::Library* initLibrary(MTL::Device* device, const char* path) {

  NS::String* libPath = getLibPath(path);
  if (libPath == nullptr) {
    std::cerr << "Error: Failed to find library" << std::endl;
    return -2;
  }
  NS::URL* url = NS::URL::fileURLWithPath(libPath);
  if (url == nullptr) {
    std::cerr << "Error: Failed to create URL for: " << str(libPath) << std::endl;
    return -3;
  }

  NS::Error* pError = nullptr;
  MTL::Library* library = device->newLibrary(url, &pError);

  if (pError != nullptr) {
    std::cerr << "Error: " << str(pError->localizedDescription()) << std::endl;
    return -4;
  } else if (library == nullptr) {
    std::cerr << "Error: Failed to create library from: " << url->fileSystemRepresentation() << std::endl;
    return -5;
  } 

  // std::cout << "Successfully loaded library: " << str(libPath) << std::endl;

  return library;
}

