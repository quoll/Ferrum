#define NS_PRIVATE_IMPLEMENTATION
#define MTL_PRIVATE_IMPLEMENTATION

#include <iostream>
#include <Metal/Metal.hpp>
#include <MetalKit/MetalKit.hpp>
#include <simd/simd.h>

#include "FoundationEx.hpp"

const char* LIB_NAME = "libferrum";
const char* LIB_TYPE = "metallib";
const char* FERRUM_LIB = "FERRUM_LIB";

inline NS::String* nsStr(const char* str) {
  return NS::String::string(str, NS::UTF8StringEncoding);
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


int main(void) {
  NS::Array* devices = MTL::CopyAllDevices();
  int length = devices != nullptr ? devices->count() : 0;
  if (length == 0) {
    std::cout << "Metal is not supported on this device" << std::endl;
    return 1;
  }
  MTL::Device* device = devices->object<MTL::Device>(0);
  std::cout << "Running on device: " << device->name()->utf8String() << std::endl;

  MTL::CommandQueue* commandQueue = device->newCommandQueue();

  const char* shader = R"(
  #include <metal_stdlib>
  using namespace metal;

  kernel void add_arrays(const device float* inA,
                         const device float* inB,
                         device float* c,
                         uint id [[thread_position_in_grid]]) {
  c[id] = inA[id] + inB[id];
  })";
  NS::Error* pError = nullptr;
  MTL::Library* library = device->newLibrary(NS::String::string(shader, NS::UTF8StringEncoding), nullptr, &pError);

  if (pError != nullptr) {
    std::cout << "Error: " << pError->localizedDescription()->utf8String() << std::endl;
    return 1;
  } else if (library == nullptr) {
    std::cout << "Error: Failed to create library" << std::endl;
    return 1;
  } 

  MTL::Function* function = library->newFunction(NS::String::string("add_arrays", NS::UTF8StringEncoding));

  MTL::ComputePipelineState* pipelineState = device->newComputePipelineState(function, &pError);

  if (pError != nullptr) {
    std::cout << "Error: " << pError->localizedDescription()->utf8String() << std::endl;
    return 1;
  } else if (pipelineState == nullptr) {
    std::cout << "Error: Failed to create pipeline state" << std::endl;
    return 1;
  }

  const int arrayLength = 4;
  const float a[arrayLength] = {1.0, 2.0, 3.0, 4.0};
  const float b[arrayLength] = {5.0, 6.0, 7.0, 8.0};

  MTL::Buffer* bufferA = device->newBuffer(a, sizeof(float) * arrayLength, MTL::StorageModeShared);
  MTL::Buffer* bufferB = device->newBuffer(b, sizeof(float) * arrayLength, MTL::StorageModeShared);
  MTL::Buffer* resultBuffer = device->newBuffer(sizeof(float) * arrayLength, MTL::StorageModeShared);

  if (bufferA == nullptr || bufferB == nullptr || resultBuffer == nullptr) {
    std::cout << "Error: Failed to create buffers" << std::endl;
    return 1;
  }


  MTL::CommandBuffer* commandBuffer = commandQueue->commandBuffer();

  if (commandBuffer == nullptr) {
    std::cout << "Error: Failed to create command buffer" << std::endl;
    return 1;
  }

  MTL::ComputeCommandEncoder* computeEncoder = commandBuffer->computeCommandEncoder();

  if (computeEncoder == nullptr) {
    std::cout << "Error: Failed to create command encoder" << std::endl;
    return 1;
  }

  computeEncoder->setComputePipelineState(pipelineState);
  computeEncoder->setBuffer(bufferA, 0, 0);
  computeEncoder->setBuffer(bufferB, 0, 1);
  computeEncoder->setBuffer(resultBuffer, 0, 2);

  MTL::Size gridSize = MTL::Size(1, 1, 1);
  MTL::Size threadGroupSize = MTL::Size(arrayLength, 1, 1);

  computeEncoder->dispatchThreadgroups(gridSize, threadGroupSize);

  computeEncoder->endEncoding();
  commandBuffer->commit();
  commandBuffer->waitUntilCompleted();

  float* result = reinterpret_cast<float*>(resultBuffer->contents());

  std::cout << "Result: [";
  for (int i = 0; i < arrayLength; i++) {
    if (i > 0) {
      std::cout << ", ";
    }
    std::cout << result[i];
  }
  std::cout << "]" << std::endl;

  resultBuffer->release();
  bufferB->release();
  bufferA->release();
  pipelineState->release();
  function->release();
  library->release();
  commandQueue->release();
  device->release();
  return 0;
}

