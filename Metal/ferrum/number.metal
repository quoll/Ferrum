#include <metal_stdlib>
using namespace metal;

#ifndef REAL
#define REAL float
#endif

kernel void vector_equals (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                           const device REAL* y, constant uint& offset_y, constant uint& stride_y,
                           device int& eq_flag,
                           uint id [[thread_position_in_grid]]) {

    if (x[offset_x + id * stride_x] != y[offset_y + id * stride_y]) {
        eq_flag++;
    }
}

kernel void vector_copy (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         uint id [[thread_position_in_grid]]) {

    y[offset_y + id * stride_y] = x[offset_x + id * stride_x];
}

kernel void vector_swap (device REAL* x, constant uint& offset_x, constant int& stride_x,
                         device REAL* y, constant uint& offset_y, constant int& stride_y,
                         uint id [[thread_position_in_grid]]) {

    const int ix = offset_x + id * stride_x;
    const int iy = offset_y + id * stride_y;
    const REAL val = y[ix];
    y[iy] = x[ix];
    x[ix] = val;
}

kernel void vector_set (constant REAL& val,
                        device REAL* x, constant uint& offset_x, constant uint& stride_x,
                        uint id [[thread_position_in_grid]]) {
    x[offset_x + id * stride_x] = val;
}

