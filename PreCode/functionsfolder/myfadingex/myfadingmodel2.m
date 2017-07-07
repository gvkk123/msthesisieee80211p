%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RAYLEIGH FADING SIMULATOR BASED UPON RAPPAPORT TEXTBOOK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;
close all;                          

%%
% N is the number of frequency domain points.
N=64;
% fm is the Doppler frequency in Hz.
fm=70;

% df is the step size in the frequency domain
df=(2*fm)/(N-1);
% T is the Time Duration of fading waveform
T=1/df;
%%

% fs is the sampling frequency in Hz.
fs=7.68e6;

M=round(fs/df);

Ts=1/fs;                                

%%
% Generate two sequences of N complex Gaussian random variables 
% g11=randn(1,N/2)+1i*randn(1,N/2);
% gc11=conj(g11);
% G1=[fliplr(gc11), g11];                                  
%  
% g22=randn(1,N/2)+1i*randn(1,N/2);
% gc22=conj(g22);
% G2=[fliplr(gc22), g22];                 

%%
% Generate two sequences of N complex Gaussian random variables

%Mean of Gaussian random variables  
mean = 0; 
%Variance of Gaussian random variables  
variance = 0.5;
%Standard Deviation of Gaussian RV  
sdev = sqrt(variance); 

%N i.i.d Gaussian random samples
rv1 = mean + sdev.*randn(1,N/2) ;   
rv2 = mean + sdev.*randn(1,N/2) ;
rv3 = mean + sdev.*randn(1,N/2) ;   
rv4 = mean + sdev.*randn(1,N/2) ;

g11=rv1+1i*rv2;
gc11=conj(g11);
G1=[fliplr(gc11), g11];                                  
 
g22=rv3+1i*rv4;
gc22=conj(g22);
G2=[fliplr(gc22), g22]; 

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
% Multiply the complex sequences with the Doppler Spectrum S, take IFFT
% X=G1.*sqrt(S);
% X=[zeros(1,round((M-N)/2)), X, zeros(1,round((M-N)/2))];
% x=abs(ifft(X,M));                             
%  
% Y=G2.*sqrt(S);
% Y=[zeros(1,round((M-N)/2)), Y, zeros(1,round((M-N)/2))];
% y=abs(ifft(Y,M));                             
% 
% % Find the resulting Rayleigh faded envelope
% z=x+1i*y;
% r=abs(z);                       
% 
% t=0:Ts:T-Ts;
% figure
% plot(t,10*log10(r/mean(r)),'r');
% xlabel('Time(sec)');
% ylabel('Envelope (dB)');

%%
% Multiply the complex sequences with the Doppler Spectrum S, take IFFT
X=G1.*sqrt(S);
Y=G2.*sqrt(S);

% X1=[zeros(1,round((M-N)/2)), X, zeros(1,round((M-N)/2))];
% Y1=[zeros(1,round((M-N)/2)), Y, zeros(1,round((M-N)/2))];

x=abs(ifft(X,M));
y=abs(ifft(Y,M));

z=x.^2+y.^2;

% Rayleigh Fading
r=sqrt(z);

% Normalized Fading
mean_r=sum(r)/length(r);
r_norm=r/mean_r;

%%
% Plot the Rayleigh envelope
figure
t=0:Ts:T-Ts;
plot(t,10*log10(r_norm),'r');
xlabel('Time(sec)');
ylabel('Envelope (dB)');

%%

%Define bin steps and range for histogram plotting  
step = 0.1; 
range = 0:step:3;

%Get histogram values and approximate it to get the pdf curve  
h = hist(r_norm, range);  
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
[LCR_Meas, LCR_Th, AFD_Meas, AFD_Th] = mylcrafdcalc(r_norm, fm, T, Ts)