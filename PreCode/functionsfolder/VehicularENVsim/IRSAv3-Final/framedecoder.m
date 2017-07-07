%% Frame Decoding

function [OutputCell,EndFrameCell] = framedecoder(prmTIMING,user_density,UserCell,RXCell)

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


% % define states
% S1 = 0;
% S2 = 1;
% S3 = 2;
% S4 = 3;
% 
% persistent current_state;
% if isempty(current_state)
%     current_state = S1;
% end
% 
% % switch to new state based on the value state register
% switch (current_state)
%     case S1
%         DecodeAllSingleton;
%     case S2
%         break
% end
        

%%
% This Nested Function Decodes all Singletons 
    function DecodeAllSingleton
        % Decoding all Singleton Slots
        for kk = 1:num_slots
            if C2{kk,3} == 1
                decode_status = 0;
                % Decode C2{kk,4};
                Packet = C2{kk,4};
                DecodePacket;
                
                if (decode_status == 1) && (C2{kk,3} == 1)
                    OutputCell{C2{kk,2},2} = 1;
                    % Extract Packet Pointers
                    ExtractPacketPointers;
                    ExtraPointerCopies1 = ExtraPointerCopies;
                    % Cancel Packet Copies at other Locations
                    CancelPacketCopies;
                end
                
                % Decrement Singleton Slot State
                C2{kk,3} = C2{kk,3}-1;
                tmpOO = C2;
            else
                %Do Nothing.
            end
        end
        
        
        %%
        % This Nested Function Decodes a Packet
        
        function DecodePacket
        %%Decode(Packet)
        %Return_Success_Failure
        % Decoding all Singleton Slots
        % If Decode = Success, decode = 1,else decode = 0 ;
        decode_status = 1;
        end
        
        %%
        % This Nested Function Extracts Pointers of Successfully Decoded Packet.
        
        function ExtractPacketPointers
        %ALLPointerCopies = C{C2{kk,2},3};
        %ExtraPointerCopies = setdiff(ALLPointerCopies,kk);
        ExtraPointerCopies = setdiff(C{C2{kk,2},3},kk);
        end
        
        %%
        % This Nested Function Substracts Packet at other locations
        
        function CancelPacketCopies
        for pp = 1:length(ExtraPointerCopies1)
            % Remove Packet(kk) from Packet at C2{ExtraPointerCopies(pp),4}
            % Remove Cancelled Pointer Location
            C2{ExtraPointerCopies1(pp),2} =setdiff(C2{ExtraPointerCopies1(pp),2},C2{kk,2});
            % Decrement the slot weight value
            C2{ExtraPointerCopies1(pp),3} =C2{ExtraPointerCopies1(pp),3}-1;
        end
        end
        
    end

%%
EndFrameCell = C2;
end