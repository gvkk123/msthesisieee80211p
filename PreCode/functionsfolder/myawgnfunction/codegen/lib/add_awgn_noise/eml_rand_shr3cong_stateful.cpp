//
// File: eml_rand_shr3cong_stateful.cpp
//
// MATLAB Coder version            : 3.3
// C/C++ source code generated on  : 14-May-2017 01:59:14
//

// Include Files
#include "rt_nonfinite.h"
#include "add_awgn_noise.h"
#include "eml_rand_shr3cong_stateful.h"
#include "add_awgn_noise_data.h"

// Function Definitions

//
// Arguments    : void
// Return Type  : void
//
void eml_rand_shr3cong_stateful_init()
{
  int i0;
  for (i0 = 0; i0 < 2; i0++) {
    c_state[i0] = 362436069U + 158852560U * i0;
  }
}

//
// File trailer for eml_rand_shr3cong_stateful.cpp
//
// [EOF]
//
