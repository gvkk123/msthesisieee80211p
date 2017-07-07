%% BER Estimate of QPSK Signal
%%
clc;
clear all;
close all;
%%
% Create a QPSK modulator and demodulator pair that operate on bits. 
qpskModulator = comm.QPSKModulator('BitInput',true);
qpskDemodulator = comm.QPSKDemodulator('BitOutput',true);
%%
% Create an AWGN channel object and an error rate counter.
channel = comm.AWGNChannel('EbNo',8,'BitsPerSymbol',2);
errorRate = comm.ErrorRate;
%%
% Generate random binary data and apply QPSK modulation.
data = randi([0 1],10,1);
txSig1 = qpskModulator(data);
%%
k=2;
%Rearranging data for conversion from binary to integer.
codewordMat = reshape(data,k,length(data)/k)';

%Binary to Decimal Conversion
txSym = bi2de(codewordMat,'left-msb');

M=4;
txSig = pskmod(txSym,M,pi/M,'gray');
%%
% Pass the signal through the AWGN channel and demodulate it.
rxSig = channel(txSig);
%%
%rxData = qpskDemodulator(rxSig);

demodHard = comm.QPSKDemodulator('BitOutput',false,'SymbolMapping','Gray','DecisionMethod','Hard decision');
rxData1 = demodHard(rxSig);

%%

% Number of bits per symbol, k=log2(M)
%k=prm80211p.NBPSC(rateid);
%Convert the output of the demodulator into a binary column vector.
demodSigMat = de2bi(rxData1,k,'left-msb')';
rxData = reshape(demodSigMat,[],1);

%%
% Calculate the error statistics. Display the BER.
errorStats = errorRate(data,rxData);

errorStats(1)