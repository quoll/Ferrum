#define NS_PRIVATE_IMPLEMENTATION
#define MTL_PRIVATE_IMPLEMENTATION

#include <iostream>
#include <Metal/Metal.hpp>
#include <MetalKit/MetalKit.hpp>

#include <simd/simd.h>

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

  kernel void add_arrays(const device float* inA, constant uint& offset_a, constant uint& stride_a,
                         const device float* inB, constant uint& offset_b, constant uint& stride_b,
                         device float* c, constant uint& offset_c, constant uint& stride_c,
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

  bool success = true;
  for (int i = 0; i < arrayLength; i++) {
    if (result[i] != a[i] + b[i]) {
      success = false;
      break;
    }
  }
  if (success) {
    std::cout << "Success!" << std::endl;
  } else {
    std::cout << "Failed!" << std::endl;
  }

  resultBuffer->release();
  bufferB->release();
  bufferA->release();
  pipelineState->release();
  function->release();
  library->release();
  commandQueue->release();
  device->release();
  return success ? 0 : 1;
}

