function [weight,loss_ratio] = PLRAnalysis(user_density,rateid,PacketSize)

%% PARAMETERS

%user_density = 50;
% Degree Distribution : Lambda(x) = 0.86*x^3 + 0.14*x^8 

dpack = PacketSize*8; %400*8
prmTIMING = ieee80211p_TIMING(dpack);

%% TX USER PACKET GENERATION & ARRANGEMENT

UserCell = userframegen(prmTIMING,user_density,rateid,PacketSize);

%% RX FRAME ARRANGEMENT 

RXCell = rxframegen(prmTIMING,user_density,UserCell);

%% Frame Decoding

[OutputCell,EndFrameCell] = framedecoder(prmTIMING,user_density,UserCell,RXCell);

%%
for i = 1:user_density
    A(i,1) = OutputCell{i,2};
end

success_ratio=sum(A)/user_density;

loss_ratio = 1- success_ratio;

weight = sum(A);
end