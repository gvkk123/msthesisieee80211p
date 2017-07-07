%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB BASED MULTIPATH FADING CHANNEL SIMULATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;
close all;                          

%%
% N is the number of frequency domain points.
N=10000;
% fm is the Doppler frequency in Hz.
fm=70;
% fs is the sampling frequency in Hz.
Rs=20e6;
Ts=1/Rs;
%%

% Defining Mean for Gaussian RV's
m1 = 0; m2 = 0;
Var = 0.5;

% Defining SD for Gaussian RV's
SD = sqrt(Var);

% In-phase Noise components  
G1 = m1 + SD.*randn(1,N) ; %N i.i.d Gaussian random samples

% Quadrature-phase Noise components  
G2 = m2 + SD.*randn(1,N) ; %N i.i.d Gaussian random samples

G = G1-1i*G2;
%%

%Define bin steps and range for histogram plotting  
step = 0.1; 
range = 0:step:3;    

%Get histogram values and approximate it to get the pdf curve  
h = hist(abs(G), range);  
approxPDF = h/(step*sum(h)); %Simulated PDF from the x and y samples  

%variance1 =0.07;

%Theoritical PDF from the Rayleigh Fading equation  
theoretical = (range/Var).*exp(-range.^2/(2*Var));   

figure
%p = raylpdf(range,sqrt(0.5));
%plot(range, p,'b*', range, theoretical,'r');  
plot(range, approxPDF,'b*', range, theoretical,'r');  
title('Simulated and Theoretical Rician PDF for variance = 0.5');
legend('Simulated PDF','Theoretical PDF');
xlabel('r --->');  
ylabel('P(r)---> ');  
grid;