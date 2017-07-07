function [ r, r_norm ] = ricianfadingpathsim (N, PL_dB, K_dB, fd, fm, spec_type)

%%
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

%Rician K - factor; For Rayleigh Fading K=0
K = 10^(K_dB/10);

% Path Total power
TPL = 10^(PL_dB/10);

% Non-Centrality Parameter - s
s=sqrt(K*TPL/(K+1));

% Variance
Var=sqrt(TPL/(2*(K+1)));

%%

% Defining Mean for Gaussian RV's
m1 = s; m2 = 0;

% Defining SD for Gaussian RV's
SD = sqrt(Var);

% In-phase Noise components  
G1 = m1 + SD.*randn(1,N) ; %N i.i.d Gaussian random samples

% Quadrature-phase Noise components  
G2 = m2 + SD.*randn(1,N) ; %N i.i.d Gaussian random samples

G = G1-1i*G2;   

%%

% Generate Doppler Spectrum

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

%a=1;
%fd=0;

df=(2*fm)/(N-1);
% T is the Time Duration of fading waveform
T=1/df;

% fs is the sampling frequency in Hz.
fs=20e6;
Ts=1/fs;

M=round(fs/df);


[S]=myDopplerFilter(fm,fd,TPL,df,spec_type);

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

% Rician Fading
r=abs(x);

% Normalized Fading
mean_r=sum(r)/length(r);
r_norm=r/mean_r;
%r=r/mean(r);

end