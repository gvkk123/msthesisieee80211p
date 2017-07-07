%%
clc;
clear all;
close all;
%% Nakagami from Gamma;

N =1000000;

% Nakagami -(m,W);

% Nakagami to Gamma.
m = 1;
W = 1;

a = m;
b = W/m;

% Gamma Distribution.
% Generating Gamma R.V's:
G = gamrnd(a,b,[1 N]);

% Nakagami Distribution.
NK = sqrt(G);


step = 0.05;
x = 0:step:5;
h = hist(NK, x);  
approxPDF = h/(step*sum(h));

%% Theoritical
for ii = 1:length(x)
    y(ii)=((2*m^m)/(gamma(m)*W^m))*x(ii)^(2*m-1)*exp(-((m/W)*x(ii)^2));
end

%% Figures
figure
plot(x, approxPDF,'b*', x, y,'r');
title('Simulated and Theoretical Nakagami-m PDF');
legend('Simulated PDF','Theoretical PDF')  
xlabel('r --->');  
ylabel('P(r)---> ');  
grid;