%%
clc;
clear all;
close all;
%%
%Channel Bandwidth in MHz.
chanBW=10;
%%
%Rate-ID to determine type of modulation.Can be varied from 1 to 8.
rateid=1

%Number of OFDM symbols per Frame to be Transmitted.
%NOT USED
numSymPerFrame=126;

%Number of Octets(Bytes) Transfer
%PSDU LENGTH
NB=1000;

%Number of Frames to be Transmitted.
Nf=1;
%fprintf('Number of frames transmitted = %d .\n',Nf);

%Loading Table 17-4 Timing-related parameters01100
prm80211p = ieee80211p_init(chanBW, numSymPerFrame, Nf );

%%
%Data Generation
 
% Number of bits to process

% coderate=prm80211p.R(rateid)=R
% k=prm80211p.NBPSC(rateid);=log2(M)
% NSD: Number of data subcarriers=48
numBits = 8*NB;

%Generate uniformly distributed random integers from sample interval [0,1]

txdata = randi([0,1],numBits,1);
%%
%Encoding and Interleaving
encoderin=txdata;
encoderout = encoderfn(encoderin,rateid,numBits,prm80211p);
%%
%Modulator Bank
modout = modulatorbank(encoderout,rateid,prm80211p);
%modout = modulatorbankuncoded(data,rateid,numBits,prm80211p);
%%
%OFDM Modulator
ofdmmodout = ofdmtx(modout,prm80211p);

%%
% Cyclic Prefix Addition
CP_OFDM = CPadder(ofdmmodout,prm80211p);

%%
% PPDU Frame Creation
txSignal = ppduframeassembler(prm80211p, rateid, CP_OFDM);

%%
%Channel
% snrdB=0;
% rxSignal = channel(txSignal,snrdB);
EbNoVec=17;
[rxSignal, noiseSigma] = channel(txSignal,EbNoVec,rateid,prm80211p);
%rxSignal = txSignal;
%rxSignal = channel_stdchanex(txSignal,EbNoVec,rateid,prm80211p);
%demodin = channel(modout,snrdB);

%%
% PPDU Frame Separator
[rxpreambleout, rxsignalfield, CPremin] = ppduframedissembler(rxSignal);

%%
% Channel Estimation
estmode = 1;
[estcoef] = channelestimator(rxpreambleout,prm80211p, estmode);

%%
% Cyclic Prefix Removal
ofdmrxin = CPremover(CPremin,prm80211p);

%%
%OFDM Demodulator
EQin = ofdmrx(ofdmrxin,prm80211p);

%% 
%Equalizer
EqMode = 2;
[EQout] = channelequalizer(EQin, estcoef,noiseSigma,EqMode,prm80211p);

%%
% OFDM Symbol Separation
demodin = ofdmrxsplit(EQout,prm80211p);

%%
%Demodulator Bank
demodout = demodulatorbank_hard(demodin,rateid,prm80211p);
%rxdata = demodulatorbank(demodin,rateid,numBits,prm80211p);
%rxdata = demodulatorbankuncoded(demodin,rateid,numBits,prm80211p);

%%
%Decoding and De-Interleaving
decoderin=demodout;
decoderout = decoderfn_hard(decoderin,rateid,numBits,prm80211p);
rxdata=decoderout;
%%
%numerrs = symerr(data,demodout);
numerrs = biterr(txdata,rxdata)
error_ratio=numerrs/numBits
%%
%Plots

% h=scatterplot(modout);
% title('Tx. Gray-coded Symbol Mapping')
% %hold on;
% scatterplot(demodin)
% title('Rx. Gray-coded Symbol Mapping')
%%
sPlotFig = scatterplot(demodin,1,0,'g.');
hold on
scatterplot(modout,1,0,'k*',sPlotFig)
grid;
title('Tx. & Rx. Gray-coded Symbol Mapping')
legend('Rx. Symbols','Tx. Symbols','location','best');