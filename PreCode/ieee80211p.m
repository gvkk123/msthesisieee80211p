%%
clc;
clear all;
close all;
%%
% Add path (at beginning of script)
added_path = [pwd,'/functionsfolder'];
%change to: added_path = '/path' for your required path
addpath(added_path);

%%
%Channel Bandwidth in MHz.
chanBW=10;

%Loading Table 17-4 Timing-related parameters
prm80211p = ieee80211p_init(chanBW);
%%
%Rate-ID to determine type of modulation.Can be varied from 1 to 8.
rateid=3
%Number of Octets(Bytes) Transfer
NB=400;

%fprintf('Number of frames transmitted = %d .\n',Nf);

%%
%Data Generation
% Number of Bytes of Data = NB-30(MAC Header)-4(CRC-32) = NB-34 

dataBits = 8*(NB-34);

%Generate uniformly distributed random integers from sample interval [0,1]
txload = randi([0,1],dataBits,1);


%% PREPENDING MAC HEADER

%MAC Header length = 30 BYTES
TX_MAC_Header = randi([0,1],30*8,1);

payloaddata = [TX_MAC_Header' txload']';

%% APPENDING CRC-32 HASH

txdata = crc32genfn(payloaddata);
numBits = length(txdata);


%% Transmitter

txSignal = ieee80211pTX(txdata,rateid,numBits,prm80211p);


%% Wireless Channel

EbNoVec=4;
% ChannelMode - Decides the type of channel.
% ChannelMode = 1 - No Channel, 2 - AWGN, 3 - TDL, 4 - Nakagami-m
% For Channel Mode 4, EbNoVec, does not refer to EbN0, It refers to the
% transmitted power - Pt_dBm
ChannelMode = 2;
[rxSignal,Ch_Coef,NoiseVariance] = ieee80211pCHANNEL(txSignal,EbNoVec,rateid,ChannelMode,prm80211p);


%% Channel Co-ef Calc. for perfect CSI
Ch_Coef_perfectCSI = channelcoefperfectcsi(txSignal,Ch_Coef,prm80211p);

%% Receiver

%rxdata = ieee80211pRX(rxSignal,rateid,numBits,NoiseVariance,prm80211p);
rxdata = ieee80211pRX_Genie(rxSignal,Ch_Coef_perfectCSI,rateid,numBits,NoiseVariance,prm80211p);

%% RX MAC

[rxpayload,err] = crc32detfn(rxdata);

CRC32_Error = err

RX_MAC_Header = rxpayload(1:240);
rxload = rxpayload(241:end);


%%
%numerrs = symerr(data,demodout);
numerrs = biterr(txdata,rxdata)
error_ratio=numerrs/numBits
%%
%Plots

% sPlotFig = scatterplot(demodin,1,0,'g.');
% hold on
% scatterplot(modout,1,0,'k*',sPlotFig)
% grid;
% title('Tx. & Rx. Gray-coded Symbol Mapping')
% legend('Rx. Symbols','Tx. Symbols','location','best');

%%
figure
[Pxx1,W1] = pwelch(txSignal,[],[],4096,20);    
plot([-2048:2047]*chanBW/4096,10*log10(fftshift(Pxx1)), 'k');
grid;
xlabel('frequency, MHz')
ylabel('power spectral density')
title('Transmit spectrum OFDM (based on 802.11p)');

%%
figure
[Pxx2,W2] = pwelch(rxSignal,[],[],4096,20);    
plot([-2048:2047]*chanBW/4096,10*log10(fftshift(Pxx2)),'k');
grid;
xlabel('frequency, MHz')
ylabel('power spectral density')
title('Recieved spectrum OFDM (based on 802.11p)');

%%
% Remove path (at end of script/script clean-up)
rmpath(added_path);
