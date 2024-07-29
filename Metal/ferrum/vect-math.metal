#include <metal_stdlib>
using namespace metal;

#ifndef REAL
#define REAL float
#endif

#ifndef REAL1o3
#define REAL1o3 (REAL)0.3333333333333333
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

constant REAL M_PI = (REAL)3.1415926535897932384626;

// Approximation of the error function: W. J. Cody, et al.,
// Mathematics of Computation, v23, Oct 1969 pp. 631-638

constant REAL ERF_A1 = (REAL)0.254829592;
constant REAL ERF_A2 = (REAL)-0.284496736;
constant REAL ERF_A3 = (REAL)1.421413741;
constant REAL ERF_A4 = (REAL)-1.453152027;
constant REAL ERF_A5 = (REAL)1.061405429;
constant REAL ERF_P  = (REAL)0.3275911;

inline REAL erf(REAL x) {
    REAL sgn = (x < 0.0) ? (REAL)-1.0 : (REAL)1.0;
    x = fabs(x);

    // A&S formula 7.1.26 approximation
    REAL t = (REAL)1.0 / ((REAL)1.0 + ERF_P * x);
    REAL y = (((((ERF_A5 * t + ERF_A4) * t) + ERF_A3) * t + ERF_A2) * t + ERF_A1) * t;
    return sgn * (1.0 - exp(-x * x - y));
}

inline REAL erfc(REAL x) {
    return (REAL)1.0 - erf(x);
}

// Approximation of the inverse error function: J. M. Blair, et al.,
// Mathematics of Computation, v30, Oct 1976 pp. 827-830
// https://doi.org/10.2307/2005402

constant REAL EI_A1 = (REAL)-0.0705230784;
constant REAL EI_A2 = (REAL)0.0422820123;
constant REAL EI_A3 = (REAL)-0.0092705272;
constant REAL EI_A4 = (REAL)0.0001520143;
constant REAL EI_A5 = (REAL)-0.0002765672;
constant REAL EI_A6 = (REAL)0.0000430638;

inline REAL erfinv(REAL x) {
    REAL w = log((REAL)1.0 - x * x);
    REAL p = sqrt(w * (EI_A1 + w * (EI_A2 + w * (EI_A3 + w * (EI_A4 + w * (EI_A5 + w * EI_A6))))));
    return (x < (REAL)0.0) ? -p : p;
}


constant REAL ECI_A1 = (REAL)-0.140543331;
constant REAL ECI_A2 = (REAL)0.914624893;
constant REAL ECI_A3 = (REAL)-1.645349621;
constant REAL ECI_A4 = (REAL)0.886226899;
constant REAL ECI_B1 = (REAL)-0.012200287;
constant REAL ECI_B2 = (REAL)-0.174030709;
constant REAL ECI_B3 = (REAL)0.325598322;
constant REAL ECI_B4 = (REAL)0.892459516;
constant REAL ECI_C0 = (REAL)0.0;
constant REAL ECI_C1 = (REAL)0.564189583;
constant REAL ECI_C2 = (REAL)1.211056027;
constant REAL ECI_C3 = (REAL)1.050750072;
constant REAL ECI_C4 = (REAL)0.285070173;
constant REAL ECI_D1 = (REAL)1.011728051;
constant REAL ECI_D2 = (REAL)1.732339080;
constant REAL ECI_D3 = (REAL)0.753168411;
constant REAL ECI_D4 = (REAL)0.081188386;

inline REAL erfcinv(REAL x) {
    REAL z;
    if (x <= 0.0) {
        return INFINITY;
    } else if (x >= 2.0) {
        return -INFINITY;
    } else if (x > 1.0) {
        z = sqrt(-log((2.0 - x) / 2.0));
        return (((((ECI_C4 * z + ECI_C3) * z + ECI_C2) * z + ECI_C1) * z + ECI_C0) /
                ((((ECI_D4 * z + ECI_D3) * z + ECI_D2) * z + ECI_D1) * z + 1.0));
    } else {
        z = sqrt(-log(x / 2.0));
        return -(((((ECI_A4 * z + ECI_A3) * z + ECI_A2) * z + ECI_A1) * z + 0.0) /
                 ((((ECI_B4 * z + ECI_B3) * z + ECI_B2) * z + ECI_B1) * z + 1.0));
    }
}


constant REAL CN_A1 = (REAL)0.254829592;
constant REAL CN_A2 = (REAL)-0.284496736;
constant REAL CN_A3 = (REAL)1.421413741;
constant REAL CN_A4 = (REAL)-1.453152027;
constant REAL CN_A5 = (REAL)1.061405429;
constant REAL CN_P  = (REAL)0.3275911;

inline REAL normcdf(REAL x) {
    REAL sgn = (x < 0.0) ? (REAL)-1.0 : (REAL)1.0;
    x = abs(x) / sqrt((REAL)2.0);

    // A&S formula 7.1.26 approximation
    REAL t = (REAL)1.0 / ((REAL)1.0 + CN_P * x);
    REAL y = (((((CN_A5 * t + CN_A4) * t) + CN_A3) * t + CN_A2) * t + CN_A1) * t;
    return REAL1o2 * ((REAL)1.0 + sgn * ((REAL)1.0 - exp(-x * x - y)));
}


// Approximation of the inverse normal CDF: Peter John Acklam, 2002
// https://web.archive.org/web/20151030215612/http://home.online.no/~pjacklam/notes/invnorm/

constant REAL CNI_A1 = (REAL)-3.969683028665376e+01;
constant REAL CNI_A2 = (REAL)2.209460984245205e+02;
constant REAL CNI_A3 = (REAL)-2.759285104469687e+02;
constant REAL CNI_A4 = (REAL)1.383577518672690e+02;
constant REAL CNI_A5 = (REAL)-3.066479806614716e+01;
constant REAL CNI_A6 = (REAL)2.506628277459239e+00;

constant REAL CNI_B1 = (REAL)-5.447609879822406e+01;
constant REAL CNI_B2 = (REAL)1.615858368580409e+02;
constant REAL CNI_B3 = (REAL)-1.556989798598866e+02;
constant REAL CNI_B4 = (REAL)6.680131188771972e+01;
constant REAL CNI_B5 = (REAL)-1.328068155288572e+01;

