function DecodeStatus = ieee80211p_PacketDECfn(rateid,PacketSize,Packet,Ch_Coef_perfectCSI)

numBits = PacketSize*8;
rxSignal = Packet;

%%
%Channel Bandwidth in MHz.
chanBW=10;

%Loading Table 17-4 Timing-related parameters
prm80211p = ieee80211p_init(chanBW);

%% Receiver
NoiseVariance = 0.001;%Not actually needed.

% FOR LS or MMSE estimate
%rxdata = ieee80211pRX(rxSignal,rateid,numBits,NoiseVariance,prm80211p);

% For Perfect CSI estimate
rxdata = ieee80211pRX_Genie(rxSignal,Ch_Coef_perfectCSI,rateid,numBits,NoiseVariance,prm80211p);

%% RX MAC

[~,err] = crc32detfn(rxdata);

CRC32_Error = err;

%%
DecodeStatus = CRC32_Error;

end