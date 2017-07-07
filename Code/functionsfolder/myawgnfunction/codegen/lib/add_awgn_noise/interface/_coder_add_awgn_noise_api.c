/*
 * File: _coder_add_awgn_noise_api.c
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 14-May-2017 01:59:14
 */

/* Include Files */
#include "tmwtypes.h"
#include "_coder_add_awgn_noise_api.h"
#include "_coder_add_awgn_noise_mex.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;
emlrtContext emlrtContextGlobal = { true,/* bFirstTime */
  false,                               /* bInitialized */
  131450U,                             /* fVersionInfo */
  NULL,                                /* fErrorFunction */
  "add_awgn_noise",                    /* fFunctionName */
  NULL,                                /* fRTCallStack */
  false,                               /* bDebugMode */
  { 2045744189U, 2170104910U, 2743257031U, 4284093946U },/* fSigWrd */
  NULL                                 /* fSigMem */
};

/* Function Declarations */
static real_T (*b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId))[101];
static const mxArray *b_emlrt_marshallOut(const real_T u);
static real_T c_emlrt_marshallIn(const mxArray *snrdB, const char_T *identifier);
static real_T d_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId);
static real_T (*e_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier *
  msgId))[101];
static real_T (*emlrt_marshallIn(const mxArray *x, const char_T *identifier))
  [101];
static const mxArray *emlrt_marshallOut(const real_T u[101]);
static real_T f_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId);

/* Function Definitions */

/*
 * Arguments    : const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : real_T (*)[101]
 */
static real_T (*b_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId))[101]
{
  real_T (*y)[101];
  y = e_emlrt_marshallIn(emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}
/*
 * Arguments    : const real_T u
 * Return Type  : const mxArray *
 */
  static const mxArray *b_emlrt_marshallOut(const real_T u)
{
  const mxArray *y;
  const mxArray *m1;
  y = NULL;
  m1 = emlrtCreateDoubleScalar(u);
  emlrtAssign(&y, m1);
  return y;
}

/*
 * Arguments    : const mxArray *snrdB
 *                const char_T *identifier
 * Return Type  : real_T
 */
static real_T c_emlrt_marshallIn(const mxArray *snrdB, const char_T *identifier)
{
  real_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = d_emlrt_marshallIn(emlrtAlias(snrdB), &thisId);
  emlrtDestroyArray(&snrdB);
  return y;
}

/*
 * Arguments    : const mxArray *u
 *                const emlrtMsgIdentifier *parentId
 * Return Type  : real_T
 */
static real_T d_emlrt_marshallIn(const mxArray *u, const emlrtMsgIdentifier
  *parentId)
{
  real_T y;
  y = f_emlrt_marshallIn(emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

/*
 * Arguments    : const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 * Return Type  : real_T (*)[101]
 */
static real_T (*e_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier *
  msgId))[101]
{
  real_T (*ret)[101];
  static const int32_T dims[2] = { 1, 101 };

  emlrtCheckBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "double", false, 2U,
    dims);
  ret = (real_T (*)[101])mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}
/*
 * Arguments    : const mxArray *x
 *                const char_T *identifier
 * Return Type  : real_T (*)[101]
 */
  static real_T (*emlrt_marshallIn(const mxArray *x, const char_T *identifier))
  [101]
{
  real_T (*y)[101];
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(emlrtAlias(x), &thisId);
  emlrtDestroyArray(&x);
  return y;
}

/*
 * Arguments    : const real_T u[101]
 * Return Type  : const mxArray *
 */
static const mxArray *emlrt_marshallOut(const real_T u[101])
{
  const mxArray *y;
  const mxArray *m0;
  static const int32_T iv0[2] = { 0, 0 };

  static const int32_T iv1[2] = { 1, 101 };

  y = NULL;
  m0 = emlrtCreateNumericArray(2, iv0, mxDOUBLE_CLASS, mxREAL);
  mxSetData((mxArray *)m0, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m0, *(int32_T (*)[2])&iv1[0], 2);
  emlrtAssign(&y, m0);
  return y;
}

/*
 * Arguments    : const mxArray *src
 *                const emlrtMsgIdentifier *msgId
 * Return Type  : real_T
 */
static real_T f_emlrt_marshallIn(const mxArray *src, const emlrtMsgIdentifier
  *msgId)
{
  real_T ret;
  static const int32_T dims = 0;
  emlrtCheckBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "double", false, 0U,
    &dims);
  ret = *(real_T *)mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

/*
 * Arguments    : const mxArray * const prhs[2]
 *                const mxArray *plhs[2]
 * Return Type  : void
 */
void add_awgn_noise_api(const mxArray * const prhs[2], const mxArray *plhs[2])
{
  real_T (*y)[101];
  real_T (*x)[101];
  real_T snrdB;
  real_T NoiseSigma;
  y = (real_T (*)[101])mxMalloc(sizeof(real_T [101]));

  /* Marshall function inputs */
  x = emlrt_marshallIn(emlrtAlias((const mxArray *)prhs[0]), "x");
  snrdB = c_emlrt_marshallIn(emlrtAliasP((const mxArray *)prhs[1]), "snrdB");

  /* Invoke the target function */
  add_awgn_noise(*x, snrdB, *y, &NoiseSigma);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(*y);
  plhs[1] = b_emlrt_marshallOut(NoiseSigma);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void add_awgn_noise_atexit(void)
{
  mexFunctionCreateRootTLS();
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  add_awgn_noise_xil_terminate();
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void add_awgn_noise_initialize(void)
{
  mexFunctionCreateRootTLS();
  emlrtClearAllocCountR2012b(emlrtRootTLSGlobal, false, 0U, 0);
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/*
 * Arguments    : void
 * Return Type  : void
 */
void add_awgn_noise_terminate(void)
{
  emlrtLeaveRtStackR2012b(emlrtRootTLSGlobal);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/*
 * File trailer for _coder_add_awgn_noise_api.c
 *
 * [EOF]
 */