constant REAL CNI_C1 = (REAL)-7.784894002430293e-03;
constant REAL CNI_C2 = (REAL)-3.223964580411365e-01;
constant REAL CNI_C3 = (REAL)-2.400758277161838e+00;
constant REAL CNI_C4 = (REAL)-2.549732539343734e+00;
constant REAL CNI_C5 = (REAL)4.374664141464968e+00;
constant REAL CNI_C6 = (REAL)2.938163982698783e+00;

constant REAL CNI_D1 = (REAL)7.784695709041462e-03;
constant REAL CNI_D2 = (REAL)3.224671290700398e-01;
constant REAL CNI_D3 = (REAL)2.445134137142996e+00;
constant REAL CNI_D4 = (REAL)3.754408661907416e+00;

constant REAL X_LOW = (REAL)0.02425;
constant REAL X_HIGH = (REAL)1.0 - X_LOW;

// A&S formula 26.2.23 approximation
inline REAL normcdfinv(REAL x) {
    REAL q, r;
    if (x < X_LOW) {
      q = sqrt(-2.0 * log(x));
      return (((((CNI_C1 * q + CNI_C2) * q + CNI_C3) * q + CNI_C4) * q + CNI_C5) * q + CNI_C6) /
             ((((CNI_D1 * q + CNI_D2) * q + CNI_D3) * q + CNI_D4) * q + 1.0);
    } else if (x <= X_HIGH) {
      q = x - 0.5;
      r = q * q;
      return (((((CNI_A1 * r + CNI_A2) * r + CNI_A3) * r + CNI_A4) * r + CNI_A5) * r + CNI_A6) * q /
             (((((CNI_B1 * r + CNI_B2) * r + CNI_B3) * r + CNI_B4) * r + CNI_B5) * r + 1.0);
    } else {
      q = sqrt(-2.0 * log(1.0 - x));
      return -(((((CNI_C1 * q + CNI_C2) * q + CNI_C3) * q + CNI_C4) * q + CNI_C5) * q + CNI_C6) /
             ((((CNI_D1 * q + CNI_D2) * q + CNI_D3) * q + CNI_D4) * q + 1.0);
    }
}


constant REAL g = 7.0;
constant REAL coefficients[] = {
    (REAL)0.99999999999980993,  (REAL)676.5203681218851,     (REAL)-1259.1392167224028,
    (REAL)771.32342877765313,   (REAL)-176.61502916214059,   (REAL)12.507343278686905,
    (REAL)-0.13857109526572012, (REAL)9.9843695780195716e-6, (REAL)1.5056327351493116e-7
};

inline REAL tgamma(REAL x) {
    if (x < 0.5) {
        return M_PI / (sin(M_PI * x) * tgamma((REAL)1.0 - x));
    } else {
        x -= (REAL)1.0;
        REAL y = coefficients[0];
        for (int i = 1; i < 9; i++) {
            y += coefficients[i] / (x + i);
        }
        REAL t = x + g + 0.5;
        return sqrt((REAL)2.0 * M_PI) * pow(t, x + REAL1o2) * exp(-t) * y;
    }
}


inline REAL lgamma(REAL x) {
    return log(fabs(tgamma(x)));
}


inline REAL remainder(REAL x, REAL y) {
    return x - y * round(x / y);
}

inline REAL hypot(REAL x, REAL y) {
    return sqrt(x * x + y * y);
}

inline REAL expm1(REAL x) {
    if (fabs(x) < (REAL)1e-5) {
      REAL x2 = x * x;
      REAL x3 = x2 * x;
      REAL x4 = x2 * x2;
      return x + x2 / (REAL)2.0 + x3 / (REAL)6.0 + x4 / (REAL)24.0;
    } else {
      return exp(x) - (REAL)1.0;
    }
}

inline REAL log1p(REAL x) {
    if (fabs(x) < (REAL)1e-5) {
        float x2 = x * x;
        float x3 = x2 * x;
        float x4 = x3 * x;
        return x - x2 / (REAL)2.0 + x3 / (REAL)3.0 - x4 / (REAL)4.0;
    } else {
        return log((REAL)1.0 + x);
    }
}

//////////////////////////////////////////
// Implementations of the vector functions
//////////////////////////////////////////


kernel void vector_sqr (const device REAL* x,
                        constant uint& offset_x,
                        constant uint& stride_x,
                        device REAL* y,
                        constant uint& offset_y,
                        constant uint& stride_y,
                        uint gid [[thread_position_in_grid]]) {
    REAL xval = x[offset_x + gid * stride_x];
    y[offset_y + gid * stride_y] = xval * xval;
}

kernel void vector_mul (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                        const device REAL* y, constant uint& offset_y, constant uint& stride_y,
                        device REAL* z, constant uint& offset_z, constant uint& stride_z,
                        uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = x[offset_x + id * stride_x] * y[offset_y + id * stride_y];
}


kernel void vector_div (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                        const device REAL* y, constant uint& offset_y, constant uint& stride_y,
                        device REAL* z, constant uint& offset_z, constant uint& stride_z,
                        uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = x[offset_x + id * stride_x] / y[offset_y + id * stride_y];
}


kernel void vector_inv (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                        device REAL* y, constant uint& offset_y, constant uint& stride_y,
                        uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = (REAL)1.0 / x[offset_x + id * stride_x];
}


kernel void vector_abs (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                        device REAL* y, constant uint& offset_y, constant uint& stride_y,
                        uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = abs(x[offset_x + id * stride_x]);
}


kernel void vector_linear_frac (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                                const device REAL* y, constant uint& offset_y, constant uint& stride_y,
                                constant REAL& scalea, constant REAL& shifta,
                                constant REAL& scaleb, constant REAL& shiftb,
                                device REAL* z, constant uint& offset_z, constant uint& stride_z,
                                uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] =
        (scalea * x[offset_x + id * stride_x] + shifta) /
        (scaleb * y[offset_y + id * stride_y] + shiftb);
}


// TODO: do the scaleb and shiftb values need to be included?

kernel void vector_scale_shift (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                                constant REAL& scalea, constant REAL& shifta,
                                constant REAL& scaleb, constant REAL& shiftb,
                                device REAL* y, constant uint& offset_y, constant uint& stride_y,
                                uint id [[thread_position_in_grid]]) {
  y[offset_y + id * stride_y] = scalea * x[offset_x + id * stride_x] + shifta;
}


