clc;
clear;
close all;

%%
% Defining Channel  Load(G) in percentage.
G = 100;
%Total Slots available
T_slots = 172;

%  Users Initialisation
user_density  = floor((G/100)*T_slots);
%user_density  = 172;

% Simulation Time
t_sim = 200e-3;

% Time step unit
t_unit = 1e-6;
% total microseconds N
N = t_sim/t_unit;

%% CSMA Parameters

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

%% Simulation Parameters

prioity_mode = 1;
t_frame = 100e-3;
t_pack = 576e-6;

% Defining Channel State Array = IDLE - 0, BUSY - 1
channel_stN = zeros(floor(N),1);

%  First Transmission Simulation
T_tmp = sort(randi(t_frame* 10^6,user_density,1));

% Defining a Time Cell
TC = cell(user_density,10);

%% Defining Time Cell at start of transmission
for i = 1: user_density
    % 1.User Index
    TC{i,1} = i;
    
    TC{i,2} = T_tmp(i);
    
    TC{i,3} = -1;
    
    TC{i,4} = T_tmp(i) + (T_AIFS*10^6);
    
    %TC{i,5} = TC{i,4} + t_pack*10^6;
end

%% CSMA
timer = 1;

while (timer <= N)
    
    for i = 1:user_density
        
        if ((TC{i,4} == timer)&&(channel_stN(timer)==0)&& (TC{i,3}<=0))
            %Tx. Start time
            %TC{i,4} = TC{i,2} + (T_AIFS*10^6);
            %Tx. End time
            TC{i,5} = TC{i,4} + (t_pack*10^6);
            channel_stN(timer:timer+(t_pack*10^6)) = 1;
        
        elseif ((TC{i,4}==timer) && (channel_stN(timer)==1) && TC{i,3}~=0)
            %start BO Mechanism
            [BO_T] = fnCSMABO(aSlotTime,prioity_mode,CW_min,CW_max);
            TC{i,3} = BO_T*10^6;
            TC{i,6} = BO_T*10^6;
            %Wait till channel gets free
            channelfreedtime = fnchannelIDLEfinder(channel_stN,timer);
            TC{i,4} = channelfreedtime + T_AIFS*10^6;
            TC{i,7} = TC{i,4};

        elseif ((TC{i,4} == timer)&&(channel_stN(timer)==0)&& (TC{i,3}>0))
            TC{i,4} = TC{i,4} + 1;
            TC{i,3} = TC{i,3} - 1;
        
        elseif ((TC{i,4} == timer)&&(channel_stN(timer)==1)&& (TC{i,3}==0))
            channelfreedtime = fnchannelIDLEfinder(channel_stN,timer);
            TC{i,4} = channelfreedtime;
            %Tx. Start time
            %TC{i,4} = Inf;
            %Tx. End time
            %TC{i,5} = Inf;
        end
    end
    
    TC{1,10} = timer;
    timer = timer+1;
end
%% CDF Plots

% Defining Channel Access Time
T_CA = zeros(user_density,1);
T_CA2 = zeros(user_density,1);

for i = 1: user_density
    T_CA(i) = TC{i,4};
    T_CA(i) = T_CA(i)/(10^6);
    
    TC{i,9} = TC{i,4}-TC{i,2};
    T_CA2(i) = TC{i,4}-TC{i,2};
    T_CA2(i) = T_CA2(i)/(10^6);
end
%%
% Sorting Array for first transmitted slot cell part and CDF Plotting.
fn_CDFplot(T_CA2);

NO_CA_num = sum(T_CA == Inf);

Percent_NO_CA = NO_CA_num/user_density;

disp('Percentage of users with No Channel Access = ');
disp(Percent_NO_CA*100);
