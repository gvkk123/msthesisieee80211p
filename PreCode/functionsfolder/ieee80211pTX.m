%% IEEE 802.11p TRANSMITTER

function txSignal = ieee80211pTX(txdata,rateid,numBits,prm80211p)

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
% 
% sPlotFig = scatterplot(modout,1,0,'k*');
% grid;
% title('Tx. Gray-coded Symbol Mapping');



end