kernel void vector_fmod (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         const device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         device REAL* z, constant uint& offset_z, constant uint& stride_z,
                         uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = fmod(x[offset_x + id * stride_x], y[offset_y + id * stride_y]);
}


kernel void vector_frem (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         const device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         device REAL* z, constant uint& offset_z, constant uint& stride_z,
                         uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = remainder(x[offset_x + id * stride_x], y[offset_y + id * stride_y]);
}


kernel void vector_sqrt (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = sqrt(x[offset_x + id * stride_x]);
}


kernel void vector_inv_sqrt (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                             device REAL* y, constant uint& offset_y, constant uint& stride_y,
                             uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = rsqrt(x[offset_x + id * stride_x]);
}


kernel void vector_cbrt (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = pow(x[offset_x + id * stride_x], REAL1o3);
}


kernel void vector_inv_cbrt (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                             device REAL* y, constant uint& offset_y, constant uint& stride_y,
                             uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = (REAL)1.0 / pow(x[offset_x + id * stride_x], REAL1o3);
}


kernel void vector_pow2o3 (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                           device REAL* y, constant uint& offset_y, constant uint& stride_y,
                           uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = pow(x[offset_x + id * stride_x], REAL2o3);
}


kernel void vector_pow3o2 (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                           device REAL* y, constant uint& offset_y, constant uint& stride_y,
                           uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = pow(x[offset_x + id * stride_x], REAL3o2);
}


kernel void vector_pow (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                        const device REAL* y, constant uint& offset_y, constant uint& stride_y,
                        device REAL* z, constant uint& offset_z, constant uint& stride_z,
                        uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = pow(x[offset_x + id * stride_x], y[offset_y + id * stride_y]);
}


kernel void vector_powx (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         constant REAL& b,
                         device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = pow(x[offset_x + id * stride_x], b);
}


kernel void vector_hypot (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                          const device REAL* y, constant uint& offset_y, constant uint& stride_y,
                          device REAL* z, constant uint& offset_z, constant uint& stride_z,
                          uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = hypot(x[offset_x + id * stride_x], y[offset_y + id * stride_y]);
}


kernel void vector_exp (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                        device REAL* y, constant uint& offset_y, constant uint& stride_y,
                        uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = exp(x[offset_x + id * stride_x]);
}


kernel void vector_exp2 (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = exp2(x[offset_x + id * stride_x]);
}


kernel void vector_exp10 (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                          device REAL* y, constant uint& offset_y, constant uint& stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = pow((REAL)10.0, x[offset_x + id * stride_x]);
}


kernel void vector_expm1 (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                          device REAL* y, constant uint& offset_y, constant uint& stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = expm1(x[offset_x + id * stride_x]);
}


kernel void vector_log (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                        device REAL* y, constant uint& offset_y, constant uint& stride_y,
                        uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = log(x[offset_x + id * stride_x]);
}


kernel void vector_log2 (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = log2(x[offset_x + id * stride_x]);
}


kernel void vector_log10 (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                          device REAL* y, constant uint& offset_y, constant uint& stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = log10(x[offset_x + id * stride_x]);
}


kernel void vector_log1p (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                          device REAL* y, constant uint& offset_y, constant uint& stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = log1p(x[offset_x + id * stride_x]);
}


kernel void vector_sin (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                        device REAL* y, constant uint& offset_y, constant uint& stride_y,
                        uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = sin(x[offset_x + id * stride_x]);
}


kernel void vector_cos (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                        device REAL* y, constant uint& offset_y, constant uint& stride_y,
                        uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = cos(x[offset_x + id * stride_x]);
}


kernel void vector_tan (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                        device REAL* y, constant uint& offset_y, constant uint& stride_y,
                        uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = tan(x[offset_x + id * stride_x]);
}


kernel void vector_sincos (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                           device REAL* y, constant uint& offset_y, constant uint& stride_y,
                           device REAL* z, constant uint& offset_z, constant uint& stride_z,
                           uint id [[thread_position_in_grid]]) {
    REAL xval = x[offset_x + id * stride_x];
    y[offset_y + id * stride_y] = sin(xval);
    z[offset_z + id * stride_z] = cos(xval);
}


kernel void vector_asin (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = asin(x[offset_x + id * stride_x]);
}


kernel void vector_acos (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = acos(x[offset_x + id * stride_x]);
}


kernel void vector_atan (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = atan(x[offset_x + id * stride_x]);
}


kernel void vector_atan2 (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                          const device REAL* y, constant uint& offset_y, constant uint& stride_y,
                          device REAL* z, constant uint& offset_z, constant uint& stride_z,
                          uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = atan2(x[offset_x + id * stride_x], y[offset_y + id * stride_y]);
}


kernel void vector_sinh (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = sinh(x[offset_x + id * stride_x]);
}


kernel void vector_cosh (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = cosh(x[offset_x + id * stride_x]);
}


kernel void vector_tanh (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = tanh(x[offset_x + id * stride_x]);
}


kernel void vector_asinh (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                          device REAL* y, constant uint& offset_y, constant uint& stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = asinh(x[offset_x + id * stride_x]);
}


kernel void vector_acosh (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                          device REAL* y, constant uint& offset_y, constant uint& stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = acosh(x[offset_x + id * stride_x]);
}


kernel void vector_atanh (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                          device REAL* y, constant uint& offset_y, constant uint& stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = atanh(x[offset_x + id * stride_x]);
}


kernel void vector_erf (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                        device REAL* y, constant uint& offset_y, constant uint& stride_y,
                        uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = erf(x[offset_x + id * stride_x]);
}


kernel void vector_erf_inv (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                            device REAL* y, constant uint& offset_y, constant uint& stride_y,
                            uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = erfinv(x[offset_x + id * stride_x]);
}


kernel void vector_erfc (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = erfc(x[offset_x + id * stride_x]);
}


kernel void vector_erfc_inv (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                             device REAL* y, constant uint& offset_y, constant uint& stride_y,
                             uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = erfcinv(x[offset_x + id * stride_x]);
}


kernel void vector_cdf_norm (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                                    device REAL* y, constant uint& offset_y, constant uint& stride_y,
                                    uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = normcdf(x[offset_x + id * stride_x]);
}


