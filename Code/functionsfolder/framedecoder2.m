%% Frame Decoding

function [OutputCell,EndFrameCell] = framedecoder2(prmTIMING,user_density,UserCell,RXCell,Y_H_Cell,H_est_perfectCSI,rateid,PacketSize)

%%
C = UserCell;
C2 = RXCell;
num_slots = prmTIMING.num_slots;

OutputCell = cell(user_density,2);

for qq = 1:user_density
    OutputCell{qq,1} = qq;
    OutputCell{qq,2} = 0;
end

%% Main Loop

while 1
    % Initialization
    status = 0;
    % Decoding all Singleton Slots
    DecodeAllSingleton;
    
    % Checking for NEW Singleton Slots
    for i = 1:num_slots 
        if C2{i,3} == 1
            status = 1;
            break
        end
    end
    
    if status == 1
        continue
    end
    % END Loop if no more Singleton Slots Found
    break
end

%%
% This Nested Function Decodes all Singletons 
    function DecodeAllSingleton
        % Decoding all Singleton Slots
        for kk = 1:num_slots
            if isempty(C2{kk,4}) == 0 % Tries to decode slot if its not empty
                DecodeStatus = 1;
                Packet = C2{kk,4};
                %Packet_Orig = C2{kk,5};
                
                % Deoding Singleton packets only to minimise computations
                % and for using perfect channel estimations.
                if C2{kk,3} ==1
                    Ch_Coef_perfectCSI = H_est_perfectCSI{C2{kk,2},C2{kk,1}};
                    DecodeStatus = SingletonDecoder(rateid,PacketSize,Packet,Ch_Coef_perfectCSI);
                end
                % If Decode = Success, DecodeStatus = 0,else DecodeStatus = 1;
                
                % Singleton Slot Not Decodable Case
                if (C2{kk,3} == 1) && (DecodeStatus == 1)
                    % Setting Flag at the Slot.
                    C2{kk,3} = NaN;
                    
                end
                
                
                if DecodeStatus == 0
                    % Updating Output Cell for User Detected
                    OutputCell{C2{kk,2},2} = 1;
                    
					% Reconstructing Original Packet - For now using info
                    % from TX.
                    Packet_Orig = C{C2{kk,2},4};
					
                    % Extract Packet Pointers & Cancel Packet Copies at other Locations
                    C2 = CancelPacketCopies(C2,C,Y_H_Cell,Packet_Orig,kk);
                    
                    % Cancel Decoded Packet Copy
                    C2{kk,4} = [];
                    
                    % Decrement Singleton Slot State
                    C2{kk,3} = C2{kk,3}-1;
                    
                    % Remove Decoded Packet User Info.
                    C2{kk,2} = [];
                    
                end
                                
            else
                %Do Nothing
            end
        end               
    end

%%
EndFrameCell = C2;
end