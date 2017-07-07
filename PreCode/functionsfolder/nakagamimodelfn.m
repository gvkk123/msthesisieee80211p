function [N_RV] = nakagamimodelfn(Num,dist,Pt_dBm)
%%
% clc;
% clear all;
% close all;
%% Distance bin

%d = 50;

%Shape Parameter "m"; Shape Parameter>=0.5
if (dist>=0) && (dist<=50)
    m = 3;
elseif (dist>=51) && (dist<=150)
    m = 1.5;
elseif dist>=151
    m = 1;
else
    disp('Error in Distance Metric');
end

%% Simulation
%Num = 10000;

disp('Nakagami-m Shape Parameter="m"=');disp(m);

n =2*m;

%Spread Parameter "W"; Spread Parameter>0
W = (10^(Pt_dBm/10))/1000;
%W = 1;
val = sqrt(W/(2*m));

for i = 1:n
    %Generating Normal R.V's.
    mean(i) = 0;
    sigma_x(i) = val;
    X1(i,:) = mean(i) + sigma_x(i).*randn(1,Num) ;
    
    X2(i,:) = X1(i,:).*X1(i,:);
end

X3 = sum(X2);
N_RV = sqrt(X3);

%%
step = 0.05;
x = 0:step:5;
h = hist(N_RV, x);  
approxPDF = h/(step*sum(h));
%% Theoritical
for ii = 1:length(x)
    y(ii)=((2*m^m)/(gamma(m)*W^m))*x(ii)^(2*m-1)*exp(-((m/W)*x(ii)^2));
end

%% Figures
figure
plot(x, approxPDF,'b*', x, y,'r');
title('Simulated and Theoretical Nakagami-m PDF');
legend('Simulated PDF','Theoretical PDF')  
xlabel('r --->');  
ylabel('P(r)---> ');  
grid;

end