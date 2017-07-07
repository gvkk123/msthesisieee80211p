//
// File: add_awgn_noise_initialize.cpp
//
// MATLAB Coder version            : 3.3
// C/C++ source code generated on  : 14-May-2017 01:59:14
//

// Include Files
#include "rt_nonfinite.h"
#include "add_awgn_noise.h"
#include "add_awgn_noise_initialize.h"
#include "eml_rand_shr3cong_stateful.h"
#include "eml_rand_mcg16807_stateful.h"
#include "eml_rand.h"
#include "eml_randn.h"
#include "eml_rand_mt19937ar_stateful.h"

// Function Definitions

//
// Arguments    : void
// Return Type  : void
//
void add_awgn_noise_initialize()
{
  rt_InitInfAndNaN(8U);
  state_not_empty_init();
  method_not_empty_init();
  eml_rand_init();
  eml_rand_mcg16807_stateful_init();
  eml_rand_shr3cong_stateful_init();
}

//
// File trailer for add_awgn_noise_initialize.cpp
//
// [EOF]
//
