%----Rayleigh_PDF-----------------------------------------  
%----------Input Section----------------  
clc;clear;close all;

%%
N=1000000; %Number of samples to generate  
variance = 0.2; % Variance of underlying Gaussian random variables  

%%
% %Independent Gaussian random variables with zero mean and unit variance  
% x = randn(1, N);  
% y = randn(1, N);    
% 
% %Rayleigh fading envelope with the desired variance  
% r = sqrt(variance*(x.^2 + y.^2));    

%%

% Generate 2xN i.i.d zero mean Gaussian variates

%Mean of Gaussian random variables  
mean = 0; 
%Variance of Gaussian random variables  
variance = 0.5;
%Standard Deviation of Gaussian RV  
sdev = sqrt(variance); 

%In-phase Noise components  
G1 = mean + sdev.*randn(1,N) ; %N i.i.d Gaussian random samples  
%Quadrature-phase Noise components  
G2 = mean + sdev.*randn(1,N) ; %N i.i.d Gaussian random samples  
G=G1-1i*G2;                              

r=abs(G);
% G1=randn(1,N);  
% G2=randn(1,N);
% G=G1-1i*G2;

%%
%Define bin steps and range for histogram plotting  
step = 0.1; range = 0:step:3;    

%Get histogram values and approximate it to get the pdf curve  
h = hist(r, range);  
approxPDF = h/(step*sum(h)); %Simulated PDF from the x and y samples  

%Theoritical PDF from the Rayleigh Fading equation  
theoretical = (range/variance).*exp(-range.^2/(2*variance));  

plot(range, approxPDF,'b*', range, theoretical,'r');  
title('Simulated and Theoretical Rayleigh PDF for variance = 0.5');
legend('Simulated PDF','Theoretical PDF')  
xlabel('r --->');  
ylabel('P(r)---> ');  
grid;

%%
%PDF of phase of the Rayleigh envelope  
%theta = atan(y./x);  
theta = atan(G2./G1);
figure(2)  
hist(theta); %Plot histogram of the phase part  

%Approximate the histogram of the phase part to a nice PDF curve  
[counts,range] = hist(theta,100);  
step=range(2)-range(1);  
%Normalizing the PDF to match theoretical curve  
approxPDF = counts/(step*sum(counts)); 
%Simulated PDF from the x and y  samples  
bar(range, approxPDF,'b');  
hold on  
plotHandle=plot(range, approxPDF,'r');  
set(plotHandle,'LineWidth',3.5);  
axis([-2 2 0 max(approxPDF)+0.2])  
hold off  

title('Simulated PDF of Phase of Rayleigh Distribution ');  
xlabel('\theta --->');  
ylabel('P(\theta) --->');  
grid;  