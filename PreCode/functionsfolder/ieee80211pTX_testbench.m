%% IEEE 802.11p TRANSMITTER

function txSignal = ieee80211pTX_testbench(txdata,rateid,numBits,prm80211p)
%%
clc;
clear all;
close all;
%%
%Channel Bandwidth in MHz.
chanBW=10;

%Loading Table 17-4 Timing-related parameters01100
prm80211p = ieee80211p_init(chanBW);
%% Test Message as given in Annex G.
txdata = testmessage();
numBits = length(txdata);
% 16-QAM, rate-3/4 code
rateid = 6;


%% Encoding and Interleaving
encoderin=txdata;
encoderout = encoderfn(encoderin,rateid,numBits,prm80211p);

%% Modulator Bank
modout = modulatorbank(encoderout,rateid,prm80211p);
%modout = modulatorbankuncoded(data,rateid,numBits,prm80211p);

%% OFDM Modulator (IFFT)
ofdmmodout = ofdmtx(modout,prm80211p);

%% Cyclic Prefix Addition
CP_OFDM = CPadder(ofdmmodout,prm80211p);

%% PPDU Frame Creation
txSignal = ppduframeassembler(prm80211p, rateid, CP_OFDM);


%% Figures
sPlotFig = scatterplot(modout,1,0,'k*');
grid;
title('Tx. Gray-coded Symbol Mapping');

%%
figure
[Pxx1,W1] = pwelch(txSignal,[],[],4096,20);    
plot([-2048:2047]*chanBW/4096,10*log10(fftshift(Pxx1)), 'k');
grid;
xlabel('frequency, MHz')
ylabel('power spectral density')
title('Transmit spectrum OFDM (based on 802.11p)');


end