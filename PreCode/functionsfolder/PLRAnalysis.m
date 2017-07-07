function [weight,loss_ratio] = PLRAnalysis(user_density,rateid,PacketSize)

%% PARAMETERS

%user_density = 50;
% Degree Distribution : Lambda(x) = 0.86*x^3 + 0.14*x^8 

dpack = PacketSize*8; %400*8
prmTIMING = ieee80211p_TIMING(dpack);

%%
%Channel Bandwidth in MHz.
chanBW=10;

%Loading Table 17-4 Timing-related parameters
prm80211p = ieee80211p_init(chanBW);

%% TX USER PACKET GENERATION & ARRANGEMENT

UserCell = userframegen(prmTIMING,user_density,rateid,PacketSize);

%% Fading Channel
EbNo=10;

ChannelMode = 3;
[Y_H_Cell,~,H_est_perfectCSI] =channelframefn(prmTIMING,user_density,UserCell,ChannelMode,EbNo,rateid,prm80211p);

%% RX FRAME ARRANGEMENT

RXCell = rxframegen2(prmTIMING,user_density,UserCell,Y_H_Cell);

%% Noise Addition
RXCell = RXNoiseadderfn(RXCell,prmTIMING,rateid,EbNo,prm80211p);

%% Frame Decoding

[OutputCell,~] = framedecoder2(prmTIMING,user_density,UserCell,RXCell,Y_H_Cell,H_est_perfectCSI,rateid,PacketSize);

%%
A = zeros(user_density,1);
for i = 1:user_density
    A(i,1) = OutputCell{i,2};
end

success_ratio=sum(A)/user_density;

loss_ratio = 1- success_ratio;

weight = sum(A);
end