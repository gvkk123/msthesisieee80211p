% M=number of multi-paths in the fading channel, 
% N = number of samples to  generate, 
% fd=maximum Doppler spread in Hz, 
% TS = sampling period.    

% File_1: rayleighFading.m    

function [h]=rayleighFading(M,N,fd,Ts)  
% function to generate Rayleigh Fading samples based on Clarke's model  
% M = number of multi-paths in the channel  
% N = number of samples to generate  

% fd = maximum Doppler frequency  
% Ts = sampling period  
a=0;  
b=2*pi;  
alpha=a+(b-a)*rand(1,M); %uniformly distributed from 0 to 2 pi  
beta=a+(b-a)*rand(1,M); %uniformly distributed from 0 to 2 pi  
theta=a+(b-a)*rand(1,M); %uniformly distributed from 0 to 2 pi  

m=1:M;  

for n=1:N;  
    x=cos(((2.*m-1)*pi+theta)/(4*M));  
    h_re(n)=1/sqrt(M)*sum(cos(2*pi*fd*x*n'*Ts+alpha));  
    h_im(n)=1/sqrt(M)*sum(sin(2*pi*fd*x*n'*Ts+beta));  
end

h=h_re+j*h_im;

end