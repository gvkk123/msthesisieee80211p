clc;
clear;
close all;

%%

figure

%%
clear
load('matlab_G25.mat');

user_densityP = length(TC);
T_CA2 = zeros(user_densityP,1);
for i = 1: user_densityP
    T_CA2(i) = TC{i,9};
    T_CA2(i) = T_CA2(i)/(10^3);
end
T_CA3 = sort(T_CA2);
cdf_values = (1:length(T_CA2))./length(T_CA2);
plot(T_CA3,cdf_values);
hold on;

%%
clear
load('matlab_G50.mat');

user_densityP = length(TC);
T_CA2 = zeros(user_densityP,1);
for i = 1: user_densityP
    T_CA2(i) = TC{i,9};
    T_CA2(i) = T_CA2(i)/(10^3);
end
T_CA3 = sort(T_CA2);
cdf_values = (1:length(T_CA2))./length(T_CA2);
plot(T_CA3,cdf_values);
hold on;

%%
clear
load('matlab_G75.mat');

user_densityP = length(TC);
T_CA2 = zeros(user_densityP,1);
for i = 1: user_densityP
    T_CA2(i) = TC{i,9};
    T_CA2(i) = T_CA2(i)/(10^3);
end
T_CA3 = sort(T_CA2);
cdf_values = (1:length(T_CA2))./length(T_CA2);
plot(T_CA3,cdf_values);
hold on;
%%
clear
load('matlab_G100.mat');

user_densityP = length(TC);
T_CA2 = zeros(user_densityP,1);
for i = 1: user_densityP
    T_CA2(i) = TC{i,9};
    T_CA2(i) = T_CA2(i)/(10^3);
end
T_CA3 = sort(T_CA2);
cdf_values = (1:length(T_CA2))./length(T_CA2);
plot(T_CA3,cdf_values);
hold on;

%% Plot
%axis([0 100*10^-4 0 1]);
grid on;
xlabel('Time (milli-seconds)');
ylabel('CDF Value');
hleg = legend('G = 0.25','G = 0.50','G = 0.75','G = 1','Location','SE');
htitle = get(hleg,'Title');
set(htitle,'String','Channel Access Delay-CSMA/CA')
%title('CDF plot');

%%
print('-deps','-r600','CDFPlotCSMA.eps')
print('-dsvg','-r600','CDFPlotCSMA.svg')


