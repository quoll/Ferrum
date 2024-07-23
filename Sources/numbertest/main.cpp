#define NS_PRIVATE_IMPLEMENTATION
#define MTL_PRIVATE_IMPLEMENTATION

#include <iostream>
#include <Foundation/Foundation.hpp>
#include <Metal/Metal.hpp>
#include <MetalKit/MetalKit.hpp>

#include <simd/simd.h>

int main(void) {
  NS::Array* devices = MTL::CopyAllDevices();
  int length = devices != nullptr ? devices->count() : 0;
  for (int i = 0; i < length; i++) {
    MTL::Device* device = devices->object<MTL::Device>(i);
    std::cout << "Device: " << device->name()->utf8String() << std::endl;
    device->release();
  }
  return 0;
}

