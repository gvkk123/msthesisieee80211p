%%
clc;
clear ;
close all;

%%
% Add path (at beginning of script)
added_path = [pwd,'/functionsfolder'];
%change to: added_path = '/path' for your required path
addpath(added_path);

%% PARAMETERS

% Defining Modulation Type
rateid = 3;

% Defining Packet Size in Bytes
PacketSize = 400;

temp1 = 0.05:0.05:0.95;

user_density = floor(temp1*172);
% user_density = 153;
% user_density = [17,34,51,68,85,102,119,136,153];
%user_density = 17:17:153;

% Degree Distribution : Lambda(x) = 0.86*x^3 + 0.14*x^8

%%
%Number of Iterations:
N = 1;

% Pre-Allocations:
PLR = zeros(1,length(user_density));
    
%% PLR SIM

parfor i = 1:length(user_density)
    weight1 = 0;
    Total = 0;
    
    for j = 1:N
        [weight,loss_ratio] = PLRAnalysis(user_density(i),rateid,PacketSize);
        weight1 = weight1 + weight;
        Total = Total + user_density(i);
    end
    PLR(i) = 1 - (weight1/Total);
    i
end

%% PLOTS
%PLR
g = user_density/172;

figure
semilogy(g,PLR);
grid on;
xlabel('Normalized Load - g[user/slot]');
ylabel('PLR');
legend('B-CSA, n=172');
title('Packet Loss Ratio vs Normalized Load,QPSK,Rate-1/2,OFDM');

%Throughput

figure
S_DSA = g.*(1-PLR);
S_SA = g.*exp(-g);
plot(g,S_DSA);
grid on;
hold on;
plot(g,S_SA);
xlabel('Normalized Load - g[user/slot]');
ylabel('Throughput(T)');
legend('B-CSA, n=172 ','Slotted ALOHA','location','best');
title('Throughput vs Normalized Load,QPSK,Rate-1/2,OFDM');

%%

%legend('B-CSA,n=172,AWGN,EbNo-10dB','B-CSA,n=172,V2Von,EbNo-10dB','B-CSA,n=172,V2Von,EbNo-15dB','location','best');

%%
% Remove path (at end of script/script clean-up)
rmpath(added_path);