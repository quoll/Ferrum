#pragma once

#ifndef METAL_COMPUTE_HPP
#define METAL_COMPUTE_HPP

#include "FoundationEx.hpp"
#include <Metal/Metal.hpp>
#include <MetalKit/MetalKit.hpp>
#include <string>
#include <unordered_map>

#ifdef DEBUG
#define DBG1(arg1) std::cout << (arg1) << std::endl
#define DBG2(arg1, arg2) std::cout << (arg1) << (arg2) << std::endl
#define DBG3(arg1, arg2, arg3) std::cout << (arg1) << (arg2) << (arg3) << std::endl
#define MACRO_DISPATCH(arg1, arg2, arg3, func, ...) func
#define DBG(...) MACRO_DISPATCH(__VA_ARGS__, DBG3, DBG2, DBG1)(__VA_ARGS__)
#else
#define DBG(...)
#endif

namespace Ferrum {

  class MetalEngine {
    public:
      MetalEngine(const char* path) ;
      ~MetalEngine();

      float* vect_add(const float* a, int lena, const float* b, int lenb, float* result, int len);
      // general vector functions
      float* vect_bB(uint id, const float* a, int lena, int offset_a, int stride_a,
                              float* result, int len, int offset, int stride);
      float* vect_bfB(uint id, const float* a, int lena, int offset_a, int stride_a,
                               float sa,
                               float* result, int len, int offset, int stride);
      float* vect_fbB(uint id, float sa,
                               const float* a, int lena, int offset_a, int stride_a,
                               float* result, int len, int offset, int stride);
      float* vect_bbB(uint id, const float* a, int lena, int offset_a, int stride_a,
                               const float* b, int lenb, int offset_b, int stride_b,
                               float* result, int len, int offset, int stride);
      float* vect_bBB(uint id, const float* a, int lena, int offset_a, int stride_a,
                               float* b, int lenb, int offset_b, int stride_b,
                               float* result, int len, int offset, int stride);
      float* vect_bffffB(uint id, const float* a, int lena, int offset_a, int stride_a,
                                  float sa, float sha,
                                  float sb, float shb,
                                  float* result, int len, int offset, int stride);
      float* vect_bbffffB(uint id, const float* a, int lena, int offset_a, int stride_a,
                                   const float* b, int lenb, int offset_b, int stride_b,
                                   float sa, float sha,
                                   float sb, float shb,
                                   float* result, int len, int offset, int stride);
      // general matrix functions
      float* ge_bB(uint id, int sd, int fd,
                            const float* a, int lena, int offset_a, int stride_a,
                            float* result, int len, int offset, int stride);
      float* ge_bfB(uint id, int sd, int fd,
                             const float* a, int lena, int offset_a, int stride_a,
                             float sa,
                             float* result, int len, int offset, int stride);
      float* ge_fbB(uint id, int sd, int fd, float sa,
                             const float* a, int lena, int offset_a, int stride_a,
                             float* result, int len, int offset, int stride);
      float* ge_bbB(uint id, int sd, int fd,
                             const float* a, int lena, int offset_a, int stride_a,
                             const float* b, int lenb, int offset_b, int stride_b,
                             float* result, int len, int offset, int stride);
      float* ge_bBB(uint id, int sd, int fd,
                             const float* a, int lena, int offset_a, int stride_a,
                             float* b, int lenb, int offset_b, int stride_b,
                             float* result, int len, int offset, int stride);
      float* ge_bffffB(uint id, int sd, int fd,
                                const float* a, int lena, int offset_a, int stride_a,
                                float sa, float sha,
                                float sb, float shb,
                                float* result, int len, int offset, int stride);
      float* ge_bbffffB(uint id, int sd, int fd,
                                 const float* a, int lena, int offset_a, int stride_a,
                                 const float* b, int lenb, int offset_b, int stride_b,
                                 float sa, float sha,
                                 float sb, float shb,
                                 float* result, int len, int offset, int stride);
      // general uplo functions
      float* uplo_bB(uint id, int sd, int unit, int bottom,
                              const float* a, int lena, int offset_a, int stride_a,
                              float* result, int len, int offset, int stride);
      float* uplo_bfB(uint id, int sd, int unit, int bottom,
                               const float* a, int lena, int offset_a, int stride_a,
                               float sa,
                               float* result, int len, int offset, int stride);
      float* uplo_fbB(uint id, int sd, int fd, float sa,
                               const float* a, int lena, int offset_a, int stride_a,
                               float* result, int len, int offset, int stride);
      float* uplo_bbB(uint id, int sd, int unit, int bottom,
                               const float* a, int lena, int offset_a, int stride_a,
                               const float* b, int lenb, int offset_b, int stride_b,
                               float* result, int len, int offset, int stride);
      float* uplo_bBB(uint id, int sd, int unit, int bottom,
                               const float* a, int lena, int offset_a, int stride_a,
                               float* b, int lenb, int offset_b, int stride_b,
                               float* result, int len, int offset, int stride);
      float* uplo_bffffB(uint id, int sd, int unit, int bottom,
                                  const float* a, int lena, int offset_a, int stride_a,
                                  float sa, float sha,
                                  float sb, float shb,
                                  float* result, int len, int offset, int stride);
      float* uplo_bbffffB(uint id, int sd, int unit, int bottom,
                                   const float* a, int lena, int offset_a, int stride_a,
                                   const float* b, int lenb, int offset_b, int stride_b,
                                   float sa, float sha,
                                   float sb, float shb,
                                   float* result, int len, int offset, int stride);

    private:
      MTL::Device* device;
      MTL::Library* library;
      MTL::CommandQueue* commandQueue;
      MTL::Function** function;
      // for now, keep track of the function pipeline states in a map
      int fnCount;
      MTL::Function** kernelFunctions;
      std::unordered_map<std::string, MTL::ComputePipelineState*>* computePipelineStates;
  };

}

#endif // METAL_COMPUTE_HPP

