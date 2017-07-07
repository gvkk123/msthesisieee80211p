%% Set the simulation parameters.
clc;
clear all;
close all;

%% Initial conditions

%global region r_gear carrier_speed
global current_gear r_gear throttle_angle
X0 = [60 0];

tspan=[0 60];
current_gear = 1;
r_gear = 0.4167;

%%

[t, X] = ode45(@car_solver2,tspan,X0);

%[t, X, Xprime] = ode45(@car_solver,tspan,X0);


%%

% subplot(2,1,1)
% plot(t,X(:,1));grid
% title('Engine speed (rps)')
% xlabel('Time (s)')
% ylabel('Engine speed')
% subplot(2,1,2)
% plot(t,X(:,2));grid
% ylabel('Vehicle Speed (m/s)')
% xlabel('Time(s)')

%%

% Xdata = [];
% for k=1:ceil(tspan(2))
% % Angular velocity in body frame
% [t,X]=ode45(@car_solver,[k-1,k],X0,r_gear);
% [m,n] = size(X);
% X0 = X(m,:)';
% Xdata = [Xdata; X];
% end
% Xdata =[0 X0 1];
% for k=1:ceil(tspan(2))
%     [t, X] = ode45(@car_solver,[k-1,k],X0);
%     [m,n] = size(X);
%     X0 = X(m,:);
%     v = X0(:,2);
%     [next_gear r_gear] = find_gear_ratio(current_gear,v,throttle_angle);
%     Xdata =[Xdata; t X current_gear*ones(m,1)];
%     current_gear = next_gear;
% end
% subplot(3,1,1);
% plot(Xdata(:,1),Xdata(:,2));
% title('Engine Speed as a Function of Time');
% xlabel('Time (s)'); ylabel('Engine Speed (rad/s)');
% subplot(3,1,2);
% plot(Xdata(:,1),Xdata(:,3));
% title('Vehicle Speed as a Function of Time');
% xlabel('Time (s)'); ylabel('Vehicle Speed (m/s)');
% subplot(3,1,3);
% plot(Xdata(:,1), Xdata(:,4));
% title('Gear as a Function of Time');
% xlabel('Time(s)'); ylabel('Gear');


%%

% txaccel = -1.8939;
% rxaccel = AutoVehicleProjfn(txaccel);
