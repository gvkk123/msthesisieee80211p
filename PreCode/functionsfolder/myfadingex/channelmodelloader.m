%function out = channelmodelloader (in)

clc;
clear;
close all;    

%V2VChannelModel1=load('V2VChannelModel1.mat');
%load('V2VChannelModel1.mat');

%% TABLE 2 V2V Channel Models for the Six Scenarios

% COLOUMN ORDER

% 1 . Tap No.
% 2 . Path No.
% 3 . Tap Power(dB)
% 4 . Relative Path Loss(dB)
% 5 . Delay Value(ns)
% 6 . Rician K(dB)
% 7 . Frequency Shift(Hz)
% 8 . Fading Doppler
% 9 . LOS Doppler(Hz)
% 10. Modulation(Hz) : 1 - Rayleigh , 2 - Rician
% 11. Fading Spectral Shape : 1 - Classic 6 dB(C6)
%                             2 - Classic 3 dB(C3)
%                             3 - Round
%                             4 - Flat

load('V2V1.mat');
% V2VChannelModel1 = ...
%   [1 1 0 0 0 -1.6 1451 60 1452 2 3;
%    1 2 0 -24.9 1 0 884 858 0 1 3;
%    1 3 0 -25.5 2 0 1005 486 0 1 3;
%    2 4 -6.3 -13.1 100 0 761 655 0 1 2;
%    2 5 -6.3 -7.5 101 0 1445 56 0 1 3;
%    3 6 -25.1 -28.9 200 0 819 823 0 1 2;
%    3 7 -25.1 -29.3 201 0 1466 75 0 1 4;
%    3 8 -25.1 -35.6 202 0 124 99 0 1 3;
%    4 9 -22.7 -25.7 300 0 1437 110 0 1 4;
%    4 10 -22.7 -34.4 301 0 552 639 0 1 2;
%    4 11 -22.7 -27.4 302 0 868 858 0 1 1];

%%

%path i

i=1;

% Relative Path Loss(dB)
PL_dB = V2VChannelModel1(i,4);

% Rician K(dB)
K_dB = V2VChannelModel1(i,6);

% Frequency Shift(Hz)
fd = V2VChannelModel1(i,7);

% Fading Doppler
fm = V2VChannelModel1(i,8);

%Fading Spectral Shape
spec_type = V2VChannelModel1(i,11);

%
N = 64;

[ r, r_norm ] = ricianfadingpathsim (N, PL_dB, K_dB, fd, fm, spec_type);

% %end