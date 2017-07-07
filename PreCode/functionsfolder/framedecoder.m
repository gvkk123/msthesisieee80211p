%% Frame Decoding

function [OutputCell,EndFrameCell] = framedecoder(prmTIMING,user_density,UserCell,RXCell,rateid,PacketSize)

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
        %%
        % Decoding all Singleton Slots
        flagg = 0;
        for kk = 1:num_slots
            if isempty(C2{kk,4}) == 0
                DecodeStatus = 1;
                Packet = C2{kk,4};
                Packet_Orig = C2{kk,5};
                DecodePacket;
                
                % If Decode = Success, DecodeStatus = 0,else DecodeStatus = 1;
                if DecodeStatus == 0
                    % Updating Output Cell for User Detected
                    OutputCell{C2{kk,2},2} = 1;
                    
                    % Extract Packet Pointers
                    ExtractPacketPointers;
                    
                    ExtraPointerCopies1 = ExtraPointerCopies;
                    % Cancel Packet Copies at other Locations
                    CancelPacketCopies;
                    
                    % Cancel Decoded Packet Copy
                    C2{kk,4} = [];
                    
                    % Decrement Singleton Slot State
                    C2{kk,3} = C2{kk,3}-1;
                    
                    % Remove Decoded Packet User Info.
                    C2{kk,2} = [];
                    
                    flagg = 1;
                end
                                
            else
                %Do Nothing
            end
        end
        
        %%
        % This Nested Function Decodes a Packet
        
        function DecodePacket
        %%Decode(Packet)
        %Return_Success_Failure
        % Decoding all Singleton Slots
        % If Decode = Success, DecodeStatus = 0,else DecodeStatus = 1 ;
        DecodeStatus = ieee80211p_PacketDECfn(rateid,PacketSize,Packet);
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
            C2{ExtraPointerCopies1(pp),4} = C2{ExtraPointerCopies1(pp),4} - Packet_Orig;
            
            % Check for all zero cancellation
            if any(C2{ExtraPointerCopies1(pp),4}(:))==0
                C2{ExtraPointerCopies1(pp),4} = [];
            end
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