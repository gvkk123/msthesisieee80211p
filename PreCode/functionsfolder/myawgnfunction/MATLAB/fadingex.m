% Saeed Akhavan-Astaneh
% Simulation of QAM + AWGN + Rayleigh Fading
% clear all; clc; close all;

% Modulation schem M-QAM
M = 16;

% Received SNR
SNR = 1:2:20;

% Create Rayleigh fading channel object.
bitRate = 10000;
ch = rayleighchan(1/bitRate, 10, 0 ,0); 
ch.ResetBeforeFiltering = 0;

% Modulator and Demodulator Objects
hmod = modem.qammod(M);
gmod = modem.qamdemod(hmod); 

% Transmitted Data ~ with Normal PDF
tx = randint(5000,1,M);

% Modulation
qamSig = modulate(hmod,tx);

% Rayleigh Fading Ampalitude without Phase Fading, 
% The key point for ONES is that, in some modulation schemes like DPSK
% the phase error can not destroy the results. 
% Remind that we have two error effects: Gain error and Phase error. 
% employing qam or qpsk means your system is sensitive to phase error and a uniform phase error 
% is equal to flipping a coin in your receiver side to decide for symbols 
% so the error probability is obviously 1/n. 
% In contrast, DPSK is robust in terms of phase error.
% I used the ONES + abs code to get rid of phase error and to find the impulse response of 
% the system. I assumed that the time duration between consecutive transmitted 
% symbols are large enough that there is no ISI. 
% So a simple absolute value of impulse response works well.

fad = abs(filter(ch, ones(size(qamSig))));
fadedSig = fad.*qamSig;

BER = ones(size(SNR));
for n = 1:length(SNR)

    % AWGN
    rxSig = awgn(fadedSig,SNR(n),'measured');

    % Constellation Mapping
    % h = scatterplot(rxSig,1,0,'b.',h);

    % Demodulation
    rx = demodulate(gmod,rxSig);
    [nErrors, BER(n)] = biterr(tx,rx);
end
semilogy(SNR,BER,'r*');