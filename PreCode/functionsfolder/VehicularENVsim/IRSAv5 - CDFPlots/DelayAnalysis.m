%%
clc;
clear ;
close all;

%% PARAMETERS

user_density = 170;

%user_density = 17:17:170;

% Degree Distribution : Lambda(x) = 0.86*x^3 + 0.14*x^8 

%% PARAMETERS

%user_density = 50;
% Degree Distribution : Lambda(x) = 0.86*x^3 + 0.14*x^8 

dpack = 400*8;
prmTIMING = ieee80211p_TIMING(dpack);

%% CHANNEL ACCESS DELAY CALCULATIONS FOR IRSA

DelayCellIRSA = delayframegenIRSA(prmTIMING,user_density);

% print('-deps','-r600','CDFPlotIRSA.eps')
%% CHANNEL ACCESS DELAY CALCULATIONS FOR CSMA/CA

% DelayCellCSMA = delayframegenCSMA(prmTIMING,user_density);
