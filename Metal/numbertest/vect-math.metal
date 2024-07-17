#include <metal_stdlib>
using namespace metal;

#ifndef REAL
#define REAL float
#endif

#ifndef REAL2o3
#define REAL2o3 (REAL)0.6666666666666667
#endif

#ifndef REAL3o2
#define REAL3o2 (REAL)1.5
#endif

#ifndef REAL1o2
#define REAL1o2 (REAL)0.5
#endif

kernel void vector_sqr (const device REAL* x, uint offset_x, uint stride_x,
                        device REAL* y, uint offset_y, uint stride_y,
                        uint gid [[thread_position_in_grid]]) {
    REAL xval = x[offset_x + gid * stride_x];
    y[offset_y + gid * stride_y] = xval * xval;
}

kernel void vector_mul (const device REAL* x, uint offset_x, uint stride_x,
                        const device REAL* y, uint offset_y, uint stride_y,
                        device REAL* z, uint offset_z, uint stride_z,
                        uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = x[offset_x + id * stride_x] * y[offset_y + id * stride_y];
}


kernel void vector_div (const device REAL* x, uint offset_x, uint stride_x,
                        const device REAL* y, uint offset_y, uint stride_y,
                        device REAL* z, uint offset_z, uint stride_z,
                        uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = x[offset_x + id * stride_x] / y[offset_y + id * stride_y];
}


kernel void vector_inv (const device REAL* x, uint offset_x, uint stride_x,
                        device REAL* y, uint offset_y, uint stride_y,
                        uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = (REAL)1.0 / x[offset_x + id * stride_x];
}


kernel void vector_abs (const device REAL* x, uint offset_x, uint stride_x,
                        device REAL* y, uint offset_y, uint stride_y,
                        uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = abs(x[offset_x + id * stride_x]);
}


kernel void vector_linear_frac (const device REAL* x, uint offset_x, uint stride_x,
                                const device REAL* y, uint offset_y, uint stride_y,
                                REAL scalea, REAL shifta,
                                REAL scaleb, REAL shiftb,
                                device REAL* z, uint offset_z, uint stride_z,
                                uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] =
        (scalea * x[offset_x + id * stride_x] + shifta) /
        (scaleb * y[offset_y + id * stride_y] + shiftb);
}


// NB: scaleb and shiftb are not used
kernel void vector_scale_shift (const device REAL* x, uint offset_x, uint stride_x,
                                REAL scalea, REAL shifta,
                                REAL scaleb, REAL shiftb,
                                REAL* y, uint offset_y, uint stride_y,
                                uint id [[thread_position_in_grid]]) {
  y[offset_y + id * stride_y] = scalea * x[offset_x + id * stride_x] + shifta;
}


kernel void vector_fmod (const device REAL* x, uint offset_x, uint stride_x,
                         const device REAL* y, uint offset_y, uint stride_y,
                         device REAL* z, uint offset_z, uint stride_z,
                         uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = fmod(x[offset_x + id * stride_x], y[offset_y + id * stride_y]);
}


kernel void vector_frem (const device REAL* x, uint offset_x, uint stride_x,
                         const device REAL* y, uint offset_y, uint stride_y,
                         device REAL* z, uint offset_z, uint stride_z,
                         uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = remainder(x[offset_x + id * stride_x], y[offset_y + id * stride_y]);
}


kernel void vector_sqrt (const device REAL* x, uint offset_x, uint stride_x,
                         device REAL* y, uint offset_y, uint stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = sqrt(x[offset_x + id * stride_x]);
}


kernel void vector_inv_sqrt (const device REAL* x, uint offset_x, uint stride_x,
                             device REAL* y, uint offset_y, uint stride_y,
                             uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = rsqrt(x[offset_x + id * stride_x]);
}


kernel void vector_cbrt (const device REAL* x, uint offset_x, uint stride_x,
                         device REAL* y, uint offset_y, uint stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = cbrt(x[offset_x + id * stride_x]);
}


kernel void vector_inv_cbrt (const device REAL* x, uint offset_x, uint stride_x,
                             device REAL* y, uint offset_y, uint stride_y,
                             uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = (REAL)1.0 / cbrt(x[offset_x + id * stride_x]);
}


kernel void vector_pow2o3 (const device REAL* x, uint offset_x, uint stride_x,
                           device REAL* y, uint offset_y, uint stride_y,
                           uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = pow(x[offset_x + id * stride_x], REAL2o3);
}


kernel void vector_pow3o2 (const device REAL* x, uint offset_x, uint stride_x,
                           device REAL* y, uint offset_y, uint stride_y,
                           uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = pow(x[offset_x + id * stride_x], REAL3o2);
}


kernel void vector_pow (const device REAL* x, uint offset_x, uint stride_x,
                        const device REAL* y, uint offset_y, uint stride_y,
                        device REAL* z, uint offset_z, uint stride_z,
                        uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = pow(x[offset_x + id * stride_x], y[offset_y + id * stride_y]);
}


kernel void vector_powx (const device REAL* x, uint offset_x, uint stride_x,
                         REAL b,
                         device REAL* y, uint offset_y, uint stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = pow(x[offset_x + id * stride_x], b);
}


kernel void vector_hypot (const device REAL* x, uint offset_x, uint stride_x,
                          const device REAL* y, uint offset_y, uint stride_y,
                          device REAL* z, uint offset_z, uint stride_z,
                          uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = hypot(x[offset_x + id * stride_x], y[offset_y + id * stride_y]);
}


