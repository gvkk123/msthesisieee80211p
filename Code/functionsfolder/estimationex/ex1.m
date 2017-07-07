% ex1
%channel_estimation.m
% for LS/DFT Channel Estimation with linear/spline interpolation
clc; clear all; close all;

Nfft=32; 
Ng=Nfft/8; 
Nofdm=Nfft+Ng; 
Nsym=100;
Nps=4; 
Np=Nfft/Nps; % Pilot spacing and number of pilots per OFDM symbol

RX = zeros(64,1);