%% RX FRAME ARRANGEMENT

function RXCell = rxframegen(prmTIMING,user_density,UserCell)

%%
C = UserCell;

% Creating Frame Cell at Receiver for all slots in a Frame
C1 = cell(prmTIMING.num_slots,4);

%%
% 1.Index
for iii = 1:prmTIMING.num_slots
    C1{iii,1} = iii;
end

%%
% 2.Users transmitting in the Slot
for ii = 1:user_density
    for jj = 1:C{ii,2}
        C1{C{ii,3}(jj),2} = [C1{C{ii,3}(jj),2} C{ii,1}];
    end
end

%%
% 3.Total Number of Transmissions in the Slot
for ij = 1:prmTIMING.num_slots
    C1{ij,3} = length(C1{ij,2});
end

%%
% 4.Final Packet Received at the Slot
for jj = 1:prmTIMING.num_slots
    if C1{jj,3} == 0
        
    else
        C1{jj,4} = zeros(1,length(C{1,4}));
        for jk = 1:C1{jj,3}
            C1{jj,4} = C1{jj,4}+C{C1{jj,2}(jk),4};
        end
    end
end

%%
RXCell = C1;

end