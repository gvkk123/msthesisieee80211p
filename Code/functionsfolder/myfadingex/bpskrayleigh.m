%% BPSK RAYLEIGH

clc;
clear ;
close all;

%%
% Eb/N0 Vs BER for BPSK Modulation over Rayleigh Channel and AWGN

N=10^6; %Number of BPSK symbols to transmit  
d=rand(1,N)>0.5; %binary data  
x=2*d-1; %BPSK symbols 0->-1, 1->1  
EbN0dB=-5:2:20; %Range of Eb/N0 values

%%
simBER_rayleigh=zeros(1,length(EbN0dB));  
simBER_awgn=zeros(1,length(EbN0dB));

%%
for i=1:length(EbN0dB)
    
    %AWGN noise with mean=0  var=1 
    noise=1/sqrt(2)*(randn(1,N)+1i*randn(1,N));
    
    %Rayleigh Flat Fading factor- single tap 
    h=1/sqrt(2)*(randn(1,N)+1i*randn(1,N));
    
    %Scaling the noise for required Eb/N0  
    n = noise*10^(-EbN0dB(i)/20); 
    
     %received signal through AWGN channel  
    y_awgn=x+n;
    
    %received signal through Rayleigh channel
    y_rayleigh=h.*x+n;
    
    %Coherent Receiver for Rayleigh Channel  
    
    %Assuming that h is known at the signal  accurately
    y_rayleigh_cap=y_rayleigh./h; 
    
    %received symbols = 1 is real part > 0  or else it is 0
    r_rayleigh=real(y_rayleigh_cap)>0; 
    
    %Receiver for AWGN channel  
    r_awgn=real(y_awgn)>0;  
    
    
    simBER_rayleigh(i)=sum(xor(d,r_rayleigh)); 
    simBER_awgn(i)=sum(xor(d,r_awgn));
    
end

simBER_rayleigh=simBER_rayleigh/N;
simBER_awgn=simBER_awgn/N;

%%
%Theoretical BER;
EbN0=10.^(EbN0dB/10); %Eb/N0 in Linear Scale
theoretical_rayleigh=0.5*(1-sqrt(EbN0./(1+EbN0)));
theoretical_awgn=0.5*erfc(sqrt(EbN0));

%%
semilogy(EbN0dB,simBER_rayleigh,'g*-','LineWidth',2);hold on;  
semilogy(EbN0dB,simBER_awgn,'r*-','LineWidth',2);hold on;  
semilogy(EbN0dB,theoretical_rayleigh,'ko','LineWidth',2); hold on  
semilogy(EbN0dB,theoretical_awgn,'bo','LineWidth',2);
grid on;  
axis([-5 20 10^-5 1.2]);  
legend('Simulated Rayleigh','Simulated AWGN','Theoretical Rayleigh','Theoretical awgn');
title('Eb/N0 Vs BER for BPSK over Rayleigh and AWGN Channels');
xlabel('Eb/N0(dB)');
ylabel('Bit Error Rate or Symbol Error Rate');  