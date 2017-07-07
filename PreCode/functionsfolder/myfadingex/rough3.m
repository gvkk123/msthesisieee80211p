%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RAYLEIGH FADING SIMULATOR BASED UPON SMITH'S METHOD
% N is the number of paths
% M is the total number of points in the frequency domain
% fm is the Doppler frequency in Hz
% fs is the sampling frequency in Hz
% df is the step size in the frequency domain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;                          
 
N=10;
fm=300;
df=(2*fm)/(N-1);
fs=7.68e6;
M=round(fs/df);
T=1/df;
Ts=1/fs;                                
 
% Generate two sequences of N complex Gaussian random variables 
g=randn(1,N/2)+j*randn(1,N/2);
gc=conj(g);
g1=[fliplr(gc), g];                                  
 
g=randn(1,N/2)+j*randn(1,N/2);
gc=conj(g);
g2=[fliplr(gc), g];                 
 
% Generate Doppler Spectrum S
f=-fm:df:fm;
S=1.5./(pi*fm*sqrt(1-(f/fm).^2));
S(1)=2*S(2)-S(3);
S(end)=2*S(end-1)-S(end-2);   
 
% Multiply the complex sequences with the Doppler Spectrum S, take IFFT
X=g1.*sqrt(S);
X=[zeros(1,round((M-N)/2)), X, zeros(1,round((M-N)/2))];
x=abs(ifft(X,M));                             
 
Y=g2.*sqrt(S);
Y=[zeros(1,round((M-N)/2)), Y, zeros(1,round((M-N)/2))];
y=abs(ifft(Y,M));                             
 
% Find the resulting Rayleigh faded envelope
z=x+j*y;
r=abs(z);                       
 
t=0:Ts:T-Ts;
plot(t,10*log10(r/mean(r)),'r')
xlabel('Time(sec)')
ylabel('Envelope (dB)')
%%%%%%%%%%%%%%%%