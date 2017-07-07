%% RX FRAME ARRANGEMENT

function RXCell = rxframegen(prmTIMING,user_density,UserCell)

C = UserCell;

C1 = cell(prmTIMING.num_slots,4);

for iii = 1:prmTIMING.num_slots
    C1{iii,1} = iii;
end


for ii = 1:user_density
    for jj = 1:C{ii,2}
        C1{C{ii,3}(jj),2} = [C1{C{ii,3}(jj),2} C{ii,1}];
    end
end

for ij = 1:prmTIMING.num_slots
    C1{ij,3} = length(C1{ij,2});
end

for jj = 1:prmTIMING.num_slots
    if C1{jj,3} == 0
        
    else
        C1{jj,4} = zeros(1,length(C{1,4}));
        for jk = 1:C1{jj,3}
            C1{jj,4} = C1{jj,4}+C{C1{jj,2}(jk),4};
        end
    end
end

RXCell = C1;

end