clc;
clear;
close all;

%%
% Priority Mode for CSMA/CA in 802.11.
% By default only priority mode 1 (highest priority is used).
% No Acknowledgements are used.

aCWmin = 15;
aCWmax = 1023;
aSlotTime = 13e-6;
aSIFSTime = 32e-6;

AIFS_N = 2;
CW_min = ((aCWmin+1)/4)-1;
CW_max = ((aCWmin+1)/2)-1;

%t_aifs = 58e-6;
T_AIFS = AIFS_N * aSlotTime + aSIFSTime;

%%

prioity_mode = 1;
t_frame = 100e-3;
t_pack = 576e-6;

t_unit = 1e-6;
t_sim = 200e-3;
% total microseconds N
N = t_sim/t_unit;

% Defining Channel State = IDLE - 0, BUSY - 1
channel_stN = zeros(floor(N),1);

%%

%  Users Initialisation
user_density  = 100;

%%

%  First Transmission Simulation
T_tmp = sort(randi(t_frame* 10^6,user_density,1));

% Defining a Time Cell
TC = cell(user_density,4);

% Defining Channel Access Time
T_CA = zeros(user_density,1);


%%

for i = 1: user_density
    % 1.User Index
    TC{i,1} = i;
    
    TC{i,2} = T_tmp(i);
end

%%

for i = 1: user_density
   
    usertime = TC{i,2};
    
    [channel_stN,tx_start,tx_end] = fnCSMACA(usertime,channel_stN,T_AIFS,t_pack,aSlotTime,prioity_mode,CW_min,CW_max);
    
    TC{i,3} = tx_start;
    T_CA(i) = tx_start/(10^6);
    
    TC{i,4} = tx_end;
end

%%
% Sorting Array for first transmitted slot cell part and CDF Plotting.
fn_CDFplot(T_CA);

NO_CA_num = sum(T_CA == Inf);

Percent_NO_CA = NO_CA_num/user_density;

disp('Percentage of users with No Channel Access = ');
disp(Percent_NO_CA*100);




