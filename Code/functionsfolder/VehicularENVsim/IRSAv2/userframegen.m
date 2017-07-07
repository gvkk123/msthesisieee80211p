%% USER PACKET GENERATION & ARRANGEMENT
function UserCell = userframegen(prmTIMING,user_density)

r = rand(1,user_density);

C = cell(user_density,4);

tmp = [];
for i = 1: length(r)
    tmp = [];
    if r(i) <= 0.86
        r1(i) = 3;
    else
        r1(i) = 8;
    end
    
    % User Index
    C{i,1} = i;
    
    C{i,2} = r1(i);
    tmp = randperm(prmTIMING.num_slots,r1(i));
    C{i,3} = tmp;
    C{i,4} = [1,1,1,1,1];
end

% histogram(r1);

Total_Packets = sum(r1);

UserCell = C;

end