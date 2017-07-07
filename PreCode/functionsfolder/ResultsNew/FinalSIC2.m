clc;
clear;
close all;

%%
% 3.RTV Expressway
% 4.RTV Urban Canyon
figure

%%
load('SIC EbNo10 AWGN.mat');
semilogy(g,PLR);
hold on
%%
clear
load('SIC EbNo10 V2Vc3.mat');
semilogy(g,PLR);
hold on
%%
load('SIC EbNo10 V2Vc4.mat');
semilogy(g,PLR);
hold on

%%
% Plot the estimated PER
grid on;
legend('AWGN','RTV Urban Canyon','location','best');
xlabel('Normalized Load - g[user/slot]');
ylabel('PLR');
title('Packet Loss Ratio vs Normalized Load,QPSK,Rate-1/2,OFDM');
%%

% print('-deps','-r600','FinalSIC2.eps')

