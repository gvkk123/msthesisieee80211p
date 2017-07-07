function IEEE80211pPACKET = ieee80211p_Packetgenfn(rateid,PacketSize)

%%
%Channel Bandwidth in MHz.
chanBW=10;

%Loading Table 17-4 Timing-related parameters
prm80211p = ieee80211p_init(chanBW);
%%
%Rate-ID to determine type of modulation.Can be varied from 1 to 8.
%rateid=3
%Number of Octets(Bytes) Transfer
%NB=400;
NB = PacketSize;
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

%%
IEEE80211pPACKET = txSignal;

end