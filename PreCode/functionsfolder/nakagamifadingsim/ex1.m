%%
clc;
clear all;
close all;

%%
x = [0:0.05:5];

%Shape Parameter "m"
m = 3;

%Spread Parameter "w"
for w = 1:3
    
    for ii = 1:length(x)
        y(ii)=((2*m^m)/(gamma(m)*w^m))*x(ii)^(2*m-1)*exp(-((m/w)*x(ii)^2));
    end
    
    plot(x,y)
    %plot(x,y,colors(w))
    hold on
end

xlabel('x');
ylabel('PDF(x)'); 
title('Nakagami-m PDF')
%hleg1 = legend('m=1,w=1','m=1,w=2','m=1,w=3');
%set(hleg1,'Location','NorthEast')
axis([0 5 0 2]);
grid on 