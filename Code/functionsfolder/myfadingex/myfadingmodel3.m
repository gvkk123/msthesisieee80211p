%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RICIAN FADING SIMULATOR BASED UPON RAPPAPORT TB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;
close all;                          

%%
% N is the number of frequency domain points.
N=64;
% fm is the Doppler frequency in Hz.
fm=60;
% Rician K(dB)
K_dB=-1.6;
%K_dB=-Inf;
%Rician K - factor; For Rayleigh Fading K=0
K=10^(K_dB/10);
% fs is the sampling frequency in Hz.
fs=20e6;

%%
% df is the step size in the frequency domain
df=(2*fm)/(N-1);
% M is the total number of points in the frequency domain
M=round(fs/df);
% T is the Time Duration of fading waveform
T=1/df;
Ts=1/fs;

% Non-Centrality Parameter - m
m = sqrt(K/(K+1));
variance = 1/(2*(K+1));
%%

% Generate 2xN i.i.d zero mean Gaussian variates

%Mean of Gaussian random variables  
mean = 0; 
%Variance of Gaussian random variables  
%variance = 0.5;
%Standard Deviation of Gaussian RV  
sdev = sqrt(variance); 

%In-phase Noise components  
G1 = m + sdev.*randn(1,N) ; %N i.i.d Gaussian random samples  
%Quadrature-phase Noise components  
G2 = mean + sdev.*randn(1,N) ; %N i.i.d Gaussian random samples  
G=G1-1i*G2;                              

% G1=randn(1,N);  
% G2=randn(1,N);
% G=G1-1i*G2;

%%

%Define bin steps and range for histogram plotting  
step = 0.1; 
range = 0:step:3;    

%Get histogram values and approximate it to get the pdf curve  
h = hist(abs(G), range);  
approxPDF = h/(step*sum(h)); %Simulated PDF from the x and y samples  

%variance1 =0.07;

% Theoritical PDF from the Rician Fading equation
%I = besseli(nu,Z)
b=besseli(0, (range.*m)./variance);
theoretical = (range/variance).*exp(-((range.^2)+(m.^2))/(2*variance)).*b;  

figure
%p = raylpdf(range,sqrt(0.5));
%plot(range, p,'b*', range, theoretical,'r');  
plot(range, approxPDF,'b*', range, theoretical,'r');  
title('Simulated and Theoretical Rician PDF for variance = 0.5');
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

[S]=myDopplerFilter(fm,fd,a,df,1);

figure
plot(10*log10(S));
grid on;
xlabel('f/fm');
ylabel('power spectral density(dB)');
title('Normalized Doppler power spectral density');
% figure
% plot(fft(S));

% figure
% pwelch(S);
% % plot(20*log10(abs(ifft(S))));
% hold on;
% nu=0;
% Z=0:0.1:30;
% J = besselj(nu,Z);
% plot(Z/max(Z),20*log10(J));

%%
% Multiply square root of Doppler Spectrum with Gaussian random sequence
X=G.*sqrt(S);

F_zero=zeros(1, round((M-N)/2));
X=[F_zero, X, F_zero];

% Take IFFT
x=ifft(X,M);

% Rician Fading
r=abs(x);

% Normalized Fading
mean_r=sum(r)/length(r);
r_norm=r/mean_r;
%r=r/mean(r);                        

%%
% Plot the Rician envelope
figure
t=0:Ts:T-Ts;
plot(t,10*log10(r_norm));
xlabel('Time(sec)');
ylabel('Signal Amplitude (dB)');

%%
[LCR_Meas, LCR_Th, AFD_Meas, AFD_Th] = mylcrafdcalc(r_norm, fm, T, Ts)

