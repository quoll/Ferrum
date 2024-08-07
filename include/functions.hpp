#pragma once

#ifndef _FUNCTIONS_H
#define _FUNCTIONS_H

enum Function {
  ge_abs = 0,
  ge_acos = 1,
  ge_acosh = 2,
  ge_add = 3,
  ge_asin = 4,
  ge_asinh = 5,
  ge_atan = 6,
  ge_atan2 = 7,
  ge_atanh = 8,
  ge_cbrt = 9,
  ge_cdf_norm = 10,
  ge_cdf_norm_inv = 11,
  ge_ceil = 12,
  ge_copysign = 13,
  ge_cos = 14,
  ge_cosh = 15,
  ge_div = 16,
  ge_elu = 17,
  ge_erf = 18,
  ge_erf_inv = 19,
  ge_erfc = 20,
  ge_erfcinv = 21,
  ge_exp = 22,
  ge_exp10 = 23,
  ge_exp2 = 24,
  ge_expm1 = 25,
  ge_floor = 26,
  ge_fmax = 27,
  ge_fmin = 28,
  ge_fmod = 29,
  ge_frac = 30,
  ge_frem = 31,
  ge_gamma = 32,
  ge_hypot = 33,
  ge_inv = 34,
  ge_inv_cbrt = 35,
  ge_inv_sqrt = 36,
  ge_lgamma = 37,
  ge_linear_frac = 38,
  ge_log = 39,
  ge_log10 = 40,
  ge_log1p = 41,
  ge_log2 = 42,
  ge_modf = 43,
  ge_mul = 44,
  ge_pow = 45,
  ge_pow2o3 = 46,
  ge_pow3o2 = 47,
  ge_powx = 48,
  ge_ramp = 49,
  ge_relu = 50,
  ge_round = 51,
  ge_scale_shift = 52,
  ge_sigmoid = 53,
  ge_sin = 54,
  ge_sincos = 55,
  ge_sinh = 56,
  ge_sqr = 57,
  ge_sqrt = 58,
  ge_sub = 59,
  ge_tan = 60,
  ge_tanh = 61,
  ge_trunc = 62,
  uplo_abs = 63,
  uplo_acos = 64,
  uplo_acosh = 65,
  uplo_add = 66,
  uplo_asin = 67,
  uplo_asinh = 68,
  uplo_atan = 69,
  uplo_atan2 = 70,
  uplo_atanh = 71,
  uplo_cbrt = 72,
  uplo_cdf_norm = 73,
  uplo_cdf_norm_inv = 74,
  uplo_ceil = 75,
  uplo_copysign = 76,
  uplo_cos = 77,
  uplo_cosh = 78,
  uplo_div = 79,
  uplo_elu = 80,
  uplo_erf = 81,
  uplo_erf_inv = 82,
  uplo_erfc = 83,
  uplo_erfc_inv = 84,
  uplo_exp = 85,
  uplo_exp10 = 86,
  uplo_exp2 = 87,
  uplo_expm1 = 88,
  uplo_floor = 89,
  uplo_fmax = 90,
  uplo_fmin = 91,
  uplo_fmod = 92,
  uplo_frac = 93,
  uplo_frem = 94,
  uplo_gamma = 95,
  uplo_hypot = 96,
  uplo_inv = 97,
  uplo_inv_cbrt = 98,
  uplo_inv_sqrt = 99,
  uplo_lgamma = 100,
  uplo_linear_frac = 101,
  uplo_log = 102,
  uplo_log10 = 103,
  uplo_log1p = 104,
  uplo_log2 = 105,
  uplo_modf = 106,
  uplo_mul = 107,
  uplo_pow = 108,
  uplo_pow2o3 = 109,
  uplo_pow3o2 = 110,
  uplo_powx = 111,
  uplo_ramp = 112,
  uplo_relu = 113,
  uplo_round = 114,
  uplo_scale_shift = 115,
  uplo_sigmoid = 116,
  uplo_sin = 117,
  uplo_sincos = 118,
  uplo_sinh = 119,
  uplo_sqr = 120,
  uplo_sqrt = 121,
  uplo_sub = 122,
  uplo_tan = 123,
  uplo_tanh = 124,
  uplo_trunc = 125,
  vector_abs = 126,
  vector_acos = 127,
  vector_acosh = 128,
  vector_add = 129,
  vector_asin = 130,
  vector_asinh = 131,
  vector_atan = 132,
  vector_atan2 = 133,
  vector_atanh = 134,
  vector_cbrt = 135,
  vector_cdf_norm = 136,
  vector_cdf_norm_inv = 137,
  vector_ceil = 138,
  vector_copy = 139,
  vector_copysign = 140,
  vector_cos = 141,
  vector_cosh = 142,
  vector_div = 143,
  vector_elu = 144,
  vector_equals = 145,
  vector_erf = 146,
  vector_erf_inv = 147,
  vector_erfc = 148,
  vector_erfc_inv = 149,
  vector_exp = 150,
  vector_exp10 = 151,
  vector_exp2 = 152,
  vector_expm1 = 153,
  vector_floor = 154,
  vector_fmax = 155,
  vector_fmin = 156,
  vector_fmod = 157,
  vector_frac = 158,
  vector_frem = 159,
  vector_gamma = 160,
  vector_hypot = 161,
  vector_inv = 162,
  vector_inv_cbrt = 163,
  vector_inv_sqrt = 164,
  vector_lgamma = 165,
  vector_linear_frac = 166,
  vector_log = 167,
  vector_log10 = 168,
  vector_log1p = 169,
  vector_log2 = 170,
  vector_modf = 171,
  vector_mul = 172,
  vector_pow = 173,
  vector_pow2o3 = 174,
  vector_pow3o2 = 175,
  vector_powx = 176,
  vector_ramp = 177,
  vector_relu = 178,
  vector_round = 179,
  vector_scale_shift = 180,
  vector_set = 181,
  vector_sigmoid = 182,
  vector_sin = 183,
  vector_sincos = 184,
  vector_sinh = 185,
  vector_sqr = 186,
  vector_sqrt = 187,
  vector_sub = 188,
  vector_swap = 189,
  vector_tan = 190,
  vector_tanh = 191,
  vector_trunc = 192
};

#endif _FUNCTIONS_H