clc;
clear;
close all;

%%
% 3.RTV Expressway
% 4.RTV Urban Canyon
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
load('SIC EbNo10 V2Vc3.mat');
S_DSA = g.*(1-PLR);
plot(g,S_DSA);
hold on
%%
load('SIC EbNo10 V2Vc4.mat');
S_DSA = g.*(1-PLR);
plot(g,S_DSA);
hold on

%%
% Plot the estimated PER
grid on;
legend('Slotted ALOHA-Theoritical','AWGN','RTV Urban Canyon','location','best');
xlabel('Normalized Load - g[user/slot]');
ylabel('Throughput(T)');
title('Throughput vs Normalized Load,QPSK,Rate-1/2,OFDM');
%%

% print('-deps','-r600','FinalSICTHRPT2.eps')