kernel void vector_exp (const device REAL* x, uint offset_x, uint stride_x,
                        device REAL* y, uint offset_y, uint stride_y,
                        uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = exp(x[offset_x + id * stride_x]);
}


kernel void vector_exp2 (const device REAL* x, uint offset_x, uint stride_x,
                         device REAL* y, uint offset_y, uint stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = exp2(x[offset_x + id * stride_x]);
}


kernel void vector_exp10 (const device REAL* x, uint offset_x, uint stride_x,
                          device REAL* y, uint offset_y, uint stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = exp10(x[offset_x + id * stride_x]);
}


kernel void vector_expm1 (const device REAL* x, uint offset_x, uint stride_x,
                          device REAL* y, uint offset_y, uint stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = expm1(x[offset_x + id * stride_x]);
}


kernel void vector_log (const device REAL* x, uint offset_x, uint stride_x,
                        device REAL* y, uint offset_y, uint stride_y,
                        uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = log(x[offset_x + id * stride_x]);
}


kernel void vector_log2 (const device REAL* x, uint offset_x, uint stride_x,
                         device REAL* y, uint offset_y, uint stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = log2(x[offset_x + id * stride_x]);
}


kernel void vector_log10 (const device REAL* x, uint offset_x, uint stride_x,
                          device REAL* y, uint offset_y, uint stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = log10(x[offset_x + id * stride_x]);
}


kernel void vector_log1p (const device REAL* x, uint offset_x, uint stride_x,
                          device REAL* y, uint offset_y, uint stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = log1p(x[offset_x + id * stride_x]);
}


kernel void vector_sin (const device REAL* x, uint offset_x, uint stride_x,
                        device REAL* y, uint offset_y, uint stride_y,
                        uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = sin(x[offset_x + id * stride_x]);
}


kernel void vector_cos (const device REAL* x, uint offset_x, uint stride_x,
                        device REAL* y, uint offset_y, uint stride_y,
                        uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = cos(x[offset_x + id * stride_x]);
}


kernel void vector_tan (const device REAL* x, uint offset_x, uint stride_x,
                        device REAL* y, uint offset_y, uint stride_y,
                        uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = tan(x[offset_x + id * stride_x]);
}


kernel void vector_sincos (const device REAL* x, uint offset_x, uint stride_x,
                           device REAL* y, uint offset_y, uint stride_y,
                           device REAL* z, uint offset_z, uint stride_z,
                           uint id [[thread_position_in_grid]]) {
    xval = x[offset_x + id * stride_x];
    y[offset_y + id * stride_y] = sin(xval);
    z[offset_z + id * stride_z] = cos(xval);
}


kernel void vector_asin (const device REAL* x, uint offset_x, uint stride_x,
                         device REAL* y, uint offset_y, uint stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = asin(x[offset_x + id * stride_x]);
}


kernel void vector_acos (const device REAL* x, uint offset_x, uint stride_x,
                         device REAL* y, uint offset_y, uint stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = acos(x[offset_x + id * stride_x]);
}


kernel void vector_atan (const device REAL* x, uint offset_x, uint stride_x,
                         device REAL* y, uint offset_y, uint stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = atan(x[offset_x + id * stride_x]);
}


kernel void vector_atan2 (const device REAL* x, uint offset_x, uint stride_x,
                          const device REAL* y, uint offset_y, uint stride_y,
                          device REAL* z, uint offset_z, uint stride_z,
                          uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = atan2(x[offset_x + id * stride_x], y[offset_y + id * stride_y]);
}


kernel void vector_sinh (const device REAL* x, uint offset_x, uint stride_x,
                         device REAL* y, uint offset_y, uint stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = sinh(x[offset_x + id * stride_x]);
}


kernel void vector_cosh (const device REAL* x, uint offset_x, uint stride_x,
                         device REAL* y, uint offset_y, uint stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = cosh(x[offset_x + id * stride_x]);
}


kernel void vector_tanh (const device REAL* x, uint offset_x, uint stride_x,
                         device REAL* y, uint offset_y, uint stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = tanh(x[offset_x + id * stride_x]);
}


kernel void vector_asinh (const device REAL* x, uint offset_x, uint stride_x,
                          device REAL* y, uint offset_y, uint stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = asinh(x[offset_x + id * stride_x]);
}


kernel void vector_acosh (const device REAL* x, uint offset_x, uint stride_x,
                          device REAL* y, uint offset_y, uint stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = acosh(x[offset_x + id * stride_x]);
}


kernel void vector_atanh (const device REAL* x, uint offset_x, uint stride_x,
                          device REAL* y, uint offset_y, uint stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = atanh(x[offset_x + id * stride_x]);
}


kernel void vector_erf (const device REAL* x, uint offset_x, uint stride_x,
                        device REAL* y, uint offset_y, uint stride_y,
                        uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = erf(x[offset_x + id * stride_x]);
}

// Approximation of the inverse error function: W. J. Cody, et al.,
// Mathematics of Computation, v30.No.136, Oct 1976 pp. 827-830
// https://doi.org/10.2307/2005402

constant REAL ei_a1 = (REAL)-0.0705230784;
constant REAL ei_a2 = (REAL)0.0422820123;
constant REAL ei_a3 = (REAL)-0.0092705272;
constant REAL ei_a4 = (REAL)0.0001520143;
constant REAL ei_a5 = (REAL)-0.0002765672;
constant REAL ei_a6 = (REAL)0.0000430638;

