%% Fading Channel

function [Y_H_Cell,H_Ch,H_est_perfectCSI] = channelframefn(prmTIMING,user_density,UserCell,ChannelMode,EbNo,rateid,prm80211p)

%%
num_slots = prmTIMING.num_slots;
EbNoVec = EbNo;
C = UserCell;

%% Generating Channel Fading Coefficients

H_Ch = cell(user_density,num_slots);
H_est_perfectCSI = cell(user_density,num_slots);
Y_H_Cell =  cell(user_density,num_slots);

for i = 1:user_density

    txSignal = C{i,4};
    
    for j = 1:length(C{i,3})
        % Generating Channel Coefficients
        %[rxSignal,Ch_Coef,NoiseVariance] = ieee80211pCHANNEL(txSignal,EbNoVec,rateid,ChannelMode,prm80211p);
        [~,Ch_Coef,~] = ieee80211pCHANNEL(txSignal,EbNoVec,rateid,ChannelMode,prm80211p);
        H_Ch{i,C{i,3}(j)} = Ch_Coef;
        
        % Updating Channel coefficients for perfect estimation
        Ch_Coef_perfectCSI = channelcoefperfectcsi(txSignal,Ch_Coef,prm80211p);
        H_est_perfectCSI{i,C{i,3}(j)} = Ch_Coef_perfectCSI;
                    
        % Multiplying channel coefficients with transmitted signal.
        Y_H = txSignal.*Ch_Coef;
        Y_H_Cell{i,C{i,3}(j)} = Y_H;
    end

end

end