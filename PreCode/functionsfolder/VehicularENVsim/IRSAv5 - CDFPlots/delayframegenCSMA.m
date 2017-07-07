%% USER PACKET GENERATION & ARRANGEMENT DELAY CALCULATIONS FOR CSMA/CA:

function DelayCellCSMA = delayframegenCSMA(prmTIMING,user_density)

% Generating Uniformly distributed random number for first transmission
% of each user for CSMA/CA
tslot = prmTIMING.tslot * (10^6);
t_frame = prmTIMING.t_frame * (10^6);
taifs = (prmTIMING.taifs) * (10^6);

tmax = floor(t_frame - tslot) ;

r = randi([1,tmax],user_density,1);

r_sort = sort(r);

% User Cell Generation
C = cell(user_density,2);
C2 = cell(user_density,4);

% Pre-Allocations
r1 = zeros(1,user_density);
FTC = zeros(1,user_density);

%tmp = [];

for i = 1: user_density
    
    % Generating Coloumns of User Cell

    % 1.User Index
    C{i,1} = i;
    
    % 2. Initial Delay set for each user(in Micro-Seconds)
    C{i,2} = r(i);

end

for i = 1: user_density
    
    % Generating Coloumns of User Cell

    % 1.User Index
    C2{i,1} = i;

    % 2. Sorting Initial Delay set for each user(in Micro-Seconds)
    C2{i,2} = r_sort(i);
    C2{i,3} = r_sort(i);
    
    tstart = C2{i,2};
    
    timer = tstart + taifs + tslot;

    C2{i,4} = timer;

end

for i = 1: (user_density-1)
    
    if C2{(i+1),2} <= C2{i,4}
        
        C2{(i+1),3} = C2{i,4};
        
    end
    
end









% Sorting Array for first transmitted slot cell part and CDF Plotting.
% fn_CDFplot(r);


DelayCellCSMA = C;

end