function [N_RV] = nakagamimodelfn2(Num,dist,Pt_dBm,dataset_selector)

%%
% clc;
% clear all;
% close all;

%% Distance bin

%dist = 30;
%dataset_selector = 1;

switch dataset_selector
    case 1
        %Shape Parameter "m"; Shape Parameter>=0.5
        if (dist>=0) && (dist<=5.5)
            m = 4.07;
        elseif (dist>5.5) && (dist<=13.9)
            m = 2.44;
        elseif (dist>13.9) && (dist<=35.5)
            m = 3.08;
        elseif (dist>35.5) && (dist<=90.5)
            m = 1.52;
        elseif (dist>90.5) && (dist<=230.7)
            m = 0.74;
        elseif (dist>230.7) && (dist<=588.0)
            m = 0.84;
        elseif dist>588.0
            m = 0.84;
        else
            disp('Error in Distance Metric');
        end
    case 2
        %Shape Parameter "m"; Shape Parameter>=0.5
        if (dist>=0) && (dist<=4.7)
            m = 3.01;
        elseif (dist>4.7) && (dist<=11.7)
            m = 1.18;
        elseif (dist>11.7) && (dist<=28.9)
            m = 1.94;
        elseif (dist>28.9) && (dist<=71.6)
            m = 1.86;
        elseif (dist>71.6) && (dist<=177.3)
            m = 0.45;
        elseif (dist>177.3) && (dist<=439.0)
            m = 0.32;
        elseif dist>439.0
            m = 0.32;
        else
            disp('Error in Distance Metric');
        end
end
%% Nakagami from Gamma;

%Num =1000000;

% Nakagami -(m,W);

% Nakagami to Gamma.
%m = 1.52;

%Spread Parameter "W"; Spread Parameter>0
%Pt_dBm = 30;
W = (10^(Pt_dBm/10))/1000;
%W = 1;

a = m;
b = W/m;

% Gamma Distribution.
% Generating Gamma R.V's:
G_RV = gamrnd(a,b,[1 Num]);

% Nakagami Distribution.
N_RV = sqrt(G_RV);


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