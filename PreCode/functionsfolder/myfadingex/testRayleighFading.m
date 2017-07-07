% A test program is coded which uses the above mentioned function is used  
% to generate Rayleigh Fading samples with the following values for the 
% function  arguments. 

% M=15; N=10^5; fd=100 Hz;Ts=0.0001 second;  

clc;clear;

M=15; %number of multipaths  
N=10^5; %number of samples to generate  
fd=100; % Maximum doppler spread in hertz  
Ts=0.0001; % Sampling period in seconds  

h=rayleighFading(M,N,fd,Ts);  
h_re=real(h);  
h_im=imag(h);  

figure; 

subplot(2,1,1);  
plot([0:N-1]*Ts,h_re);  
title('Real part of impulse response of the Flat Fading channel');  
xlabel('time(s)');
ylabel('Amplitude |hI(t)|');  

subplot(2,1,2);  
plot([0:N-1]*Ts,h_im);  
title('Imaginary part of impulse response of the Flat Fading channel');  
xlabel('time(s)');
ylabel('Amplitude |hQ(t)|');  

figure;  

subplot(2,1,1);  
plot([0:N-1]*Ts,10*log10(abs(h)));  
title('Amplitude Response of the Flat Fading channel');  
xlabel('time(s)');
ylabel('Magnitude |h(t)|');  

subplot(2,1,2);  
plot([0:N-1]*Ts,angle(h));  
title('Phase response of the Flat Fading channel');  
xlabel('time(s)');
ylabel('Phase angle(h(t))');  

%Statistical properties  
mean_re=mean(h_re)  
mean_im=mean(h_im)  
var_re=var(h_re)  
var_im=var(h_im)  

% Comparing the PDF of real part of generated samples against the PDF of  
% Gaussian distribution  

[val,bin]=hist(h_re,1000); 
% pdf of real part of generated Raleigh Fading Sam-  ples  

figure;  
plot(bin,val/trapz(bin,val)); 
% Normalizing the PDF to match theoretical result  
% Trapz function gives the total area under the PDF curve. 
% It is used as the  normalization factor  
hold on;
x=-2:0.1:2;  
y=normpdf(x,0,sqrt(0.5)); 
% theoretical gaussian pdf  
plot(x,y,'r');  
title('Probability density function');  
legend('Simulated pdf','Theoretical Gaussian pdf');  

figure;  
% comparing the PDF of overal response of the channel against the PDF 
% of  Rayleigh distribution  
[val,bin]=hist(abs(h),1000); 
% pdf of generated Raleigh Fading samples  
plot(bin,val/trapz(bin,val)); 
%Normalizing the PDF to match theoretical result  
%Trapz function gives the total area under the PDF curve. 
%It is used as the  normalization factor  
hold on;  
z=0:0.1:3; 
sigma=1;  
y=2*z/(sigma^2).*exp(-z.^2/(sigma^2)); % theoretical Raleigh pdf  
plot(z,y,'r');  
title('Probability density function');  
legend('Simulated pdf','Theoretical Rayleigh pdf');  

% Investigation of Statistical Properties of samples generated using 
% Clarke’s  model:  
