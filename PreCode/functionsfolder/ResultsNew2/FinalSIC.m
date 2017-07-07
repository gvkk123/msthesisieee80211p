clc;
clear;
close all;

%%

figure

%%
load('AWGNEbN010dB.mat');
semilogy(g,PLR);
hold on
%%
clear
load('V2Vc1EbN010dB.mat');
semilogy(g,PLR);
hold on
%%
clear
load('V2Vc2EbN010dB.mat');
semilogy(g,PLR);
hold on

%%
clear
load('V2Vc4EbN010dB.mat');
semilogy(g,PLR);
hold on

%%
% Plot the estimated PER
grid on;
legend('AWGN','V2V Expressway Oncoming','V2V Urban Oncoming','RTV Urban Canyon','location','best');
xlabel('Normalized Load - g[user/slot]');
ylabel('PLR');
title('Packet Loss Ratio vs Normalized Load, QPSK, Rate-1/2, OFDM');
%%

% print('-deps','-r600','FinalSIC.eps')