kernel void vector_erf_inv (const device REAL* x, uint offset_x, uint stride_x,
                            device REAL* y, uint offset_y, uint stride_y,
                            uint id [[thread_position_in_grid]]) {
    REAL xval = x[offset_x + id * stride_x];
    REAL w = log((REAL)1.0 - xval * xval);
    REAL p = sqrt(w * (ei_a1 + w * (ei_a2 + w * (ei_a3 + w * (ei_a4 + w * (ei_a5 + w * ei_a6))))));
    y[offset_y + id * stride_y] = (xval < (REAL)0.0) ? -p : p;
}


kernel void vector_erfc (const device REAL* x, uint offset_x, uint stride_x,
                         device REAL* y, uint offset_y, uint stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = erfc(x[offset_x + id * stride_x]);
}

constant REAL eci_a1 = (REAL)-0.140543331;
constant REAL eci_a2 = (REAL)0.914624893;
constant REAL eci_a3 = (REAL)-1.645349621;
constant REAL eci_a4 = (REAL)0.886226899;
constant REAL eci_b1 = (REAL)-0.012200287;
constant REAL eci_b2 = (REAL)-0.174030709;
constant REAL eci_b3 = (REAL)0.325598322;
constant REAL eci_b4 = (REAL)0.892459516;
constant REAL eci_c0 = (REAL)0.0;
constant REAL eci_c1 = (REAL)0.564189583;
constant REAL eci_c2 = (REAL)1.211056027;
constant REAL eci_c3 = (REAL)1.050750072;
constant REAL eci_c4 = (REAL)0.285070173;
constant REAL eci_d1 = (REAL)1.011728051;
constant REAL eci_d2 = (REAL)1.732339080;
constant REAL eci_d3 = (REAL)0.753168411;
constant REAL eci_d4 = (REAL)0.081188386;


kernel void vector_erfc_inv (const device REAL* x, uint offset_x, uint stride_x,
                             device REAL* y, uint offset_y, uint stride_y,
                             uint id [[thread_position_in_grid]]) {
    REAL xval = x[offset_x + id * stride_x];
    REAL yval, z;
    if (xval <= 0.0) {
        yval = INFINITY;
    } else if (xval >= 2.0) {
        yval = -INFINITY;
    } else if (xval > 1.0) {
        z = sqrt(-log((2.0 - xval) / 2.0));
        yval = (((((eci_c4 * z + eci_c3) * z + eci_c2) * z + eci_c1) * z + eci_c0) /
                ((((eci_d4 * z + eci_d3) * z + eci_d2) * z + eci_d1) * z + 1.0));
    } else {
        z = sqrt(-log(xval / 2.0));
        yval = -(((((eci_a4 * z + eci_a3) * z + eci_a2) * z + eci_a1) * z + 0.0) /
                 ((((eci_b4 * z + eci_b3) * z + eci_b2) * z + eci_b1) * z + 1.0));
    }
    y[offset_y + id * stride_y] = yval;
}

constant REAL cn_a1 = (REAL)0.254829592;
constant REAL cn_a2 = (REAL)-0.284496736;
constant REAL cn_a3 = (REAL)1.421413741;
constant REAL cn_a4 = (REAL)-1.453152027;
constant REAL cn_a5 = (REAL)1.061405429;
constant REAL cn_p  = (REAL)0.3275911;

kernel void vector_vector_cdf_norm (const device REAL* x, uint offset_x, uint stride_x,
                                    device REAL* y, uint offset_y, uint stride_y,
                                    uint id [[thread_position_in_grid]]) {
    REAL xval = x[offset_x + id * stride_x];
    REAL sgn = (xval < 0.0) ? (REAL)-1.0 : (REAL)1.0;
    xval = abs(xval) / sqrt((REAL)2.0);

    // A&S formula 7.1.26 approximation
    REAL t = (REAL)1.0 / ((REAL)1.0 + cn_p * xval);
    REAL yval = (((((cn_a5 * t + cn_a4) * t) + cn_a3) * t + cn_a2) * t + cn_a1) * t;
    y[offset_y + id * stride_y] = REAL1o2 * ((REAL)1.0 + sgn * ((REAL)1.0 - exp(-xval * xval - yval)));
}


// Approximation of the inverse normal CDF: Peter John Acklam, 2002
// https://web.archive.org/web/20151030215612/http://home.online.no/~pjacklam/notes/invnorm/

constant REAL cni_a1 = (REAL)-3.969683028665376e+01;
constant REAL cni_a2 = (REAL)2.209460984245205e+02;
constant REAL cni_a3 = (REAL)-2.759285104469687e+02;
constant REAL cni_a4 = (REAL)1.383577518672690e+02;
constant REAL cni_a5 = (REAL)-3.066479806614716e+01;
constant REAL cni_a6 = (REAL)2.506628277459239e+00;

constant REAL cni_b1 = (REAL)-5.447609879822406e+01;
constant REAL cni_b2 = (REAL)1.615858368580409e+02;
constant REAL cni_b3 = (REAL)-1.556989798598866e+02;
constant REAL cni_b4 = (REAL)6.680131188771972e+01;
constant REAL cni_b5 = (REAL)-1.328068155288572e+01;

