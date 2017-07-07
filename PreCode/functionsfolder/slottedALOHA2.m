%%
clc;
clear ;
close all;

%% PARAMETERS

% Defining Modulation Type
rateid = 3;

% Defining Packet Size in Bytes
PacketSize = 400;

% Defining Channel load
g = 0.4;
user_density = floor(g*172);
%user_density = [17,34,51,68,85,102,119,136,153];
%user_density = 17:17:153;

EbNoVec = (1:12)';
% Degree Distribution : Lambda(x) = 0.86*x^3 + 0.14*x^8

%%
%Number of Iterations:
N = 100;

% Pre-Allocations:
PLR = zeros(1,length(user_density));
    
%% PLR SIM

parfor i = 1:length(EbNoVec)
    weight1 = 0;
    Total = 0;
    
    for j = 1:N
        [weight,loss_ratio] = PLRAnalysis2(user_density,EbNoVec(i),rateid,PacketSize);
        weight1 = weight1 + weight;
        Total = Total + user_density;
    end
    PLR(i) = 1 - (weight1/Total);
    i
end

%% PLOTS
%PLR
g = user_density/172;

figure
semilogy(EbNoVec,PLR);
grid on;
xlabel('EbNo');
ylabel('PLR');
legend('B-CSA, n=172');
title('Packet Loss Ratio vs EbNo,QPSK,Rate-1/2,OFDM');

%Throughput

figure
S_DSA = g.*(1-PLR);
%S_SA = g.*exp(-g);
plot(EbNoVec,S_DSA);
grid on;
%hold on;
%plot(g,S_SA);
xlabel('EbNo');
ylabel('Throughput(T)');
legend('B-CSA, n=172 ','location','best');
title('Throughput vs EbNo,QPSK,Rate-1/2,OFDM');

%%

%legend('B-CSA,n=172,AWGN,EbNo-10dB','B-CSA,n=172,V2Von,EbNo-10dB','B-CSA,n=172,V2Von,EbNo-15dB','location','best');
