% script for generting OFDM transmit waveform (loosely based on 
% IEEE 802.11A specifications)
%% 
clc;
clear;
close all;
%%
nFFTSize = 64;
% for each symbol bits a1 to a52 are assigned to subcarrier 
% index [-26 to -1 1 to 26] 
subcarrierIndex = [-26:-1 1:26];
nBit = 25000; 
ip = rand(1,nBit) > 0.5; % generating 1's and 0's
nBitPerSymbol = 52;

nSymbol = ceil(nBit/nBitPerSymbol);
%%
% BPSK modulation
% bit0 --> -1
% bit1 --> +1
ipMod = 2*ip - 1; 
ipMod = [ipMod zeros(1,nBitPerSymbol*nSymbol-nBit)];
ipMod = reshape(ipMod,nSymbol,nBitPerSymbol);

%%
st = []; % empty vector

for ii = 1:nSymbol

inputiFFT = zeros(1,nFFTSize);

% assigning bits a1 to a52 to subcarriers [-26 to -1, 1 to 26]
inputiFFT(subcarrierIndex+nFFTSize/2+1) = ipMod(ii,:);

%  shift subcarriers at indices [-26 to -1] to fft input indices [38 to 63]
inputiFFT = fftshift(inputiFFT); 

outputiFFT = ifft(inputiFFT,nFFTSize);

% adding cyclic prefix of 16 samples 
outputiFFT_with_CP = [outputiFFT(49:64) outputiFFT];

st = [st outputiFFT_with_CP]; 

end
%%

fsMHz = 20;
[Pxx,W] = pwelch(st,[],[],4096,20);    
plot([-2048:2047]*fsMHz/4096,10*log10(fftshift(Pxx)));
xlabel('frequency, MHz')
ylabel('power spectral density')
title('Transmit spectrum OFDM (based on 802.11a)');

%%  System simulation parameters

Fc = 5.9e9;         % Carrier frequency (Hz)
Rsym = 1/Tsym;      % Symbol rate (symbols/second)

% Number of samples per symbol
% Fs = Rsym * nSamps;
nSamps = Fs/Rsym;

% bit rate
Rb = Rs*log2(M);  

%Tsym = 8e-6;        % 8us.
% Calculate sample rate in Hz
% Given
Fs = 20e6;



% % Number of symbols in a frame
frameLength = 52;


%% Frequency Upconversion
% You apply frequency upconversion to obtain a passband signal around the
% specified carrier frequency.  You achieve this by multiplying the complex
% baseband signal with a complex sinusoidal and taking the real part.

% Generate carrier. The sqrt(2) factor ensures that the power of the
% frequency upconverted signal is equal to the power of its baseband
% counterpart.
t = (0:1/Fs:(frameLength/Rsym)-1/Fs).';
carrier = sqrt(2)*exp(1i*2*pi*Fc*t);

% Frequency upconvert to passband.
xUp = real(st.*carrier);

% Plot spectrum estimate.
pwelch(xUp,hamming(512),[],[],Fs,'centered')