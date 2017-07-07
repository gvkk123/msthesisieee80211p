clc;
clear;
close all;

%%

figure

%%
load('SIC EbNo10 AWGN.mat');
semilogy(g,PLR);
hold on
%%
clear
load('SIC EbNo10 V2Vc1.mat');
semilogy(g,PLR);
hold on
%%
load('SIC EbNo10 V2Vc2.mat');
semilogy(g,PLR);
hold on

%%
% Plot the estimated PER
grid on;
legend('AWGN','V2V Expressway Oncoming','V2V Urban Oncoming','location','best');
xlabel('Normalized Load - g[user/slot]');
ylabel('PLR');
title('Packet Loss Ratio vs Normalized Load,QPSK,Rate-1/2,OFDM');
%%

% print('-deps','-r600','FinalSIC.eps')

