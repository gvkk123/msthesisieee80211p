%%
clc;
clear ;
close all;

%% PARAMETERS

%user_density = 50;

user_density = 17:17:170;

% Degree Distribution : Lambda(x) = 0.86*x^3 + 0.14*x^8 

%%
%Number of Iterations:
N = 1000;

% Pre-Allocations:
PLR = zeros(1,length(user_density));
    
%%

for i = 1:length(user_density)
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
%%

g = user_density/172;

figure
semilogy(g,PLR);
grid on;
xlabel('g[user/slot]');
ylabel('PLR');
legend('B-CSA, n=172');