function rxaccel = AutoVehicleProjfn(txaccel)

%%
% Set the simulation parameters.
% clc;
% clear all;
% close all;

%% Car 1 Acceleration for Transmission.

% datalength = 32;
% 
% txaccel = randi([0,1],datalength,1);

%txaccel = -1.8939;

% Coversion into Double-precision floating-point format
txaccel1 = num2bin(txaccel);

%txaccel1 = double(txaccel);

% Coversion into Single-precision floating-point format
%txaccel1 = single(txaccel);

%%

%txdata = de2bi(txaccel)';
%txdata = txaccel;

%% PREPENDING MAC HEADER

%MAC Header length = 30 BYTES

TX_MAC_Header = randi([0,1],30*8,1);

payloaddata = [TX_MAC_Header' txaccel1]';

%% APPENDING CRC-32 HASH

txdata = crc32genfn(payloaddata);
numBits = length(txdata);

%%
%Channel Bandwidth in MHz.
chanBW=10;
%%
%Rate-ID to determine type of modulation.Can be varied from 1 to 8.
rateid=1

%Number of OFDM symbols per Frame to be Transmitted.
numSymPerFrame=126;

%Number of Octets(Bytes) Transfer
NB=12500;

%Number of Frames to be Transmitted.
Nf=1;
%fprintf('Number of frames transmitted = %d .\n',Nf);

%Loading Table 17-4 Timing-related parameters01100
prm80211p = ieee80211p_init(chanBW);

%% TRANSMITTER

txSignal = ieee80211pTX(txdata,rateid,numBits,prm80211p);

%% CHANNEL

EbNoVec=10;
[rxSignal, noiseSigma] = channel(txSignal,EbNoVec,rateid,prm80211p);

%% RECEIVER

rxdata = ieee80211pRX(rxSignal,numBits,noiseSigma,prm80211p);

%%

%rxpayload = crc32detfn(rxdata);
[rxpayload,err] = crc32detfn(rxdata);

CRC32_Error = err

RX_MAC_Header = rxpayload(1:240);
rxaccel1 = rxpayload(241:240+64);

rxaccel = bin2num(rxaccel1);
%% Verification

TX_Acceleration = txaccel
RX_Acceleration = rxaccel

isequal(txaccel,rxaccel)

%%

% figure
% [Pxx1,W1] = pwelch(txSignal,[],[],4096,20);    
% plot([-2048:2047]*chanBW/4096,10*log10(fftshift(Pxx1)), 'k');
% grid;
% xlabel('frequency, MHz')
% ylabel('power spectral density')
% title('Transmit spectrum OFDM (based on 802.11p)');

%%

% figure
% [Pxx2,W2] = pwelch(rxSignal,[],[],4096,20);    
% plot([-2048:2047]*chanBW/4096,10*log10(fftshift(Pxx2)),'k');
% grid;
% xlabel('frequency, MHz')
% ylabel('power spectral density')
% title('Recieved spectrum OFDM (based on 802.11p)');

end