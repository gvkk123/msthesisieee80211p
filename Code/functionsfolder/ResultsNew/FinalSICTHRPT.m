clc;
clear;
close all;

%%

figure

%%
load('SIC EbNo10 AWGN.mat');

%SA
S_SA = g.*exp(-g);
plot(g,S_SA);

hold on

S_DSA = g.*(1-PLR);
plot(g,S_DSA);
hold on

%%
clear
load('SIC EbNo10 V2Vc1.mat');
S_DSA = g.*(1-PLR);
plot(g,S_DSA);
hold on
%%
load('SIC EbNo10 V2Vc2.mat');
S_DSA = g.*(1-PLR);
plot(g,S_DSA);
hold on

%%
% Plot the estimated PER
grid on;
legend('Slotted ALOHA-Theoritical','AWGN','V2V Expressway Oncoming','V2V Urban Oncoming','location','best');
xlabel('Normalized Load - g[user/slot]');
ylabel('Throughput(T)');
title('Throughput vs Normalized Load,QPSK,Rate-1/2,OFDM');
%%

% print('-deps','-r600','FinalSICTHRPT.eps')