constant REAL cni_c1 = (REAL)-7.784894002430293e-03;
constant REAL cni_c2 = (REAL)-3.223964580411365e-01;
constant REAL cni_c3 = (REAL)-2.400758277161838e+00;
constant REAL cni_c4 = (REAL)-2.549732539343734e+00;
constant REAL cni_c5 = (REAL)4.374664141464968e+00;
constant REAL cni_c6 = (REAL)2.938163982698783e+00;

constant REAL cni_d1 = (REAL)7.784695709041462e-03;
constant REAL cni_d2 = (REAL)3.224671290700398e-01;
constant REAL cni_d3 = (REAL)2.445134137142996e+00;
constant REAL cni_d4 = (REAL)3.754408661907416e+00;

kernel void vector_cdf_norm_inv (const device REAL* x, uint offset_x, uint stride_x,
                                 device REAL* y, uint offset_y, uint stride_y,
                                 uint id [[thread_position_in_grid]]) {
    REAL xval = x[offset_x + id * stride_x];
    constant REAL x_low = (REAL)0.02425;
    constant REAL x_high = (REAL)1.0 - x_low;

    // A&S formula 26.2.23 approximation
    REAL q, r;
    if (xval < x_low) {
      q = sqrt(-2.0 * log(xval));
      y[offset_y + id * stride_y] = (((((cni_c1 * q + cni_c2) * q + cni_c3) * q + cni_c4) * q + cni_c5) * q + cni_c6) /
                                    ((((cni_d1 * q + cni_d2) * q + cni_d3) * q + cni_d4) * q + 1.0);
    } else if (xval <= x_high) {
      q = xval - 0.5;
      r = q * q;
      y[offset_y + id * stride_y] = (((((cni_a1 * r + cni_a2) * r + cni_a3) * r + cni_a4) * r + cni_a5) * r + cni_a6) * q /
                                    (((((cni_b1 * r + cni_b2) * r + cni_b3) * r + cni_b4) * r + cni_b5) * r + 1.0);
    } else {
      q = sqrt(-2.0 * log(1.0 - xval));
      y[offset_y + id * stride_y] = -(((((cni_c1 * q + cni_c2) * q + cni_c3) * q + cni_c4) * q + cni_c5) * q + cni_c6) /
                                    ((((cni_d1 * q + cni_d2) * q + cni_d3) * q + cni_d4) * q + 1.0);
    }
}


kernel void vector_gamma (const device REAL* x, uint offset_x, uint stride_x,
                         device REAL* y, uint offset_y, uint stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = tgamma(x[offset_x + id * stride_x]);
}


kernel void vector_lgamma (const device REAL* x, uint offset_x, uint stride_x,
                          device REAL* y, uint offset_y, uint stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = lgamma(x[offset_x + id * stride_x]);
}


kernel void vector_floor (const device REAL* x, uint offset_x, uint stride_x,
                          device REAL* y, uint offset_y, uint stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = floor(x[offset_x + id * stride_x]);
}


kernel void vector_ceil (const device REAL* x, uint offset_x, uint stride_x,
                         device REAL* y, uint offset_y, uint stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = ceil(x[offset_x + id * stride_x]);
}


kernel void vector_trunc (const device REAL* x, uint offset_x, uint stride_x,
                          device REAL* y, uint offset_y, uint stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = trunc(x[offset_x + id * stride_x]);
}


kernel void vector_round (const device REAL* x, uint offset_x, uint stride_x,
                          device REAL* y, uint offset_y, uint stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = (REAL)lrint(x[offset_x + id * stride_x]);
}


kernel void vector_modf (const device REAL* x, uint offset_x, uint stride_x,
                         const device REAL* y, uint offset_y, uint stride_y,
                         device REAL* z, uint offset_z, uint stride_z,
                         uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = modf(x[offset_x + id * stride_x], &y[offset_y + id * stride_y]);
}


kernel void vector_frac (const device REAL* x, uint offset_x, uint stride_x,
                         device REAL* y, uint offset_y, uint stride_y,
                         uint id [[thread_position_in_grid]]) {
    REAL dummy;
    y[offset_y + id * stride_y] = modf(x[offset_x + id * stride_x], &dummy);
}


kernel void vector_fmax (const device REAL* x, uint offset_x, uint stride_x,
                         const device REAL* y, uint offset_y, uint stride_y,
                         device REAL* z, uint offset_z, uint stride_z,
                         uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = fmax(x[offset_x + id * stride_x], y[offset_y + id * stride_y]);
}


kernel void vector_fmin (const device REAL* x, uint offset_x, uint stride_x,
                         const device REAL* y, uint offset_y, uint stride_y,
                         device REAL* z, uint offset_z, uint stride_z,
                         uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = fmin(x[offset_x + id * stride_x], y[offset_y + id * stride_y]);
}


kernel void vector_copysign (const device REAL* x, uint offset_x, uint stride_x,
                             const device REAL* y, uint offset_y, uint stride_y,
                             device REAL* z, uint offset_z, uint stride_z,
                             uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = copysign(x[offset_x + id * stride_x], y[offset_y + id * stride_y]);
}


kernel void vector_sigmoid (const device REAL* x, uint offset_x, uint stride_x,
                            device REAL* y, uint offset_y, uint stride_y,
                            uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = tanh(REAL1o2 * x[offset_x + id * stride_x]) * REAL1o2 + REAL1o2;
}


kernel void vector_ramp (const device REAL* x, uint offset_x, uint stride_x,
                         device REAL* y, uint offset_y, uint stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = fmax(x[offset_x + id * stride_x], (REAL)0.0);
}


