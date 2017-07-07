%function [ out ] = rayleighfadingpathsim (PL_dB, fd, fm, spec_type)

% 1 . Tap No.
% 2 . Path No.
% 3 . Tap Power(dB)
% 4 . Relative Path Loss(dB)  -- PL_dB
% 5 . Delay Value(ns)
% 6 . Rician K(dB)  -- K_dB
% 7 . Frequency Shift(Hz)  -- fd
% 8 . Fading Doppler  -- fm
% 9 . LOS Doppler(Hz)
% 10. Modulation(Hz) : 1 - Rayleigh , 2 - Rician
% 11. Fading Spectral Shape : 1 - Classic 6 dB(C6)  --spec_type
%                             2 - Classic 3 dB(C3)
%                             3 - Round
%                             4 - Flat

%%
clc;
clear;
close all;                          

%%
% N is the number of frequency domain points.
N=6400;
% fm is the Doppler frequency in Hz.
fm=60;
% fs is the sampling frequency in Hz.
fs=20e6;
%Frequency Shift in Hz.
fd=0;
%Path Loss in dB
PL_dB = -30;

PL = 10^(PL_dB/10);

K_dB = -1.6;

K = 10^(K_dB/10);

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


%%

%Define bin steps and range for histogram plotting  
step = 0.1; 
range = 0:step:3;

%Get histogram values and approximate it to get the pdf curve  
h = hist(abs(G), range);  
%h = hist(r_norm, range);

approxPDF = h/(step*sum(h)); %Simulated PDF from the x and y samples  

%variance =0.5;

%Theoritical PDF from the Rayleigh Fading equation  
theoretical = (range/variance).*exp(-range.^2/(2*variance));  

figure
%p = raylpdf(range,sqrt(0.5));
%plot(range, p,'b*', range, theoretical,'r');  
plot(range, approxPDF,'b*', range, theoretical,'r');  
title('Simulated and Theoretical Rayleigh PDF for variance = 0.5');
legend('Simulated PDF','Theoretical PDF');
xlabel('r --->');  
ylabel('P(r)---> ');  
grid;

%%
% Generate Doppler Spectrum

% fm - Maximum Doppler Shift
% fd - Doppler Offset
% f - Frequency
% S - Normalized Doppler Spectrum

% Doppler Filter Types
% 1.Classic 6 dB(C6) - SPIRENT DEFINED
% 2.Classic 3 dB(C3) - SPIRENT DEFINED
% 3.Rounded(R) - SPIRENT DEFINED
% 4.Flat(F) - SPIRENT DEFINED
% 5.Classical Jakes - MATLAB DEFINED
% 6.Round(R) - MATLAB DEFINED
% 7.Flat(F) - MATLAB DEFINED
% 8.Youngs Model

a=1;
fd=0;
Rs=20e6;
Ts=1/Rs;
TPL = 1;
spec_type = 1;

%[S]=myDopplerFilter(fm,fd,a,df,1);
[S]=MatlabDopplerFilter(fm,fd,TPL,Rs,spec_type);

figure
s=(10*log10(S));
plot(s)
grid on;
xlabel('f/fm');
ylabel('power spectral density(dB)');
title('Normalized Doppler power spectral density');
% figure
% plot(fft(S));

% figure
% pwelch(10*log10(S));
% pxx = pwelch(fft(S,512),blackman(16),0,1024,512,'centered');
% plot(10*log10(pxx));
% % plot(20*log10(abs(ifft(S))));
% hold on;
% nu=0;
% Z=0:0.1:30;
% J = besselj(nu,Z);
% plot(Z/max(Z),20*log10(J));

%%
% Multiply square root of Doppler Spectrum with Gaussian random sequence
X=G.*sqrt(S);

% F_zero=zeros(1, round((M-N)/2));
% X=[F_zero, X, F_zero];

% Take IFFT
x=ifft(X);

% Rician Fading
r=abs(x);

% Normalized Fading
mean_r=sum(r)/length(r);
r_norm=r/mean_r;
%r=r/mean(r);    

%sum(r.*r)

%%

%Define bin steps and range for histogram plotting  
step = 0.1; 
range = 0:step:3;

%Get histogram values and approximate it to get the pdf curve  
h = hist(r_norm, range);  
%h = hist(r_norm, range);

approxPDF = h/(step*sum(h)); %Simulated PDF from the x and y samples  

%variance =0.5;

%Theoritical PDF from the Rayleigh Fading equation  
theoretical = (range/variance).*exp(-range.^2/(2*variance));  

figure
%p = raylpdf(range,sqrt(0.5));
%plot(range, p,'b*', range, theoretical,'r');  
plot(range, approxPDF,'b*', range, theoretical,'r');  
title('Simulated and Theoretical Rayleigh PDF for variance = 0.5');
legend('Simulated PDF','Theoretical PDF');
xlabel('r --->');  
ylabel('P(r)---> ');  
grid;

%%

% For Rayleigh
r_final = sqrt(PL) * r;

% For Ricican
thLOS = 0;
fdLOS = 1452;
K11 = (sqrt(K/K+1))*exp(1i*(2*pi*fdLOS + thLOS));
r_final = sqrt(PL) * ((r/sqrt(K+1)) + K11);
%end