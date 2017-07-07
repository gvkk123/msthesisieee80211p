clc;
clear;
close all;

%%

figure

%%
load('SIC G0.4 AWGN.mat');

%SA
%S_SA = g.*exp(-g);
%plot(g,S_SA);

%hold on

S_DSA = g.*(1-PLR);
plot(EbNoVec,S_DSA);
hold on

%%
clear
load('SIC G0.4 V2Vc1.mat');
S_DSA = g.*(1-PLR);
plot(EbNoVec,S_DSA);
hold on
%%
load('SIC G0.4 V2Vc2.mat');
S_DSA = g.*(1-PLR);
plot(EbNoVec,S_DSA);
hold on

%%
% Plot the estimated PER
grid on;
legend('AWGN','V2V Expressway Oncoming','V2V Urban Oncoming','location','best');
xlabel('EbNo (dB)');
ylabel('Throughput(T)');
title('Throughput at Normalized Load=0.4,QPSK,Rate-1/2,OFDM');
%%

% print('-deps','-r600','GFinalSICTHRPT.eps')

