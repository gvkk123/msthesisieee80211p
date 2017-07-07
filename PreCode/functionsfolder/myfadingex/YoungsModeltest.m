clc; clear; close all;

%-------Input Section----------------------------------  
N=4096; %Number of sample points (N)  
%N is usually a power of 2  
Fm=50; %Maximum Doppler Frequency Shift
Fs=1000; %Sampling Frequency  
%%
%Baseband Gaussian Noise Generators  

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
C = G1-1i*G2;

% G1=randn(1,N);  
% G2=randn(1,N);
% C=G1-1i*G2;
%%
%Define Spectral characteristics of the Doppler effect in frequency domain 
%Fk  = Doppler Filter output  
Fk = dopplerFilter(Fm,Fs,N);  

%Multiply C by filter sequency Fk  
U = C.*Fk;  
NFFT = 2^nextpow2(length(U));  
u=abs(ifft(U,NFFT)); %Take IDFT  
normalizedFading = u/max(u); %Baseband Rayleigh envelope 

%%
figure
plot(10*log10(normalizedFading)) %plot command  
title(['Rayleigh Fading with doppler effect for Fm=',num2str(Fm),'Hz']);  
xlabel('Samples');  
ylabel('Rayleigh Fading envelope(dB)');  
axis([0 500 -20 2]); %showing only few samples for clarity  

%%
%Define bin steps and range for histogram plotting  
step = 0.1; range = 0:step:3;    

%Get histogram values and approximate it to get the pdf curve  
h = hist(normalizedFading, range);  
approxPDF = h/(step*sum(h)); %Simulated PDF from the x and y samples  

variance1 =0.07;

%Theoritical PDF from the Rayleigh Fading equation  
theoretical = (range/variance1).*exp(-range.^2/(2*variance1));  

figure
%p = raylpdf(range,sqrt(0.5));
%plot(range, p,'b*', range, theoretical,'r');  
plot(range, approxPDF,'b*', range, theoretical,'r');  
title('Simulated and Theoretical Rayleigh PDF for variance = 0.5');
legend('Simulated PDF','Theoretical PDF')  
xlabel('r --->');  
ylabel('P(r)---> ');  
grid;

%%

