%%
clc;
clear all;
close all;
%% Main
% % Transmitted Power, dBm
% Pt_dBm = 20;
% Num = 10000;
% 
% dist = 100;
% 
% dataset_selector = 1;
% 
% [Pr_dBm_d,H_Nakagami_pl] = nakagami_pl_modelfn2(Pt_dBm,Num,dist,dataset_selector);


%% For PL curves

% Transmitted Power, dBm
Pt_dBm = 20;
PN_dBm = -99;
Num = 1000;

dist = 1:1:1000;

dataset_selector = 1;

for i = 1:length(dist)
    [Pr_dBm_d(i),H_Nakagami_pl] = nakagami_pl_modelfn2(Pt_dBm,Num,dist(i),dataset_selector);
end

%% Figures

figure
semilogx(dist,Pr_dBm_d,'Color','k');
hold on;
semilogx(dist,(PN_dBm.*ones(1,length(dist))),'Color','k');
legend('Dual slope PL Model + Nakagami fading + Shadowing ','Noise Power = -99dBm','location','best');
grid on;
xlabel('Distance between transmitter and receiver(m)');
ylabel('Received signal strength,Pr(dBm)');
title('RSSI vs. Distance');

figure
snr_d = Pr_dBm_d +99;
semilogx(dist,snr_d,'Color','k');
legend('Dual slope PL Model + Nakagami fading + Shadowing ','location','best');
grid on;
xlabel('Distance between transmitter and receiver(m)');
ylabel('SNR(dBm)');
title('SNR vs. Distance');

% print('-deps','-r600','RSSI1pt20pn99.eps')