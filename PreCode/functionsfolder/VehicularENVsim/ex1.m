%%
clc;
clear all;
close all;

%%

%Highway Scenario 1- Normal vehicle density,2- High vehicle density.
%3 - Simulated Scenario.

Highway_Scenario = 3;

switch Highway_Scenario
    case 1
        %Approximate Vehicle density for 100 m of highway.
        density = 10;
        %Number of lanes
        lanes = 6;
        %Poisson - mean inter-arrival time.
        lambda = 3;
    case 2
        %Approximate Vehicle density for 100 m of highway.
        density = 25;
        %Number of lanes
        lanes = 12;
        %Poisson - mean inter-arrival time.
        lambda = 1;
    case 3
        %Approximate Vehicle density for 100 m of highway.
        density = 15;
        %Number of lanes
        lanes = 12;
        %Poisson - mean inter-arrival time.
        lambda = 3;
end

%%
%Total Distance Simulated [meters]:
D_total = 10000;

%Total Number of Vehicles:
V_total = density*(D_total/100);

% Distance update interval = 250ms
update_t = 0.25;

%%
% Vehicle speed Simulation - Gaussian R.V. - 23-37 m/s. SD = 1m/s.
LaneAvgVel = [23 23 30 30 37 37 37 37 30 30 23 23];

%% 
mean = LaneAvgVel(1);
sigma = 1;
Vel = mean + sigma.*randn(1,V_total) ;

figure
histogram(Vel);

%%

% Arrival Times:
E(1) = exprnd(lambda);
T(1) = E(1);

for i = 2: 100000
    E(i) = exprnd(lambda);
    T(i) = T(i-1) + E(i);
end

figure
histogram(E);

%%


