#pragma once

#ifndef METAL_COMPUTE_HPP
#define METAL_COMPUTE_HPP

#include <Metal/Metal.hpp>
#include <MetalKit/MetalKit.hpp>
#include <string>
#include <unordered_map>
#include "FoundationEx.hpp"
#include "functions.hpp"

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

    using BufferAction = std::function<void(std::vector<MTL::Buffer*>&, int)>;
    BufferAction emptyAction;

    public:
      MetalEngine(const char* path);
      ~MetalEngine();

      float* vect_add(const float* a, int lena, const float* b, int lenb, float* result, int len);
      // Dispatch functions
      // general vector functions
      float* vect_bB(FunctionID id, const float* a, int lena, int offset_a, int stride_a,
                                    float* result, int len, int offset, int stride);
      float* vect_bfB(FunctionID id, const float* a, int lena, int offset_a, int stride_a,
                                     float sa,
                                     float* result, int len, int offset, int stride);
      float* vect_fbB(FunctionID id, float sa,
                                     const float* a, int lena, int offset_a, int stride_a,
                                     float* result, int len, int offset, int stride);
      float* vect_bbB(FunctionID id, const float* a, int lena, int offset_a, int stride_a,
                                     const float* b, int lenb, int offset_b, int stride_b,
                                     float* result, int len, int offset, int stride);
      float* vect_bBB(FunctionID id, const float* a, int lena, int offset_a, int stride_a,
                                     float* b, int lenb, int offset_b, int stride_b,
                                     float* result, int len, int offset, int stride);
      float* vect_bffffB(FunctionID id, const float* a, int lena, int offset_a, int stride_a,
                                        float sa, float sha,
                                        float sb, float shb,
                                        float* result, int len, int offset, int stride);
      float* vect_bbffffB(FunctionID id, const float* a, int lena, int offset_a, int stride_a,
                                         const float* b, int lenb, int offset_b, int stride_b,
                                         float sa, float sha,
                                         float sb, float shb,
                                         float* result, int len, int offset, int stride);
      // general matrix functions
      float* ge_bB(FunctionID id, int sd, int fd,
                                  const float* a, int lena, int offset_a, int stride_a,
                                  float* result, int len, int offset, int stride);
      float* ge_bfB(FunctionID id, int sd, int fd,
                                   const float* a, int lena, int offset_a, int stride_a,
                                   float sa,
                                   float* result, int len, int offset, int stride);
      float* ge_fbB(FunctionID id, int sd, int fd, float sa,
                                   const float* a, int lena, int offset_a, int stride_a,
                                   float* result, int len, int offset, int stride);
      float* ge_bbB(FunctionID id, int sd, int fd,
                                   const float* a, int lena, int offset_a, int stride_a,
                                   const float* b, int lenb, int offset_b, int stride_b,
                                   float* result, int len, int offset, int stride);
      float* ge_bBB(FunctionID id, int sd, int fd,
                                   const float* a, int lena, int offset_a, int stride_a,
                                   float* b, int lenb, int offset_b, int stride_b,
                                   float* result, int len, int offset, int stride);
      float* ge_bffffB(FunctionID id, int sd, int fd,
                                      const float* a, int lena, int offset_a, int stride_a,
                                      float sa, float sha,
                                      float sb, float shb,
                                      float* result, int len, int offset, int stride);
      float* ge_bbffffB(FunctionID id, int sd, int fd,
                                       const float* a, int lena, int offset_a, int stride_a,
                                       const float* b, int lenb, int offset_b, int stride_b,
                                       float sa, float sha,
                                       float sb, float shb,
                                       float* result, int len, int offset, int stride);
      // general uplo functions
      float* uplo_bB(FunctionID id, int sd, int unit, int bottom,
                                    const float* a, int lena, int offset_a, int stride_a,
                                    float* result, int len, int offset, int stride);
      float* uplo_bfB(FunctionID id, int sd, int unit, int bottom,
                                     const float* a, int lena, int offset_a, int stride_a,
                                     float sa,
                                     float* result, int len, int offset, int stride);
      float* uplo_fbB(FunctionID id, int sd, int fd, float sa,
                                     const float* a, int lena, int offset_a, int stride_a,
                                     float* result, int len, int offset, int stride);
      float* uplo_bbB(FunctionID id, int sd, int unit, int bottom,
                                     const float* a, int lena, int offset_a, int stride_a,
                                     const float* b, int lenb, int offset_b, int stride_b,
                                     float* result, int len, int offset, int stride);
      float* uplo_bBB(FunctionID id, int sd, int unit, int bottom,
                                     const float* a, int lena, int offset_a, int stride_a,
                                     float* b, int lenb, int offset_b, int stride_b,
                                     float* result, int len, int offset, int stride);
      float* uplo_bffffB(FunctionID id, int sd, int unit, int bottom,
                                        const float* a, int lena, int offset_a, int stride_a,
                                        float sa, float sha,
                                        float sb, float shb,
                                        float* result, int len, int offset, int stride);
      float* uplo_bbffffB(FunctionID id, int sd, int unit, int bottom,
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
      MTL::ComputePipelineState** computePipelineStates;

      template<typename CreateBuffers, typename SetBuffers, typename CopyResults>
      float* call_metal(FunctionID id,
                        float* result, int len, int offset, int stride,
                        CreateBuffers createBuffers, SetBuffers setBuffers, CopyResults copyResults);
  };

} // namespace Ferrum

#endif // METAL_COMPUTE_HPP

