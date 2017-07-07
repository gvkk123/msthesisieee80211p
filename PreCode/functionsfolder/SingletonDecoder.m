function [DecodeStatus] = SingletonDecoder(rateid,PacketSize,Packet,Ch_Coef_perfectCSI)

%%Decode(Packet)
%Return_Success_Failure
% Decoding all Singleton Slots
% If Decode = Success, DecodeStatus = 0,else DecodeStatus = 1 ;

DecodeStatus = ieee80211p_PacketDECfn(rateid,PacketSize,Packet,Ch_Coef_perfectCSI);

end