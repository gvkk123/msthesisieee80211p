clc;
clear;
close all;

%%

figure

%%
load('PER QPSK AWGN pCSI.mat');
semilogy(EbNoVec,PEREst);
hold on
%%
clear
load('PER QPSK V2Vc1 pCSI.mat');
semilogy(EbNoVec,PEREst);
hold on
%%
clear
load('PER QPSK V2Vc2 pCSI.mat');
semilogy(EbNoVec,PEREst);
hold on
%%
clear
load('PER QPSK V2Vc3 pCSI.mat');
semilogy(EbNoVec,PEREst);
hold on
%%
clear
load('PER QPSK V2Vc4 pCSI.mat');
semilogy(EbNoVec,PEREst);
hold on
%%
% Plot the estimated PER
clear
grid on;
legend('AWGN','V2V Expressway Oncoming','V2V Urban Oncoming','RTV Expressway','RTV Urban Canyon','location','southwest');
xlabel('Eb/No (dB)');
ylabel('Packet Error Rate');
title('Packet Error Rate curves for PSDU Length of 400 bytes');

%%

print('-deps','-r600','PERALL.eps')
print('-dsvg','-r600','PERALL1.svg')
