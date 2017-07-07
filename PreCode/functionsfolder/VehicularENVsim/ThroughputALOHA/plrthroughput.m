clc;
clear;
close all;

%%
G = 0:0.0001:1;
A_T = G.*exp(-2.*G);
SA_T = G.*exp(-G);
plot(G,A_T,'color','k');
hold on;
plot(G,SA_T,'color','k');

legend('pure ALOHA ','slotted ALOHA','location','best');
grid on;
xlabel('Load(G)');
ylabel('Throughput(T)');
title('Throughput of pure and slotted ALOHA');

%%
figure
PLR_SA = 1 - (SA_T./G);
semilogy(G,PLR_SA,'color','k');
hold on;
PLR_A = 1 - (A_T./G);
semilogy(G,PLR_A,'--','color','k');

legend('pure ALOHA ','slotted ALOHA','location','best');
grid on;
xlabel('Load(G)');
ylabel('PLR');
title('Packet Loss Ratio vs Normalized Load');