clc;
clear;
close all;

%%

prioity_mode = 1;

aCWmin = 15;
aCWmax = 1023;
aSlotTime = 13e-6;
aSIFSTime = 32e-6;

AIFS_N = 2;
CW_min = ((aCWmin+1)/4)-1;
CW_max = ((aCWmin+1)/2)-1;

%t_aifs = 58e-6;
T_AIFS = AIFS_N * aSlotTime + aSIFSTime;

%%

%BO = [0 1 2 3];
BO = randi([0 CW_min],1,1);
BO_T = aSlotTime * BO;

time_step = 1e-6;