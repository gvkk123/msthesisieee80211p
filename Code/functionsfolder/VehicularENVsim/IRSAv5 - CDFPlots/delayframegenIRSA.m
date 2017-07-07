%% USER PACKET GENERATION & ARRANGEMENT DELAY CALCULATIONS FOR IRSA:

function DelayCellIRSA = delayframegenIRSA(prmTIMING,user_density)

% Generaing Uniformly distributed random numbers
r = rand(1,user_density);

% User Cell Generation
C = cell(user_density,5);

% Pre-Allocations
r1 = zeros(1,user_density);
FTC = zeros(1,user_density);

%tmp = [];

for i = 1: length(r)

if r(i) <= 0.86
        r1(i) = 3;
    else
        r1(i) = 8;
end
    
    % Generating Coloumns of User Cell

    % 1.User Index
    C{i,1} = i;

    % 2.Number of User Transmissions
    C{i,2} = r1(i);

    % 3.User Transmission Slots
    tmp = randperm(prmTIMING.num_slots,r1(i));
    C{i,3} = tmp;

    % 4.First Slot where the User Transmitted
    C{i,4} = min(tmp);
    
    % 5.Multiplying with the Slot Duration form Timing Parameters.
    C{i,5} = (C{i,4}-1) * prmTIMING.tslot;
    
    % Extracting only the first transmitted slot cell part.
    FTC(i) = C{i,5};
end

% Sorting Array for first transmitted slot cell part and CDF Plotting.
fn_CDFplot(FTC);

% histogram(r1);

% Total_Packets = sum(r1);

DelayCellIRSA = C;

end