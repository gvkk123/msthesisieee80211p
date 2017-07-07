%% USER PACKET GENERATION & ARRANGEMENT

function UserCell = userframegen(prmTIMING,user_density)

% Generaing Uniformly distributed random numbers
r = rand(1,user_density);

% User Cell Generation
C = cell(user_density,4);

% Pre-Allocations
r1 = zeros(1,user_density);
%tmp = [];

for i = 1: length(r)

if r(i) <= 0.86
        r1(i) = 3;
    else
        r1(i) = 8;
end

    % For regular distributions
    %r1(i) =3;
    
    % Generating Coloumns of User Cell

    % 1.User Index
    C{i,1} = i;

    % 2.Number of User Transmissions
    C{i,2} = r1(i);

    % 3.User Transmission Slots
    tmp = randperm(prmTIMING.num_slots,r1(i));
    C{i,3} = tmp;

    % 4.User Transmission Packet as per IEEE 802.11p Standard
    C{i,4} = [1,1,1,1,11,1]';

end

% histogram(r1);

% Total_Packets = sum(r1);

UserCell = C;

end