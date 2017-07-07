%%
clc; clear; close all;

N=100000; %Number of Samples  
sigma=1; %Variance of underlying Gaussian Variables  
s=[0 1 2 4]; %Non-Centrality Parameter  

plotStyle={'b-','r-','k-','g-'};  

%%
%Simulating the PDF from two Gaussian Random Variables  
for i = 1: length(s)  
    
    X = s(i) + sigma.*randn(1,N); %Gaussian RV with mean=s and given sigma  
    Y = 0 + sigma.*randn(1,N); %Gaussian RV with mean=0 and same sigma as Y    
    
    Z=X+1i*Y;
    [val,bin]=hist(abs(Z),1000); % pdf of generated Raleigh Fading samples  
    
    plot(bin,val/trapz(bin,val),plotStyle{i}); 
    % Normalizing the PDF to match theoretical result  
    
    % Trapz function gives the total area under the PDF curve. 
    % It is used as the normalization factor  
    hold on;  
end  

%%
%Theoretical PDF computation  
for i=1:length(s)
    
    x=s(i);  
    m1=sqrt(x);  
    m2=sqrt(x*(x-1));
    
    r=0:0.01:9;  
    ss=sqrt(m1^2+m2^2);  
    x=r.*ss/(sigma^2);  
    
    f=r./(sigma^2).*exp(-((r.^2+ss^2)./(2*sigma^2))).*besseli(0,x);    
    
    plot(r,f,plotStyle{i},'LineWidth',2.5);  
    
    legendInfo{i} = ['s = ' num2str(s(i))];    
    
    hold on;  
end
title('Rician PDF for various non-centrality parameter with sigma=1');
legend(legendInfo);