kernel void vector_cdf_norm_inv (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                                 device REAL* y, constant uint& offset_y, constant uint& stride_y,
                                 uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = normcdfinv(x[offset_x + id * stride_x]);
}


kernel void vector_gamma (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = tgamma(x[offset_x + id * stride_x]);
}


kernel void vector_lgamma (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                          device REAL* y, constant uint& offset_y, constant uint& stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = lgamma(x[offset_x + id * stride_x]);
}


kernel void vector_floor (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                          device REAL* y, constant uint& offset_y, constant uint& stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = floor(x[offset_x + id * stride_x]);
}


kernel void vector_ceil (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = ceil(x[offset_x + id * stride_x]);
}


kernel void vector_trunc (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                          device REAL* y, constant uint& offset_y, constant uint& stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = trunc(x[offset_x + id * stride_x]);
}


kernel void vector_round (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                          device REAL* y, constant uint& offset_y, constant uint& stride_y,
                          uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = round(x[offset_x + id * stride_x]);
}


kernel void vector_modf (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         device REAL* z, constant uint& offset_z, constant uint& stride_z,
                         uint id [[thread_position_in_grid]]) {
    REAL xval = x[offset_x + id * stride_x];
    REAL intpart = (REAL)((long)xval);
    z[offset_z + id * stride_z] = xval - intpart;
    y[offset_z + id * stride_z] = intpart;
}


kernel void vector_frac (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         uint id [[thread_position_in_grid]]) {
    REAL xval = x[offset_x + id * stride_x];
    y[offset_y + id * stride_y] = xval - (REAL)((long)xval);
}


kernel void vector_fmax (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         const device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         device REAL* z, constant uint& offset_z, constant uint& stride_z,
                         uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = fmax(x[offset_x + id * stride_x], y[offset_y + id * stride_y]);
}


kernel void vector_fmin (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         const device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         device REAL* z, constant uint& offset_z, constant uint& stride_z,
                         uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = fmin(x[offset_x + id * stride_x], y[offset_y + id * stride_y]);
}


kernel void vector_copysign (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                             const device REAL* y, constant uint& offset_y, constant uint& stride_y,
                             device REAL* z, constant uint& offset_z, constant uint& stride_z,
                             uint id [[thread_position_in_grid]]) {
    z[offset_z + id * stride_z] = copysign(x[offset_x + id * stride_x], y[offset_y + id * stride_y]);
}


kernel void vector_sigmoid (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                            device REAL* y, constant uint& offset_y, constant uint& stride_y,
                            uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = tanh(REAL1o2 * x[offset_x + id * stride_x]) * REAL1o2 + REAL1o2;
}


kernel void vector_ramp (const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         uint id [[thread_position_in_grid]]) {
    y[offset_y + id * stride_y] = fmax(x[offset_x + id * stride_x], (REAL)0.0);
}


kernel void vector_relu (constant REAL& alpha,
                         const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                         device REAL* y, constant uint& offset_y, constant uint& stride_y,
                         uint id [[thread_position_in_grid]]) {
    REAL xval = x[offset_x + id * stride_x];
    y[offset_y + id * stride_y] = fmax(xval, alpha * xval);
}


kernel void vector_elu (constant REAL& alpha,
                        const device REAL* x, constant uint& offset_x, constant uint& stride_x,
                        device REAL* y, constant uint& offset_y, constant uint& stride_y,
                        uint id [[thread_position_in_grid]]) {
    REAL xval = x[offset_x + id * stride_x];
    y[offset_y + id * stride_y] = fmax(xval, alpha * expm1(xval));
}


///////////////////////////////////////////////////////////////////
// Implementations of the matrix functions
// As these get more complex, annotating parameters to ensure order
///////////////////////////////////////////////////////////////////


kernel void ge_sqr (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                    const device REAL* a [[buffer(2)]],
                    constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                    device REAL* b [[buffer(5)]],
                    constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                    uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        REAL aval = a[offset_a + gid_0 + gid_1 * ld_a];
        b[offset_b + gid_0 + gid_1 * ld_b] = aval * aval;
    }
}


kernel void ge_mul (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                    const device REAL* a [[buffer(2)]],
                    constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                    const device REAL* b [[buffer(5)]],
                    constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                    device REAL* c [[buffer(8)]],
                    constant int& offset_c [[buffer(9)]], constant int& ld_c [[buffer(10)]],
                    uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        c[offset_c + gid_0 + gid_1 * ld_c] =
            a[offset_a + gid_0 + gid_1 * ld_a] * b[offset_b + gid_0 + gid_1 * ld_b];
    }
}


kernel void ge_div (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                    const device REAL* a [[buffer(2)]],
                    constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                    const device REAL* b [[buffer(5)]],
                    constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                    device REAL* c [[buffer(8)]],
                    constant int& offset_c [[buffer(9)]], constant int& ld_c [[buffer(10)]],
                    uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        c[offset_c + gid_0 + gid_1 * ld_c] =
            a[offset_a + gid_0 + gid_1 * ld_a] / b[offset_b + gid_0 + gid_1 * ld_b];
    }
}


kernel void ge_inv (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                    const device REAL* a [[buffer(2)]],
                    constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                    device REAL* b [[buffer(5)]],
                    constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                    uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = (REAL)1.0 / a[offset_a + gid_0 + gid_1 * ld_a];
    }
}


kernel void ge_abs (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                    const device REAL* a [[buffer(2)]],
                    constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                    device REAL* b [[buffer(5)]],
                    constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                    uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = fabs(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}

kernel void ge_linear_frac (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                            const device REAL* a [[buffer(2)]],
                            constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                            const device REAL* b [[buffer(5)]],
                            constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                            constant REAL& scalea [[buffer(8)]], constant REAL& shifta [[buffer(9)]],
                            constant REAL& scaleb [[buffer(10)]], constant REAL& shiftb [[buffer(11)]],
                            device REAL* c [[buffer(12)]],
                            constant int& offset_c [[buffer(13)]], constant int& ld_c [[buffer(14)]],
                            uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        c[offset_c + gid_0 + gid_1 * ld_c] =
            (scalea * a[offset_a + gid_0 + gid_1 * ld_a] + shifta) /
            (scaleb * b[offset_b + gid_0 + gid_1 * ld_b] + shiftb);
    }
}


