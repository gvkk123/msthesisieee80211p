%%
clc;
clear ;
close all;

%% PARAMETERS

%user_density = 50;

%user_density = 17:17:170;

temp1 = 0.05:0.05:0.95;

user_density = floor(temp1*172);

% Degree Distribution : Lambda(x) = 0.86*x^3 + 0.14*x^8 

%%
%Number of Iterations:
N = 100000;

% Pre-Allocations:
PLR = zeros(1,length(user_density));
    
%% PLR SIM

parfor i = 1:length(user_density)
    weight1 = 0;
    Total = 0;
    
    for j = 1:N
        [weight,loss_ratio] = PLRAnalysis(user_density(i));
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
semilogy(g,PLR,'color','k');
grid on;
xlabel('Normalized Load - g[user/slot]');
ylabel('PLR');
legend('IRSA, n=172');
title('Packet Loss Ratio vs Normalized Load');

%%
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
legend('IRSA, n=172 ','Slotted ALOHA','location','best');
title('Throughput vs Normalized Load');
