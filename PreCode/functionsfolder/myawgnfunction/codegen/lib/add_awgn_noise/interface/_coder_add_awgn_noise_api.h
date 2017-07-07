/*
 * File: _coder_add_awgn_noise_api.h
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 14-May-2017 01:59:14
 */

#ifndef _CODER_ADD_AWGN_NOISE_API_H
#define _CODER_ADD_AWGN_NOISE_API_H

/* Include Files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_add_awgn_noise_api.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void add_awgn_noise(real_T x[101], real_T snrdB, real_T y[101], real_T
  *NoiseSigma);
extern void add_awgn_noise_api(const mxArray * const prhs[2], const mxArray
  *plhs[2]);
extern void add_awgn_noise_atexit(void);
extern void add_awgn_noise_initialize(void);
extern void add_awgn_noise_terminate(void);
extern void add_awgn_noise_xil_terminate(void);

#endif

/*
 * File trailer for _coder_add_awgn_noise_api.h
 *
 * [EOF]
 */
