//
// File: add_awgn_noise.cpp
//
// MATLAB Coder version            : 3.3
// C/C++ source code generated on  : 14-May-2017 01:59:14
//

// Include Files
#include "rt_nonfinite.h"
#include "add_awgn_noise.h"
#include "randn.h"

// Function Declarations
static double rt_powd_snf(double u0, double u1);

// Function Definitions

//
// Arguments    : double u0
//                double u1
// Return Type  : double
//
static double rt_powd_snf(double u0, double u1)
{
  double y;
  double d0;
  double d1;
  if (rtIsNaN(u0) || rtIsNaN(u1)) {
    y = rtNaN;
  } else {
    d0 = std::abs(u0);
    d1 = std::abs(u1);
    if (rtIsInf(u1)) {
      if (d0 == 1.0) {
        y = 1.0;
      } else if (d0 > 1.0) {
        if (u1 > 0.0) {
          y = rtInf;
        } else {
          y = 0.0;
        }
      } else if (u1 > 0.0) {
        y = 0.0;
      } else {
        y = rtInf;
      }
    } else if (d1 == 0.0) {
      y = 1.0;
    } else if (d1 == 1.0) {
      if (u1 > 0.0) {
        y = u0;
      } else {
        y = 1.0 / u0;
      }
    } else if (u1 == 2.0) {
      y = u0 * u0;
    } else if ((u1 == 0.5) && (u0 >= 0.0)) {
      y = std::sqrt(u0);
    } else if ((u0 < 0.0) && (u1 > std::floor(u1))) {
      y = rtNaN;
    } else {
      y = pow(u0, u1);
    }
  }

  return y;
}

//
// y=awgn_noise(x,SNR) adds AWGN noise vector to signal 'x' to generate a
// resulting signal vector y of specified SNR in dB
// rng('default');%set the random generator seed to default (for comparison only)
// Arguments    : const double x[101]
//                double snrdB
//                double y[101]
//                double *NoiseSigma
// Return Type  : void
//
void add_awgn_noise(const double x[101], double snrdB, double y[101], double
                    *NoiseSigma)
{
  int k;
  double b_y;

  // SNR to linear scale
  for (k = 0; k < 101; k++) {
    y[k] = rt_powd_snf(std::abs(x[k]), 2.0);
  }

  b_y = y[0];
  for (k = 0; k < 100; k++) {
    b_y += y[k + 1];
  }

  // Calculate actual symbol energy
  // Find the noise spectral density
  *NoiseSigma = std::sqrt(b_y / 101.0 / rt_powd_snf(10.0, snrdB / 10.0));

  // Standard deviation for AWGN Noise when x is real
  randn(y);

  // computed noise
  for (k = 0; k < 101; k++) {
    y[k] = x[k] + *NoiseSigma * y[k];
  }

  // received signal
}

//
// File trailer for add_awgn_noise.cpp
//
// [EOF]
//