kernel void vector_relu (const REAL alpha,
                         const device REAL* x, uint offset_x, uint stride_x,
                         device REAL* y, uint offset_y, uint stride_y,
                         uint id [[thread_position_in_grid]]) {
    REAL xval = x[offset_x + id * stride_x];
    y[offset_y + id * stride_y] = fmax(xval, alpha * xval);
}


kernel void vector_elu (const REAL alpha,
                        const device REAL* x, uint offset_x, uint stride_x,
                        device REAL* y, uint offset_y, uint stride_y,
                        uint id [[thread_position_in_grid]]) {
    REAL xval = x[offset_x + id * stride_x];
    y[offset_y + id * stride_y] = fmax(xval, alpha * expm1(xval));
}


kernel void ge_sqr (const uint sd [[constant(0)]], const uint fd [[constant(1)]],
                    const device REAL* a [[buffer(2)]],
                    const int offset_a [[constant(3)]], const int ld_a [[constant(4)]],
                    device REAL* b [[buffer(5)]],
                    const int offset_b [[constant(6)]], const int ld_b [[constant(7)]],
                    uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        REAL aval = a[offset_a + gid_0 + gid_1 * ld_a];
        b[offset_b + gid_0 + gid_1 * ld_b] = aval * aval;
    }
}


kernel void ge_mul (const uint sd [[constant(0)]], const uint fd [[constant(1)]],
                    const device REAL* a [[buffer(2)]],
                    const int offset_a [[constant(3)]], const int ld_a [[constant(4)]],
                    const device REAL* b [[buffer(5)]],
                    const int offset_b [[constant(6)]], const int ld_b [[constant(7)]],
                    device REAL* c [[buffer(8)]],
                    const int offset_c [[constant(9)]], const int ld_c [[constant(10)]],
                    uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        c[offset_c + gid_0 + gid_1 * ld_c] =
            a[offset_a + gid_0 + gid_1 * ld_a] * b[offset_b + gid_0 + gid_1 * ld_b];
    }
}


kernel void ge_div (const uint sd [[constant(0)]], const uint fd [[constant(1)]],
                    const device REAL* a [[buffer(2)]],
                    const int offset_a [[constant(3)]], const int ld_a [[constant(4)]],
                    const device REAL* b [[buffer(5)]],
                    const int offset_b [[constant(6)]], const int ld_b [[constant(7)]],
                    device REAL* c [[buffer(8)]],
                    const int offset_c [[constant(9)]], const int ld_c [[constant(10)]],
                    uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        c[offset_c + gid_0 + gid_1 * ld_c] =
            a[offset_a + gid_0 + gid_1 * ld_a] / b[offset_b + gid_0 + gid_1 * ld_b];
    }
}


//     __global__ void ge_inv (const int sd, const int fd,
//                             const REAL* a, const int offset_a, const int ld_a,
//                             REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = (REAL)1.0 / a[offset_a + gid_0 + gid_1 * ld_a];
//         }
//     }

//     __global__ void ge_abs (const int sd, const int fd,
//                             const REAL* a, const int offset_a, const int ld_a,
//                             REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(fabs)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_linear_frac (const int sd, const int fd,
//                                     const REAL* a, const int offset_a, const int ld_a,
//                                     const REAL* b, const int offset_b, const int ld_b,
//                                     const REAL scalea, const REAL shifta, const REAL scaleb, const REAL shiftb,
//                                     REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 (scalea * a[offset_a + gid_0 + gid_1 * ld_a] + shifta) /
//                 (scaleb * b[offset_b + gid_0 + gid_1 * ld_b] + shiftb);
//         }
//     }

//     __global__ void ge_scale_shift (const int sd, const int fd,
//                                     const REAL* a, const int offset_a, const int ld_a,
//                                     const REAL scalea, const REAL shifta, const REAL scaleb, const REAL shiftb,
//                                     REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             c[offset_c + gid_0 + gid_1 * ld_c] = scalea * a[offset_a + gid_0 + gid_1 * ld_a] + shifta;
//
//         }
//     }

//     __global__ void ge_fmod (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              const REAL* b, const int offset_b, const int ld_b,
//                              REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 CAST(fmod)(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
//         }
//     }

//     __global__ void ge_frem (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              const REAL* b, const int offset_b, const int ld_b,
//                              REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 CAST(remainder)(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
//         }
//     }

//     __global__ void ge_sqrt (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(sqrt)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_inv_sqrt (const int sd, const int fd,
//                                  const REAL* a, const int offset_a, const int ld_a,
//                                  REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(rsqrt)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_cbrt (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(cbrt)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_inv_cbrt (const int sd, const int fd,
//                                  const REAL* a, const int offset_a, const int ld_a,
//                                  REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(rcbrt)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_pow2o3 (const int sd, const int fd,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(pow)(a[offset_a + gid_0 + gid_1 * ld_a], REAL2o3);
//         }
//     }

//     __global__ void ge_pow3o2 (const int sd, const int fd,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(pow)(a[offset_a + gid_0 + gid_1 * ld_a], REAL3o2);
//         }
//     }

//     __global__ void ge_pow (const int sd, const int fd,
//                             const REAL* a, const int offset_a, const int ld_a,
//                             const REAL* b, const int offset_b, const int ld_b,
//                             REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 CAST(pow)(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
//         }
//     }

//     __global__ void ge_powx (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              const REAL b,
//                              REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             c[offset_c + gid_0 + gid_1 * ld_c] = CAST(pow)(a[offset_a + gid_0 + gid_1 * ld_a], b);
//         }
//     }

