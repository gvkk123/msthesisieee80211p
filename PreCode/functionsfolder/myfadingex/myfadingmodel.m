%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RAYLEIGH FADING SIMULATOR BASED UPON YOUNG'S METHOD
% N is the number of frequency domain points
% M is the total number of points in the frequency domain
% fm is the Doppler frequency in Hz
% fs is the sampling frequency in Hz
% df is the step size in the frequency domain
% T is the Time Duration of fading waveform
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;
close all;                          

%%

N=64;
fm=70;
df=(2*fm)/(N-1);
fs=7.68e6;
M=round(fs/df);
T=1/df;
Ts=1/fs;                                

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

% G1=randn(1,N);  
% G2=randn(1,N);
% G=G1-1i*G2;
%%
% Generate Doppler Spectrum

% fm - Maximum Doppler Shift
% fd - Doppler Offset
% f - Frequency
% S - Normalized Doppler Spectrum

% Doppler Filter Types
% 1.Classical Jakes - MATLAB DEFINED
% 2.Round(R) - MATLAB DEFINED
% 3.Flat(F) - MATLAB DEFINED
% 4.Classic 6 dB(C6) - SPIRENT DEFINED
% 5.Classic 3 dB(C3) - SPIRENT DEFINED
% 6.Rounded(R) - SPIRENT DEFINED
% 7.Flat(F) - SPIRENT DEFINED

a=1;
fd=0;

[S]=myDopplerFilter(fm,fd,a,df,1);

figure
plot(10*log10(S));
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

% Rayleigh Fading
r=abs(x);

% Normalized Fading
mean_r=sum(r)/length(r);
r_norm=r/mean_r;
%r=r/mean(r);                        

%%
% Plot the Rayleigh envelope
figure
t=0:Ts:T-Ts;
plot(t,10*log10(r_norm));
xlabel('Time(sec)');
ylabel('Signal Amplitude (dB)');

%%
%Define bin steps and range for histogram plotting  
step = 0.1; 
range = 0:step:3;    

%Get histogram values and approximate it to get the pdf curve  
h = hist(r_norm, range);  
approxPDF = h/(step*sum(h)); %Simulated PDF from the x and y samples  

%variance1 =0.07;

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
[LCR, LCR_num, AFD, AFD_num] = mylcrafdcalc(r_norm, fm, T, Ts)