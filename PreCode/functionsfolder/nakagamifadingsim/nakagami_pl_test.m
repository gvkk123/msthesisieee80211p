%%
clc;
clear all;
close all;
%%
% Transmitted Power, dBm
Pt_dBm = 30;

Num = 10000;

dist = 100;

[Pr_dBm_d,H_Nakagami_pl] = nakagami_pl_modelfn(Pt_dBm,Num,dist);