//     __global__ void ge_hypot (const int sd, const int fd,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               const REAL* b, const int offset_b, const int ld_b,
//                               REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 CAST(hypot)(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
//         }
//     }

//     __global__ void ge_exp (const int sd, const int fd,
//                             const REAL* a, const int offset_a, const int ld_a,
//                             REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(exp)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_exp2 (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(exp2)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_exp10 (const int sd, const int fd,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(exp10)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_expm1 (const int sd, const int fd,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(expm1)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_log (const int sd, const int fd,
//                             const REAL* a, const int offset_a, const int ld_a,
//                             REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(log)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_log2 (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(log2)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_log10 (const int sd, const int fd,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(log10)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_log1p (const int sd, const int fd,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(log1p)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_sin (const int sd, const int fd,
//                             const REAL* a, const int offset_a, const int ld_a,
//                             REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(sin)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_cos (const int sd, const int fd,
//                             const REAL* a, const int offset_a, const int ld_a,
//                             REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(cos)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_tan (const int sd, const int fd,
//                             const REAL* a, const int offset_a, const int ld_a,
//                             REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(tan)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_sincos (const int sd, const int fd,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b,
//                                REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             CAST(sincos)(a[offset_a + gid_0 + gid_1 * ld_a],
//                          &b[offset_b + gid_0 + gid_1 * ld_b], &c[offset_c + gid_0 + gid_1 * ld_c]);
//         }
//     }

//     __global__ void ge_asin (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(asin)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_acos (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(acos)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_atan (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(atan)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_atan2 (const int sd, const int fd,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               const REAL* b, const int offset_b, const int ld_b,
//                               REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 CAST(atan2)(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
//         }
//     }

//     __global__ void ge_sinh (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(sinh)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_cosh (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(cosh)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_tanh (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(tanh)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_asinh (const int sd, const int fd,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(asinh)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_acosh (const int sd, const int fd,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(acosh)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_atanh (const int sd, const int fd,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(atanh)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_erf (const int sd, const int fd,
//                             const REAL* a, const int offset_a, const int ld_a,
//                             REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(erf)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_erf_inv (const int sd, const int fd,
//                                 const REAL* a, const int offset_a, const int ld_a,
//                                 REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(erfinv)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_erfc (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(erfc)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_erfc_inv (const int sd, const int fd,
//                                  const REAL* a, const int offset_a, const int ld_a,
//                                  REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(erfcinv)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_cdf_norm (const int sd, const int fd,
//                                  const REAL* a, const int offset_a, const int ld_a,
//                                  REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(normcdf)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_cdf_norm_inv (const int sd, const int fd,
//                                      const REAL* a, const int offset_a, const int ld_a,
//                                      REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(normcdfinv)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_gamma (const int sd, const int fd,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(tgamma)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_lgamma (const int sd, const int fd,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(lgamma)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_floor (const int sd, const int fd,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(floor)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_ceil (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(ceil)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_trunc (const int sd, const int fd,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(trunc)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_round (const int sd, const int fd,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(round)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void ge_modf (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              REAL* b, const int offset_b, const int ld_b,
//                              REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 CAST(modf)(a[offset_a + gid_0 + gid_1 * ld_a], &b[offset_b + gid_0 + gid_1 * ld_b]);
//         }
//     }

//     __global__ void ge_frac (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             REAL dummy;
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(modf)(a[offset_a + gid_0 + gid_1 * ld_a], &dummy);
//         }
//     }

//     __global__ void ge_fmax (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              const REAL* b, const int offset_b, const int ld_b,
//                              REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 CAST(fmax)(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
//         }
//     }

//     __global__ void ge_fmin (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              const REAL* b, const int offset_b, const int ld_b,
//                              REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 CAST(fmin)(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
//         }
//     }

//     __global__ void ge_copysign (const int sd, const int fd,
//                                  const REAL* a, const int offset_a, const int ld_a,
//                                  const REAL* b, const int offset_b, const int ld_b,
//                                  REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 CAST(copysign)(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
//         }
//     }

//     __global__ void ge_sigmoid (const int sd, const int fd,
//                                 const REAL* a, const int offset_a, const int ld_a,
//                                 REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] =
//                 CAST(tanh)((REAL)0.5 * a[offset_a + gid_0 + gid_1 * ld_a]) * (REAL)0.5 + (REAL)0.5;
//         }
//     }

//     __global__ void ge_ramp (const int sd, const int fd,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(fmax)(a[offset_a + gid_0 + gid_1 * ld_a], (REAL)0.0);
//         }
//     }

//     __global__ void ge_relu (const int sd, const int fd,
//                              const REAL alpha,
//                              const REAL* a, const int offset_a, const int ld_a,
//                              REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             const REAL val = a[offset_a + gid_0 + gid_1 * ld_a];
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(fmax)(val, alpha * val);
//         }
//     }

//     __global__ void ge_elu (const int sd, const int fd,
//                             const REAL alpha,
//                             const REAL* a, const int offset_a, const int ld_a,
//                             REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < fd);
//         if (valid) {
//             const REAL val = a[offset_a + gid_0 + gid_1 * ld_a];
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(fmax)(val, alpha * expm1(val));
//         }
//     }

