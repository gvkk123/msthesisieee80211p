%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RAYLEIGH FADING SIMULATOR BASED UPON YOUNG'S METHOD
% N is the number of paths
% M is the total number of points in the frequency domain
% fm is the Doppler frequency in Hz
% fs is the sampling frequency in Hz
% df is the step size in the frequency domain
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;                          
 
N=64;
fm=70;
df=(2*fm)/(N-1);
fs=7.68e6;
M=round(fs/df);
T=1/df;
Ts=1/fs;                                
 
% Generate 2xN IID zero mean Gaussian variates
g1=randn(1,N);  
g2=randn(1,N);
g=g1-1i*g2;                              
 
% Generate Doppler Spectrum
f=-fm:df:fm;
S=1.5./(pi*fm*sqrt(1-(f/fm).^2));
S(1)=2*S(2)-S(3);
S(end)=2*S(end-1)-S(end-2);        
 
% Multiply square root of Doppler Spectrum with Gaussian random sequence
X=g.*sqrt(S);

% Take IFFT
F_zero=zeros(1, round((M-N)/2));
X=[F_zero, X, F_zero];
x=ifft(X,M);
r=abs(x);
r=r/mean(r);                        
 
% Plot the Rayleigh envelope
t=0:Ts:T-Ts;
plot(t,10*log10(r))
xlabel('Time(sec)')
ylabel('Signal Amplitude (dB)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%