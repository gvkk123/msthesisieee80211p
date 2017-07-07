function C2 = CancelPacketCopies(C2,C,Y_H_Cell,Packet_Orig,kk)

%% ExtractPacketPointers
% This Extracts Pointers of Successfully Decoded Packet.
%ALLPointerCopies = C{C2{kk,2},3};
%ExtraPointerCopies = setdiff(ALLPointerCopies,kk);
ExtraPointerCopies = setdiff(C{C2{kk,2},3},kk);

%% CancelPacketCopies

% This Substracts Packet at other locations assuming channel co-eff. are
% perfectly estimated.
        
for pp = 1:length(ExtraPointerCopies)
    
    % Remove Packet(kk) from Packet at C2{ExtraPointerCopies(pp),4}
    %C2{ExtraPointerCopies(pp),4} = C2{ExtraPointerCopies(pp),4} - Packet_Orig;
    C2{ExtraPointerCopies(pp),4} = C2{ExtraPointerCopies(pp),4} - Y_H_Cell{C2{kk,2},ExtraPointerCopies(pp)};
    
    % Check for all zero cancellation
    if any(C2{ExtraPointerCopies(pp),4}(:))==0
        C2{ExtraPointerCopies(pp),4} = [];
    end
    
    % Remove Cancelled Pointer Location
    C2{ExtraPointerCopies(pp),2} =setdiff(C2{ExtraPointerCopies(pp),2},C2{kk,2});
    
    % Decrement the slot weight value
    C2{ExtraPointerCopies(pp),3} =C2{ExtraPointerCopies(pp),3}-1;

end
        
















end