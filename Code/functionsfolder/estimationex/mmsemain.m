% mmsemain fn

%%
clc;
clear all;
close all;
%%
load('tx1.mat');
load('tx2.mat');

load('rx1.mat');
load('rx2.mat');

X = txlts1;
Y = rxlts1;

%%
[H_LMMSE,SNR_est, nVar_est] = mmseestfn(X,Y);

%%

Y1 = H_LMMSE.*X;