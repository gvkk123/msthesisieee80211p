%% Wireless Channel Models for IEEE 802.11p

% ChannelMode - Decides the type of channel.
% ChannelMode = 1 - No Channel, 
%               2 - AWGN,
%               3 - TDL,
%               4 - Nakagami-m

function [rxSignal,Ch_Coef,NoiseVariance] = ieee80211pCHANNEL(txSignal,EbNoVec,rateid,ChannelMode,prm80211p)

switch ChannelMode
    
    case 1
        %% No Channel
        rxSignal = txSignal;
        Ch_Coef = ones(length(txSignal),1);
        NoiseVariance = 0.001;
    
    case 2
        %% AWGN Channel
        [rxSignal,Ch_Coef,NoiseVariance] = channel_awgn(txSignal,EbNoVec,rateid,prm80211p);
        
    case 3
        %% Tap-Delay Line Channel
        %EbNoVec=16;
        [rxSignal,Ch_Coef,NoiseVariance] = channel_TDL(txSignal,EbNoVec,rateid,prm80211p);
    
    case 4
        %% Nakagami Fading Channel
        
        % Transmitted Power, dBm
        %Pt_dBm = 10;
        Pt_dBm = EbNoVec;
        %disp('Transmitted Power[dBm]=');disp(Pt_dBm);
        
        % Distance between Tx. & Rx.
        dist = 90;
        
        [rxSignal,Ch_Coef,NoiseVariance] = channel_NK_PL(txSignal,Pt_dBm,dist,rateid,prm80211p);

end




