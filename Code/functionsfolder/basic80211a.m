%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creative Commons
% Attribution-Noncommercial 2.5 India
% You are free:
% to Share — to copy, distribute and transmit the work
% to Remix — to adapt the work
% Under the following conditions:
% Attribution. You must attribute the work in the manner 
% specified by the author or licensor (but not in any way 
% that suggests that they endorse you or your use of the work). 
% Noncommercial. You may not use this work for commercial purposes. 
% For any reuse or distribution, you must make clear to others the 
% license terms of this work. The best way to do this is with a 
% link to this web page.
% Any of the above conditions can be waived if you get permission 
% from the copyright holder.
% Nothing in this license impairs or restricts the author's moral rights.
% http://creativecommons.org/licenses/by-nc/2.5/in/

% Author	: Krishna
% Email		: krishna@dsplog.com
% Version	: 1.0
% Date		: 02 February 2008
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% script for generting OFDM transmit waveform (loosely based on 
% IEEE 802.11A specifications)
% 
clc;
clear all;
close all;

nFFTSize = 64;
% for each symbol bits a1 to a52 are assigned to subcarrier 
% index [-26 to -1 1 to 26] 
subcarrierIndex = [-26:-1 1:26];
nBit = 25000; 
ip = rand(1,nBit) > 0.5; % generating 1's and 0's
nBitPerSymbol = 52;

nSymbol = ceil(nBit/nBitPerSymbol);

% BPSK modulation
% bit0 --> -1
% bit1 --> +1
ipMod = 2*ip - 1; 
ipMod = [ipMod zeros(1,nBitPerSymbol*nSymbol-nBit)];
ipMod = reshape(ipMod,nSymbol,nBitPerSymbol);

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


fsMHz = 20;
[Pxx,W] = pwelch(st,[],[],4096,20);    
plot([-2048:2047]*fsMHz/4096,10*log10(fftshift(Pxx)));
xlabel('frequency, MHz')
ylabel('power spectral density')
title('Transmit spectrum OFDM (based on 802.11a)');