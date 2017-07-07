clc;
clear;
close all;

%%

figure

%%

%SA
g = 0:0.001:1;
S_SA = g.*exp(-g);
plot(g,S_SA);
hold on

%%
clear
load('CRDSA_1Lakh_frames.mat');
S_DSA = g.*(1-PLR);
plot(g,S_DSA);
hold on

%%
clear
load('IRSA 3packets20val2.mat');
S_DSA = g.*(1-PLR);
plot(g,S_DSA);
hold on
%%
load('BCSA_1Lakh_frames20val2.mat');
S_DSA = g.*(1-PLR);
plot(g,S_DSA);
hold on

%%
% Plot the estimated PER
grid on;
h = legend('slotted ALOHA,$\lambda(x)=x$','CRDSA,$\lambda(x)=x^2$','IRSA,$\lambda(x)=x^3$','IRSA-$\lambda(x)=0.86x^3+0.14x^8$','location','best');
set(h,'Interpreter','latex');
xlabel('Normalized Load - g[user/slot]');
ylabel('Throughput(T)');
title('Throughput vs Normalized Load, PEC ( \epsilon=0)');
%title('\textbf{Throughput vs Normalized Load,PEC}($\epsilon=0$)','interpreter','tex');
%%

% print('-deps','-r600','TFinalSICTHRPT.eps')
% print('-dsvg','-r600','TFinalSICTHRPT.svg')

