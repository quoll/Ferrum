#include <metal_stdlib>
using namespace metal;

kernel void vector_equals (const int n,
                               const NUMBER* x, const int offset_x, const int stride_x,
                               const NUMBER* y, const int offset_y, const int stride_y,
                               int* eq_flag) {

    const int gid = blockIdx.x * blockDim.x + threadIdx.x;
    if (gid < n) {
        const int ix = offset_x + gid * stride_x;
        const int iy = offset_y + gid * stride_y;
        if (x[ix] != y[iy]) {
            eq_flag[0]++;
        }
    }
}

kernel void vector_copy (const int n,
                             const NUMBER* x, const int offset_x, const int stride_x,
                             NUMBER* y, const int offset_y, const int stride_y) {

    const int gid = blockIdx.x * blockDim.x + threadIdx.x;
    if (gid < n) {
        const int ix = offset_x + gid * stride_x;
        const int iy = offset_y + gid * stride_y;
        y[iy] = x[ix];
    }
}

kernel void vector_swap (const int n,
                             NUMBER* x, const int offset_x, const int stride_x,
                             NUMBER* y, const int offset_y, const int stride_y) {

    const int gid = blockIdx.x * blockDim.x + threadIdx.x;
    if (gid < n) {
        const int ix = offset_x + gid * stride_x;
        const int iy = offset_y + gid * stride_y;
        const NUMBER val = y[ix];
        y[iy] = x[ix];
        x[ix] = val;
    }
}

kernel void vector_set (const int n, const NUMBER val,
                            NUMBER* x, const int offset_x, const int stride_x) {
    const int gid = blockIdx.x * blockDim.x + threadIdx.x;
    if (gid < n) {
        x[offset_x + gid * stride_x] = val;
    }
}

