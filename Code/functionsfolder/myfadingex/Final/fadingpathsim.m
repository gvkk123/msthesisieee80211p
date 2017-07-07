function [r_norm ] = fadingpathsim (N, fd, fm, spec_type)

%% TABLE 2 V2V Channel Models for the Six Scenarios

% 1 . Tap No.
% 2 . Path No.
% 3 . Tap Power(dB)
% 4 . Relative Path Loss(dB)
% 5 . Delay Value(ns)
% 6 . Rician K(dB)
% 7 . Frequency Shift(Hz)
% 8 . Fading Doppler
% 9 . LOS Doppler(Hz)
% 10. Modulation(Hz) : 1 - Rayleigh , 2 - Rician
% 11. Fading Spectral Shape : 1 - Classic 6 dB(C6)
%                             2 - Classic 3 dB(C3)
%                             3 - Round
%                             4 - Flat

%%
% 
% % Path Total power
% TPL = 10^(PL_dB/10);
% 
% % Frequency Shift(Hz)
% fd = V2VChannelModel1(i,7);
% 
% % Fading Doppler
% fm = V2VChannelModel1(i,8);
% 
% %Fading Spectral Shape
% spec_type = V2VChannelModel1(i,11);

%%

% Defining Mean for Gaussian RV's
m1 = 0; m2 = 0;

% Defining Variance of Gaussian RV's 
Var = 0.5;

% Defining SD for Gaussian RV's
sdev = sqrt(Var);

%In-phase Noise components  
G1 = m1 + sdev.*randn(1,N) ; %N i.i.d Gaussian random samples  
%Quadrature-phase Noise components  
G2 = m2 + sdev.*randn(1,N) ; %N i.i.d Gaussian random samples  

G=G1-1i*G2;

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
%fd=0;

[S]=DopplerFilter(N, fm, fd, a, spec_type);


%%

%%
% Multiply square root of Doppler Spectrum with Gaussian random sequence
X=G.*sqrt(S);

% Take IFFT
x=ifft(X,N);


% Rayleigh Fading
r=abs(x);

% Normalized Rayleigh Fading
mean_r=sum(r)/length(r);
r_norm=r/mean_r;
end