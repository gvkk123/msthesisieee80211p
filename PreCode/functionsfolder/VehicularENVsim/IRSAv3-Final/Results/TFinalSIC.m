clc;
clear;
close all;

%%

figure

%%

%SA
g = 0:0.0001:1;
S_SA = g.*exp(-g);
PLR_SA = 1 - (S_SA./g);
semilogy(g,PLR_SA);
hold on

%%
clear
load('CRDSA_1Lakh_frames.mat');
semilogy(g,PLR);
hold on
%%
clear
load('IRSA 3packets20val2.mat');
semilogy(g,PLR);
hold on
%%
clear
load('BCSA_1Lakh_frames20val2.mat');
semilogy(g,PLR);
hold on

%%
clear
% Plot the estimated PER
grid on;
h = legend('slotted ALOHA,$\lambda(x)=x$','CRDSA,$\lambda(x)=x^2$','IRSA,$\lambda(x)=x^3$','IRSA-$\lambda(x)=0.86x^3+0.14x^8$','location','best');
set(h,'Interpreter','latex');
%h = legend('slotted ALOHA,\lambda(x)=x','CRDSA,\lambda(x)=x^2','IRSA,\lambda(x)=x^3','IRSA,\lambda(x)=0.86x^3+0.14x^8','location','best');
xlabel('Normalized Load - g[user/slot]');
ylabel('PLR');
title('Packet Loss Ratio vs Normalized Load, PEC ( \epsilon=0)');
%title('\textbf{Packet Loss Ratio vs Normalized Load,PEC}($\epsilon=0$)','interpreter','latex');
%%

% print('-deps','-r600','TFinalSICPLR.eps')