//     __global__ void uplo_sqr (const int sd, const int unit, const int bottom,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             const REAL aval = a[offset_a + gid_0 + gid_1 * ld_a];
//             b[offset_b + gid_0 + gid_1 * ld_b] = aval * aval;
//         }
//     }

//     __global__ void uplo_mul (const int sd, const int unit, const int bottom,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               const REAL* b, const int offset_b, const int ld_b,
//                               REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 a[offset_a + gid_0 + gid_1 * ld_a] * b[offset_b + gid_0 + gid_1 * ld_b];
//         }
//     }

//     __global__ void uplo_div (const int sd, const int unit, const int bottom,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               const REAL* b, const int offset_b, const int ld_b,
//                               REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 a[offset_a + gid_0 + gid_1 * ld_a] / b[offset_b + gid_0 + gid_1 * ld_b];
//         }
//     }

//     __global__ void uplo_inv (const int sd, const int unit, const int bottom,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = (REAL)1.0 / a[offset_a + gid_0 + gid_1 * ld_a];
//         }
//     }

//     __global__ void uplo_abs (const int sd, const int unit, const int bottom,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(fabs)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_linear_frac (const int sd, const int unit, const int bottom,
//                                       const REAL* a, const int offset_a, const int ld_a,
//                                       const REAL* b, const int offset_b, const int ld_b,
//                                       const REAL scalea, const REAL shifta, const REAL scaleb, const REAL shiftb,
//                                       REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 (scalea * a[offset_a + gid_0 + gid_1 * ld_a] + shifta) /
//                 (scaleb * b[offset_b + gid_0 + gid_1 * ld_b] + shiftb);
//         }
//     }

//     __global__ void uplo_scale_shift (const int sd, const int unit, const int bottom,
//                                       const REAL* a, const int offset_a, const int ld_a,
//                                       const REAL scalea, const REAL shifta, const REAL scaleb, const REAL shiftb,
//                                       REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             c[offset_c + gid_0 + gid_1 * ld_c] = scalea * a[offset_a + gid_0 + gid_1 * ld_a] + shifta;
//         }
//     }

//     __global__ void uplo_fmod (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                const REAL* b, const int offset_b, const int ld_b,
//                                REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 CAST(fmod)(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
//         }
//     }

//     __global__ void uplo_frem (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                const REAL* b, const int offset_b, const int ld_b,
//                                REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 CAST(remainder)(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
//         }
//     }

//     __global__ void uplo_sqrt (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(sqrt)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_inv_sqrt (const int sd, const int unit, const int bottom,
//                                    const REAL* a, const int offset_a, const int ld_a,
//                                    REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(rsqrt)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_cbrt (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(cbrt)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_inv_cbrt (const int sd, const int unit, const int bottom,
//                                    const REAL* a, const int offset_a, const int ld_a,
//                                    REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(rcbrt)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_pow2o3 (const int sd, const int unit, const int bottom,
//                                  const REAL* a, const int offset_a, const int ld_a,
//                                  REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(pow)(a[offset_a + gid_0 + gid_1 * ld_a], REAL2o3);
//         }
//     }

//     __global__ void uplo_pow3o2 (const int sd, const int unit, const int bottom,
//                                  const REAL* a, const int offset_a, const int ld_a,
//                                  REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(pow)(a[offset_a + gid_0 + gid_1 * ld_a], REAL3o2);
//         }
//     }

//     __global__ void uplo_pow (const int sd, const int unit, const int bottom,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               const REAL* b, const int offset_b, const int ld_b,
//                               REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 CAST(pow)(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
//         }
//     }

//     __global__ void uplo_powx (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                const REAL b,
//                                REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             c[offset_c + gid_0 + gid_1 * ld_c] = CAST(pow)(a[offset_a + gid_0 + gid_1 * ld_a], b);
//         }
//     }

//     __global__ void uplo_hypot (const int sd, const int unit, const int bottom,
//                                 const REAL* a, const int offset_a, const int ld_a,
//                                 const REAL* b, const int offset_b, const int ld_b,
//                                 REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 CAST(hypot)(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
//         }
//     }

//     __global__ void uplo_exp (const int sd, const int unit, const int bottom,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(exp)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_exp2 (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(exp2)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_exp10 (const int sd, const int unit, const int bottom,
//                                 const REAL* a, const int offset_a, const int ld_a,
//                                 REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(exp10)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_expm1 (const int sd, const int unit, const int bottom,
//                                 const REAL* a, const int offset_a, const int ld_a,
//                                 REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(expm1)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_log (const int sd, const int unit, const int bottom,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(log)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_log2 (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(log2)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_log10 (const int sd, const int unit, const int bottom,
//                                 const REAL* a, const int offset_a, const int ld_a,
//                                 REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(log10)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_log1p (const int sd, const int unit, const int bottom,
//                                 const REAL* a, const int offset_a, const int ld_a,
//                                 REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(log1p)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_sin (const int sd, const int unit, const int bottom,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(sin)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_cos (const int sd, const int unit, const int bottom,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(cos)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_tan (const int sd, const int unit, const int bottom,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(tan)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_sincos (const int sd, const int unit, const int bottom,
//                                  const REAL* a, const int offset_a, const int ld_a,
//                                  REAL* b, const int offset_b, const int ld_b,
//                                  REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             CAST(sincos)(a[offset_a + gid_0 + gid_1 * ld_a],
//                          &b[offset_b + gid_0 + gid_1 * ld_b], &c[offset_c + gid_0 + gid_1 * ld_c]);
//         }
//     }