// TODO: do the scaleb and shiftb values need to be included?

kernel void ge_scale_shift (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                            const device REAL* a [[buffer(2)]],
                            constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                            constant REAL& scalea [[buffer(5)]], constant REAL& shifta [[buffer(6)]],
                            constant REAL& scaleb [[buffer(7)]], constant REAL& shiftb [[buffer(8)]],
                            device REAL* c [[buffer(9)]],
                            constant int& offset_c [[buffer(10)]], constant int& ld_c [[buffer(11)]],
                            uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        c[offset_c + gid_0 + gid_1 * ld_c] = scalea * a[offset_a + gid_0 + gid_1 * ld_a] + shifta;
    }
}


kernel void ge_fmod (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     const device REAL* b [[buffer(5)]],
                     constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                     device REAL* c [[buffer(8)]],
                     constant int& offset_c [[buffer(9)]], constant int& ld_c [[buffer(10)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        c[offset_c + gid_0 + gid_1 * ld_c] = fmod(a[offset_a + gid_0 + gid_1 * ld_a],
                                                  b[offset_b + gid_0 + gid_1 * ld_b]);
    }
}


kernel void ge_frem (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     const device REAL* b [[buffer(5)]],
                     constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                     device REAL* c [[buffer(8)]],
                     constant int& offset_c [[buffer(9)]], constant int& ld_c [[buffer(10)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        c[offset_c + gid_0 + gid_1 * ld_c] = remainder(a[offset_a + gid_0 + gid_1 * ld_a],
                                                       b[offset_b + gid_0 + gid_1 * ld_b]);
    }
}


kernel void ge_sqrt (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     device REAL* b [[buffer(5)]],
                     constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = sqrt(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_inv_sqrt (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                         const device REAL* a [[buffer(2)]],
                         constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                         device REAL* b [[buffer(5)]],
                         constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                         uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = (REAL)1.0 / sqrt(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_cbrt (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     device REAL* b [[buffer(5)]],
                     constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = pow(a[offset_a + gid_0 + gid_1 * ld_a], REAL1o3);
    }
}


kernel void ge_inv_cbrt (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                         const device REAL* a [[buffer(2)]],
                         constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                         device REAL* b [[buffer(5)]],
                         constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                         uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = (REAL)1.0 / pow(a[offset_a + gid_0 + gid_1 * ld_a], REAL1o3);
    }
}


kernel void ge_pow2o3 (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                       const device REAL* a [[buffer(2)]],
                       constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                       device REAL* b [[buffer(5)]],
                       constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                       uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = pow(a[offset_a + gid_0 + gid_1 * ld_a], REAL2o3);
    }
}


kernel void ge_pow3o2 (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                       const device REAL* a [[buffer(2)]],
                       constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                       device REAL* b [[buffer(5)]],
                       constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                       uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = pow(a[offset_a + gid_0 + gid_1 * ld_a], REAL3o2);
    }
}


kernel void ge_pow (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                    const device REAL* a [[buffer(2)]],
                    constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                    const device REAL* b [[buffer(5)]],
                    constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                    device REAL* c [[buffer(8)]],
                    constant int& offset_c [[buffer(9)]], constant int& ld_c [[buffer(10)]],
                    uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        c[offset_c + gid_0 + gid_1 * ld_c] = pow(a[offset_a + gid_0 + gid_1 * ld_a],
                                                 b[offset_b + gid_0 + gid_1 * ld_b]);
    }
}


kernel void ge_powx (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     constant REAL& b [[buffer(5)]],
                     device REAL* c [[buffer(6)]],
                     constant int& offset_c [[buffer(7)]], constant int& ld_c [[buffer(8)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        c[offset_c + gid_0 + gid_1 * ld_c] = pow(a[offset_a + gid_0 + gid_1 * ld_a], b);
    }
}


kernel void ge_hypot (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                      const device REAL* a [[buffer(2)]],
                      constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                      const device REAL* b [[buffer(5)]],
                      constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                      device REAL* c [[buffer(8)]],
                      constant int& offset_c [[buffer(9)]], constant int& ld_c [[buffer(10)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        c[offset_c + gid_0 + gid_1 * ld_c] = hypot(a[offset_a + gid_0 + gid_1 * ld_a],
                                                   b[offset_b + gid_0 + gid_1 * ld_b]);
    }
}


kernel void ge_exp (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                    const device REAL* a [[buffer(2)]],
                    constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                    device REAL* b [[buffer(5)]],
                    constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                    uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = exp(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_exp2 (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     device REAL* b [[buffer(5)]],
                     constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = exp2(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_exp10 (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                      const device REAL* a [[buffer(2)]],
                      constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                      device REAL* b [[buffer(5)]],
                      constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = pow((REAL)10.0, a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}

kernel void ge_expm1 (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                      const device REAL* a [[buffer(2)]],
                      constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                      device REAL* b [[buffer(5)]],
                      constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = expm1(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_log (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                    const device REAL* a [[buffer(2)]],
                    constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                    device REAL* b [[buffer(5)]],
                    constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                    uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = log(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_log2 (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     device REAL* b [[buffer(5)]],
                     constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = log2(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_log10 (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                      const device REAL* a [[buffer(2)]],
                      constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                      device REAL* b [[buffer(5)]],
                      constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = log10(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_log1p (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                      const device REAL* a [[buffer(2)]],
                      constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                      device REAL* b [[buffer(5)]],
                      constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = log1p(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_sin (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                    const device REAL* a [[buffer(2)]],
                    constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                    device REAL* b [[buffer(5)]],
                    constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                    uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = sin(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_cos (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                    const device REAL* a [[buffer(2)]],
                    constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                    device REAL* b [[buffer(5)]],
                    constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                    uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = cos(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_tan (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                    const device REAL* a [[buffer(2)]],
                    constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                    device REAL* b [[buffer(5)]],
                    constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                    uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = tan(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_sincos (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                       const device REAL* a [[buffer(2)]],
                       constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                       device REAL* b [[buffer(5)]],
                       constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                       device REAL* c [[buffer(8)]],
                       constant int& offset_c [[buffer(9)]], constant int& ld_c [[buffer(10)]],
                       uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = sin(a[offset_a + gid_0 + gid_1 * ld_a]);
        c[offset_c + gid_0 + gid_1 * ld_c] = cos(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_asin (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     device REAL* b [[buffer(5)]],
                     constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = asin(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_acos (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     device REAL* b [[buffer(5)]],
                     constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = acos(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_atan (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     device REAL* b [[buffer(5)]],
                     constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = atan(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_atan2 (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                      const device REAL* a [[buffer(2)]],
                      constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                      const device REAL* b [[buffer(5)]],
                      constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                      device REAL* c [[buffer(8)]],
                      constant int& offset_c [[buffer(9)]], constant int& ld_c [[buffer(10)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        c[offset_c + gid_0 + gid_1 * ld_c] = atan2(a[offset_a + gid_0 + gid_1 * ld_a],
                                                   b[offset_b + gid_0 + gid_1 * ld_b]);
    }
}


kernel void ge_sinh (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     device REAL* b [[buffer(5)]],
                     constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = sinh(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_cosh (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     device REAL* b [[buffer(5)]],
                     constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = cosh(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_tanh (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     device REAL* b [[buffer(5)]],
                     constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = tanh(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_asinh (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                      const device REAL* a [[buffer(2)]],
                      constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                      device REAL* b [[buffer(5)]],
                      constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = asinh(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_acosh (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                      const device REAL* a [[buffer(2)]],
                      constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                      device REAL* b [[buffer(5)]],
                      constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = acosh(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_atanh (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                      const device REAL* a [[buffer(2)]],
                      constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                      device REAL* b [[buffer(5)]],
                      constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = atanh(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_erf (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                    const device REAL* a [[buffer(2)]],
                    constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                    device REAL* b [[buffer(5)]],
                    constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                    uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = erf(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_erf_inv (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                        const device REAL* a [[buffer(2)]],
                        constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                        device REAL* b [[buffer(5)]],
                        constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                        uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = erfinv(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_erfc (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     device REAL* b [[buffer(5)]],
                     constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = erfc(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_erfcinv (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                        const device REAL* a [[buffer(2)]],
                        constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                        device REAL* b [[buffer(5)]],
                        constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                        uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = erfcinv(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_cdf_norm (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                         const device REAL* a [[buffer(2)]],
                         constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                         device REAL* b [[buffer(5)]],
                         constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                         uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = normcdf(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_cdf_norm_inv (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                             const device REAL* a [[buffer(2)]],
                             constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                             device REAL* b [[buffer(5)]],
                             constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                             uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = normcdfinv(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_gamma (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                      const device REAL* a [[buffer(2)]],
                      constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                      device REAL* b [[buffer(5)]],
                      constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = tgamma(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_lgamma (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                       const device REAL* a [[buffer(2)]],
                       constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                       device REAL* b [[buffer(5)]],
                       constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                       uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = lgamma(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_floor (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                      const device REAL* a [[buffer(2)]],
                      constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                      device REAL* b [[buffer(5)]],
                      constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = floor(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_ceil (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     device REAL* b [[buffer(5)]],
                     constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = ceil(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_trunc (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                      const device REAL* a [[buffer(2)]],
                      constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                      device REAL* b [[buffer(5)]],
                      constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = trunc(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_round (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                      const device REAL* a [[buffer(2)]],
                      constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                      device REAL* b [[buffer(5)]],
                      constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = round(a[offset_a + gid_0 + gid_1 * ld_a]);
    }
}


kernel void ge_modf (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     device REAL* b [[buffer(5)]],
                     constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                     device REAL* c [[buffer(8)]],
                     constant int& offset_c [[buffer(9)]], constant int& ld_c [[buffer(10)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        REAL aval = a[offset_a + gid_0 + gid_1 * ld_a];
        REAL intpart = (REAL)((long)aval);
        c[offset_c + gid_0 + gid_1 * ld_c] = aval - intpart;
        b[offset_b + gid_0 + gid_1 * ld_b] = intpart;
    }
}


kernel void ge_frac (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     device REAL* b [[buffer(5)]],
                     constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        REAL aval = a[offset_a + gid_0 + gid_1 * ld_a];
        b[offset_b + gid_0 + gid_1 * ld_b] = aval - (REAL)((long)aval);
    }
}


kernel void ge_fmax (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     const device REAL* b [[buffer(5)]],
                     constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                     device REAL* c [[buffer(8)]],
                     constant int& offset_c [[buffer(9)]], constant int& ld_c [[buffer(10)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        c[offset_c + gid_0 + gid_1 * ld_c] = fmax(a[offset_a + gid_0 + gid_1 * ld_a],
                                                  b[offset_b + gid_0 + gid_1 * ld_b]);
    }
}


kernel void ge_fmin (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     const device REAL* b [[buffer(5)]],
                     constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                     device REAL* c [[buffer(8)]],
                     constant int& offset_c [[buffer(9)]], constant int& ld_c [[buffer(10)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        c[offset_c + gid_0 + gid_1 * ld_c] = fmin(a[offset_a + gid_0 + gid_1 * ld_a],
                                                  b[offset_b + gid_0 + gid_1 * ld_b]);
    }
}


kernel void ge_copysign (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                         const device REAL* a [[buffer(2)]],
                         constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                         const device REAL* b [[buffer(5)]],
                         constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                         device REAL* c [[buffer(8)]],
                         constant int& offset_c [[buffer(9)]], constant int& ld_c [[buffer(10)]],
                         uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        c[offset_c + gid_0 + gid_1 * ld_c] = copysign(a[offset_a + gid_0 + gid_1 * ld_a],
                                                      b[offset_b + gid_0 + gid_1 * ld_b]);
    }
}


kernel void ge_sigmoid (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                        const device REAL* a [[buffer(2)]],
                        constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                        device REAL* b [[buffer(5)]],
                        constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                        uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = tanh(REAL1o2 * a[offset_a + gid_0 + gid_1 * ld_a]) * REAL1o2 + REAL1o2;
    }
}


kernel void ge_ramp (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     const device REAL* a [[buffer(2)]],
                     constant int& offset_a [[buffer(3)]], constant int& ld_a [[buffer(4)]],
                     device REAL* b [[buffer(5)]],
                     constant int& offset_b [[buffer(6)]], constant int& ld_b [[buffer(7)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        b[offset_b + gid_0 + gid_1 * ld_b] = fmax(a[offset_a + gid_0 + gid_1 * ld_a], (REAL)0.0);
    }
}


kernel void ge_relu (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                     constant REAL& alpha [[buffer(2)]],
                     const device REAL* a [[buffer(3)]],
                     constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                     device REAL* b [[buffer(6)]],
                     constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                     uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        REAL val = a[offset_a + gid_0 + gid_1 * ld_a];
        b[offset_b + gid_0 + gid_1 * ld_b] = fmax(val, alpha * val);
    }
}


kernel void ge_elu (constant int& sd [[buffer(0)]], constant int& fd [[buffer(1)]],
                    constant REAL& alpha [[buffer(2)]],
                    const device REAL* a [[buffer(3)]],
                    constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                    device REAL* b [[buffer(6)]],
                    constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                    uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < fd) {
        REAL val = a[offset_a + gid_0 + gid_1 * ld_a];
        b[offset_b + gid_0 + gid_1 * ld_b] = fmax(val, alpha * expm1(val));
    }
}


///////////////////////////////////////////////////////////////////
// Implementations of the uplo matrix functions
// As these get more complex, annotating parameters to ensure order
///////////////////////////////////////////////////////////////////


kernel void uplo_sqr (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            REAL aval = a[offset_a + gid_0 + gid_1 * ld_a];
            b[offset_b + gid_0 + gid_1 * ld_b] = aval * aval;
        }
    }
}


kernel void uplo_mul (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      const device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                      device REAL* c [[buffer(9)]], constant int& offset_c [[buffer(10)]], constant int& ld_c [[buffer(11)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            c[offset_c + gid_0 + gid_1 * ld_c] = a[offset_a + gid_0 + gid_1 * ld_a] * b[offset_b + gid_0 + gid_1 * ld_b];
        }
    }
}


kernel void uplo_div (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      const device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                      device REAL* c [[buffer(9)]], constant int& offset_c [[buffer(10)]], constant int& ld_c [[buffer(11)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            c[offset_c + gid_0 + gid_1 * ld_c] = a[offset_a + gid_0 + gid_1 * ld_a] / b[offset_b + gid_0 + gid_1 * ld_b];
        }
    }
}


kernel void uplo_inv (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = (REAL)1.0 / a[offset_a + gid_0 + gid_1 * ld_a];
        }
    }
}


kernel void uplo_abs (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = fabs(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_linear_frac (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                              const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                              const device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                              constant REAL& scalea [[buffer(9)]], constant REAL& shifta [[buffer(10)]],
                              constant REAL& scaleb [[buffer(11)]], constant REAL& shiftb [[buffer(12)]],
                              device REAL* c [[buffer(13)]], constant int& offset_c [[buffer(14)]], constant int& ld_c [[buffer(15)]],
                              uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            c[offset_c + gid_0 + gid_1 * ld_c] =
                (scalea * a[offset_a + gid_0 + gid_1 * ld_a] + shifta) /
                (scaleb * b[offset_b + gid_0 + gid_1 * ld_b] + shiftb);
        }
    }
}


kernel void uplo_scale_shift (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                              const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                              constant REAL& scalea [[buffer(6)]], constant REAL& shifta [[buffer(7)]],
                              constant REAL& scaleb [[buffer(8)]], constant REAL& shiftb [[buffer(9)]],
                              device REAL* c [[buffer(10)]], constant int& offset_c [[buffer(11)]], constant int& ld_c [[buffer(12)]],
                              uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            c[offset_c + gid_0 + gid_1 * ld_c] = scalea * a[offset_a + gid_0 + gid_1 * ld_a] + shifta;
        }
    }
}


kernel void uplo_fmod (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      const device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                      device REAL* c [[buffer(9)]], constant int& offset_c [[buffer(10)]], constant int& ld_c [[buffer(11)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            c[offset_c + gid_0 + gid_1 * ld_c] = fmod(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
        }
    }
}


kernel void uplo_frem (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      const device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                      device REAL* c [[buffer(9)]], constant int& offset_c [[buffer(10)]], constant int& ld_c [[buffer(11)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            c[offset_c + gid_0 + gid_1 * ld_c] = remainder(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
        }
    }
}


kernel void uplo_sqrt (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = sqrt(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_inv_sqrt (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                           const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                           device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                           uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = rsqrt(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_cbrt (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = pow(a[offset_a + gid_0 + gid_1 * ld_a], REAL1o3);
        }
    }
}


kernel void uplo_inv_cbrt (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                           const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                           device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                           uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = (REAL)1.0 / pow(a[offset_a + gid_0 + gid_1 * ld_a], REAL1o3);
        }
    }
}


kernel void uplo_pow2o3 (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                         const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                         device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                         uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = pow(a[offset_a + gid_0 + gid_1 * ld_a], REAL2o3);
        }
    }
}


kernel void uplo_pow3o2 (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                         const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                         device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                         uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = pow(a[offset_a + gid_0 + gid_1 * ld_a], REAL3o2);
        }
    }
}


kernel void uplo_pow (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      const device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                      device REAL* c [[buffer(9)]], constant int& offset_c [[buffer(10)]], constant int& ld_c [[buffer(11)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            c[offset_c + gid_0 + gid_1 * ld_c] = pow(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
        }
    }
}


kernel void uplo_powx (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      constant REAL& b [[buffer(6)]],
                      device REAL* c [[buffer(7)]], constant int& offset_c [[buffer(8)]], constant int& ld_c [[buffer(9)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            c[offset_c + gid_0 + gid_1 * ld_c] = pow(a[offset_a + gid_0 + gid_1 * ld_a], b);
        }
    }
}


kernel void uplo_hypot (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                       const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                       const device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                       device REAL* c [[buffer(9)]], constant int& offset_c [[buffer(10)]], constant int& ld_c [[buffer(11)]],
                       uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            c[offset_c + gid_0 + gid_1 * ld_c] = hypot(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
        }
    }
}


kernel void uplo_exp (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = exp(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_exp2 (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = exp2(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_exp10 (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                       const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                       device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                       uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = exp10(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_expm1 (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                        const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                        device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                        uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = expm1(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_log (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = log(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_log2 (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                       const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                       device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                       uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = log2(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_log10 (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                        const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                        device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                        uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = log10(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_log1p (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                        const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                        device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                        uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = log1p(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_sin (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = sin(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_cos (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = cos(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_tan (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = tan(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_sincos (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                         const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                         device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                         device REAL* c [[buffer(9)]], constant int& offset_c [[buffer(10)]], constant int& ld_c [[buffer(11)]],
                         uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            REAL aval = a[offset_a + gid_0 + gid_1 * ld_a];
            b[offset_b + gid_0 + gid_1 * ld_b] = sin(aval);
            c[offset_c + gid_0 + gid_1 * ld_c] = cos(aval);
        }
    }
}


kernel void uplo_asin (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                       const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                       device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                       uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = asin(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_acos (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                       const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                       device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                       uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = acos(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_atan (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                       const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                       device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                       uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = atan(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_atan2 (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                        const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                        const device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                        device REAL* c [[buffer(9)]], constant int& offset_c [[buffer(10)]], constant int& ld_c [[buffer(11)]],
                        uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            c[offset_c + gid_0 + gid_1 * ld_c] = atan2(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
        }
    }
}


kernel void uplo_sinh (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                       const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                       device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                       uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = sinh(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_cosh (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                       const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                       device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                       uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = cosh(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_tanh (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                       const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                       device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                       uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = tanh(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_asinh (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                        const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                        device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                        uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = asinh(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_acosh (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                        const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                        device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                        uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = acosh(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_atanh (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                        const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                        device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                        uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = atanh(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_erf (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = erf(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_erf_inv (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                          const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                          device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                          uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = erfinv(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_erfc (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                       const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                       device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                       uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = erfc(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_erfc_inv (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                          const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                          device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                          uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = erfcinv(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_cdf_norm (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                          const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                          device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                          uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = normcdf(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_cdf_norm_inv (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                              const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                              device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                              uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = normcdfinv(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_gamma (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = tgamma(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_lgamma (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                        const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                        device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                        uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = lgamma(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_floor (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                        const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                        device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                        uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = floor(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_ceil (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                       const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                       device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                       uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = ceil(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_trunc (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                        const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                        device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                        uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = trunc(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_round (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                        const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                        device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                        uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = round(a[offset_a + gid_0 + gid_1 * ld_a]);
        }
    }
}


kernel void uplo_modf (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                       const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                       device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                       device REAL* c [[buffer(9)]], constant int& offset_c [[buffer(10)]], constant int& ld_c [[buffer(11)]],
                       uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            REAL aval = a[offset_a + gid_0 + gid_1 * ld_a];
            REAL intpart = (REAL)((long)aval);
            c[offset_c + gid_0 + gid_1 * ld_c] = aval - intpart;
            b[offset_b + gid_0 + gid_1 * ld_b] = intpart;
        }
    }
}


kernel void uplo_frac (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                       const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                       device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                       uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            REAL aval = a[offset_a + gid_0 + gid_1 * ld_a];
            b[offset_b + gid_0 + gid_1 * ld_b] = aval - (REAL)((long)aval);
        }
    }
}


kernel void uplo_fmax (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                       const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                       const device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                       device REAL* c [[buffer(9)]], constant int& offset_c [[buffer(10)]], constant int& ld_c [[buffer(11)]],
                       uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            c[offset_c + gid_0 + gid_1 * ld_c] = fmax(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
        }
    }
}


kernel void uplo_fmin (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                       const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                       const device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                       device REAL* c [[buffer(9)]], constant int& offset_c [[buffer(10)]], constant int& ld_c [[buffer(11)]],
                       uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            c[offset_c + gid_0 + gid_1 * ld_c] = fmin(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
        }
    }
}


kernel void uplo_copysign (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                           const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                           const device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                           device REAL* c [[buffer(9)]], constant int& offset_c [[buffer(10)]], constant int& ld_c [[buffer(11)]],
                           uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            c[offset_c + gid_0 + gid_1 * ld_c] = copysign(a[offset_a + gid_0 + gid_1 * ld_a], b[offset_b + gid_0 + gid_1 * ld_b]);
        }
    }
}


kernel void uplo_sigmoid (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                          const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                          device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                          uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = tanh(REAL1o2 * a[offset_a + gid_0 + gid_1 * ld_a]) * REAL1o2 + REAL1o2;
        }
    }
}


kernel void uplo_ramp (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      const device REAL* a [[buffer(3)]], constant int& offset_a [[buffer(4)]], constant int& ld_a [[buffer(5)]],
                      device REAL* b [[buffer(6)]], constant int& offset_b [[buffer(7)]], constant int& ld_b [[buffer(8)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            b[offset_b + gid_0 + gid_1 * ld_b] = fmax(a[offset_a + gid_0 + gid_1 * ld_a], (REAL)0.0);
        }
    }
}


kernel void uplo_relu (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      constant REAL& alpha [[buffer(3)]],
                      const device REAL* a [[buffer(4)]], constant int& offset_a [[buffer(5)]], constant int& ld_a [[buffer(6)]],
                      device REAL* b [[buffer(7)]], constant int& offset_b [[buffer(8)]], constant int& ld_b [[buffer(9)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            REAL val = a[offset_a + gid_0 + gid_1 * ld_a];
            b[offset_b + gid_0 + gid_1 * ld_b] = fmax(val, alpha * val);
        }
    }
}


kernel void uplo_elu (constant int& sd [[buffer(0)]], constant int& unit [[buffer(1)]], constant int& bottom [[buffer(2)]],
                      constant REAL& alpha [[buffer(3)]],
                      const device REAL* a [[buffer(4)]], constant int& offset_a [[buffer(5)]], constant int& ld_a [[buffer(6)]],
                      device REAL* b [[buffer(7)]], constant int& offset_b [[buffer(8)]], constant int& ld_b [[buffer(9)]],
                      uint2 id [[thread_position_in_grid]]) {
    int gid_0 = id.x;
    int gid_1 = id.y;
    if (gid_0 < sd && gid_1 < sd) {
        if ((unit == 132) ? bottom * gid_0 > bottom * gid_1 : bottom * gid_0 >= bottom * gid_1) {
            REAL val = a[offset_a + gid_0 + gid_1 * ld_a];
            b[offset_b + gid_0 + gid_1 * ld_b] = fmax(val, alpha * expm1(val));
        }
    }
}

