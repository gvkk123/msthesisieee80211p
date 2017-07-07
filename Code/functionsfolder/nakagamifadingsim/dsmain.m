
%%
clc;
clear all;
close all;
%%

% Transmitted Power, dBm
Pt_dBm = 30;

dataset_selector = 1;
d = 10:10:1000;

Pr_dBm_d = zeros(1,length(d));
for i = 1: length(d)
    %Pr_dB_d(i) = dualslopemodelfn2(Pt_dB,d(i),dataset_selector);
    Pr_dBm_d(i) = dualslopemodelfn(Pt_dBm,d(i));
end

%%

Pnoise_dBm = -99;
snrdB = Pr_dBm_d - Pnoise_dBm;

%%
figure
semilogx(d,snrdB);
title('SNR with Noise Power = -99dBm');
xlabel('distance[meters]');
ylabel('SNR[dB]');
grid on;


%%
figure
semilogx(d,Pr_dBm_d);
title('RSSI vs Distance');
xlabel('distance[meters]');
ylabel('received power[dBm]');
grid on;

%%

d1 = 100;

Num = 10000;
[N_RV] = nakagamimodelfn(Num,d1,Pt_dBm);