//     __global__ void uplo_asin (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(asin)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_acos (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(acos)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_atan (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(atan)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_atan2 (const int sd, const int unit, const int bottom,
//                                 const REAL* a, const int offset_a, const int ld_a,
//                                 const REAL* b, const int offset_b, const int ld_b,
//                                 REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 CAST(atan2)(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
//         }
//     }

//     __global__ void uplo_sinh (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(sinh)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_cosh (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(cosh)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_tanh (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(tanh)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_asinh (const int sd, const int unit, const int bottom,
//                                 const REAL* a, const int offset_a, const int ld_a,
//                                 REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(asinh)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_acosh (const int sd, const int unit, const int bottom,
//                                 const REAL* a, const int offset_a, const int ld_a,
//                                 REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(acosh)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_atanh (const int sd, const int unit, const int bottom,
//                                 const REAL* a, const int offset_a, const int ld_a,
//                                 REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(atanh)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_erf (const int sd, const int unit, const int bottom,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(erf)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_erf_inv (const int sd, const int unit, const int bottom,
//                                   const REAL* a, const int offset_a, const int ld_a,
//                                   REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(erfinv)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_erfc (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(erfc)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_erfc_inv (const int sd, const int unit, const int bottom,
//                                    const REAL* a, const int offset_a, const int ld_a,
//                                    REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(erfcinv)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_cdf_norm (const int sd, const int unit, const int bottom,
//                                    const REAL* a, const int offset_a, const int ld_a,
//                                    REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(normcdf)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_cdf_norm_inv (const int sd, const int unit, const int bottom,
//                                        const REAL* a, const int offset_a, const int ld_a,
//                                        REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(normcdfinv)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_gamma (const int sd, const int unit, const int bottom,
//                                 const REAL* a, const int offset_a, const int ld_a,
//                                 REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(tgamma)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_lgamma (const int sd, const int unit, const int bottom,
//                                  const REAL* a, const int offset_a, const int ld_a,
//                                  REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(lgamma)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_floor (const int sd, const int unit, const int bottom,
//                                 const REAL* a, const int offset_a, const int ld_a,
//                                 REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(floor)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_ceil (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(ceil)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_trunc (const int sd, const int unit, const int bottom,
//                                 const REAL* a, const int offset_a, const int ld_a,
//                                 REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(trunc)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_round (const int sd, const int unit, const int bottom,
//                                 const REAL* a, const int offset_a, const int ld_a,
//                                 REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(round)(a[offset_a + gid_0 + gid_1 * ld_a]);
//         }
//     }

//     __global__ void uplo_modf (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b,
//                                REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 CAST(modf)(a[offset_a + gid_0 + gid_1 * ld_a], &b[offset_b + gid_0 + gid_1 * ld_b]);
//         }
//     }

//     __global__ void uplo_frac (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             REAL dummy;
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(modf)(a[offset_a + gid_0 + gid_1 * ld_a], &dummy);
//         }
//     }

//     __global__ void uplo_fmax (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                const REAL* b, const int offset_b, const int ld_b,
//                                REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 CAST(fmax)(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
//         }
//     }

//     __global__ void uplo_fmin (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                const REAL* b, const int offset_b, const int ld_b,
//                                REAL* c, const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 CAST(fmin)(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
//         }
//     }

//     __global__ void uplo_copysign (const int sd, const int unit, const int bottom,
//                                    const REAL* a, const int offset_a, const int ld_a,
//                                    const REAL* b, const int offset_b, const int ld_b,
//                                    REAL* c
//                                    , const int offset_c, const int ld_c) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             c[offset_c + gid_0 + gid_1 * ld_c] =
//                 CAST(copysign)(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
//         }
//     }

//     __global__ void uplo_sigmoid (const int sd, const int unit, const int bottom,
//                                   const REAL* a, const int offset_a, const int ld_a,
//                                   REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] =
//                 CAST(tanh)((REAL)0.5 * a[offset_a + gid_0 + gid_1 * ld_a]) * (REAL)0.5 + (REAL)0.5;
//         }
//     }

//     __global__ void uplo_ramp (const int sd, const int unit, const int bottom,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(fmax)(a[offset_a + gid_0 + gid_1 * ld_a], (REAL)0.0);
//         }
//     }

//     __global__ void uplo_relu (const int sd, const int unit, const int bottom,
//                                const REAL alpha,
//                                const REAL* a, const int offset_a, const int ld_a,
//                                REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             const REAL val = a[offset_a + gid_0 + gid_1 * ld_a];
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(fmax)(val, alpha * val);
//         }
//     }

//     __global__ void uplo_elu (const int sd, const int unit, const int bottom,
//                               const REAL alpha,
//                               const REAL* a, const int offset_a, const int ld_a,
//                               REAL* b, const int offset_b, const int ld_b) {
//         const int gid_0 = blockIdx.x * blockDim.x + threadIdx.x;
//         const int gid_1 = blockIdx.y * blockDim.y + threadIdx.y;
//         const bool valid = (gid_0 < sd) && (gid_1 < sd);
//         const bool check = valid &&
//             ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1);
//         if (check) {
//             const REAL val = a[offset_a + gid_0 + gid_1 * ld_a];
//             b[offset_b + gid_0 + gid_1 * ld_b] = CAST(fmax)(val, alpha * expm1(val));
//         }
//     }

