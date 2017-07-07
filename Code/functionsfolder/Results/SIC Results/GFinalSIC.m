clc;
clear;
close all;

%%

figure

%%
load('SIC G0.4 AWGN.mat');
semilogy(EbNoVec,PLR);
hold on
%%
clear
load('SIC G0.4 V2Vc1.mat');
semilogy(EbNoVec,PLR);
hold on
%%
load('SIC G0.4 V2Vc2.mat');
semilogy(EbNoVec,PLR);
hold on

%%
% Plot the estimated PER
grid on;
legend('AWGN','V2V Expressway Oncoming','V2V Urban Oncoming','location','best');
xlabel('EbNo (dB)');
ylabel('PLR');
title('Packet Loss Ratio at Normalized Load=0.4,QPSK,Rate-1/2,OFDM');
%%

% print('-deps','-r600','GFinalSIC.eps')

