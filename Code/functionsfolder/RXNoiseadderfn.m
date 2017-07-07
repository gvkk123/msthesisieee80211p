function RXCellN = RXNoiseadderfn(RXCell,prmTIMING,rateid,EbNo,prm80211p)

%%
RXCellN = RXCell;
num_slots = prmTIMING.num_slots;

%%
% Adding coloumn 5 . col4 is noise added packet, col5 is original.
for i = 1 : num_slots
    if isempty(RXCellN{i,4}) == 0
        % AWGN Addition
        %EbNo=10;
        RXCellN{i,5} = RXCellN{i,4};
        txSignal = RXCellN{i,4};
        [rxSignal,~,~] = channel_awgn(txSignal,EbNo,rateid,prm80211p);
        RXCellN{i,4} = rxSignal;
    end
end

end