clc;
clear;
close all;

%%
G = 0:0.1:2;
A_T = G.*exp(-2.*G);
SA_T = G.*exp(-G);
plot(G,A_T);
hold on;
plot(G,SA_T);

legend('pure ALOHA ','slotted ALOHA','location','best');
grid on;
xlabel('Load(G)');
ylabel('Throughput(T)');
title('Throughput of pure and slotted ALOHA');

%,'--','color','k'
%,'color','k'

print('-deps','-r600','plr.eps')
%%

