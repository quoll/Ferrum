#pragma once

#ifndef METAL_COMPUTE_HPP
#define METAL_COMPUTE_HPP

#include "FoundationEx.hpp"
#include <Metal/Metal.hpp>
#include <MetalKit/MetalKit.hpp>
#include <string>
#include <unordered_map>

namespace Ferrum {

  class MetalEngine {
    public:
      MetalEngine(const char* path) ;
      ~MetalEngine();

      void vect_add(const float* a, int lena, const float* b, int lenb, float* c, int lenc);

    private:
      MTL::Device* device;
      MTL::Library* library;
      MTL::CommandQueue* commandQueue;
      MTL::Function** function;
      // for now, keep track of the function pipeline states in a map
      MTL::Function** kernelFunctions;
      std::unordered_map<std::string, MTL::ComputePipelineState*>* computePipelineStates;
  };

}

#endif // METAL_COMPUTE_HPP

