%% Six Time- and Frequency-Selective Empirical Channel Models 
%% for Vehicular Wireless LANs

% %%
% clc;
% clear;
% close all;    

%% Function

function [h] = TDLChannelModel(N,V2VChannelModel_Num)

%% TABLE 2 V2V Channel Models for the Six Scenarios

% 1 . Tap No.
% 2 . Path No.
% 3 . Tap Power(dB)
% 4 . Relative Path Loss(dB)
% 5 . Delay Value(ns)
% 6 . Rician K(dB)
% 7 . Frequency Shift(Hz)
% 8 . Fading Doppler
% 9 . LOS Doppler(Hz)
% 10. Modulation(Hz) : 1 - Rayleigh , 2 - Rician
% 11. Fading Spectral Shape : 1 - Classic 6 dB(C6)
%                             2 - Classic 3 dB(C3)
%                             3 - Round
%                             4 - Flat

% Carrier Frequency 5.89GHz
fc = 5.89e9;

%N = 1000;

% 1.V2V Expressway Oncoming
% 2.V2V Urban Canyon Oncoming
switch V2VChannelModel_Num
    
    case 1 % 1.V2V Expressway Oncoming
        load('V2V1.mat');
    case 2 % 2.V2V Urban Canyon Oncoming
        load('V2V2.mat');
    case 3 % 3.RTV Expressway
        load('V2V3.mat');
    case 4 % 4.RTV Urban Canyon
        load('V2V4.mat');

end


%%

for i = 1:size(V2VChannelModel1,1)
    
    % Path i
    %i=1;
    
    % Tap Power(dB)
    TP_dB = V2VChannelModel1(i,3);
    
    % Delay Value(ns)
    tau = V2VChannelModel1(i,5);
    
    % Relative Path Loss(dB)
    PL_dB = V2VChannelModel1(i,4);
    
    % Rician K(dB)
    K_dB = V2VChannelModel1(i,6);
    
    % Frequency Shift(Hz)
    fd = V2VChannelModel1(i,7);
    
    % Fading Doppler
    fm = V2VChannelModel1(i,8);
    
    % LOS Doppler
    fdLOS = V2VChannelModel1(i,9);
    
    % Fading Modulation Type
    fMOD = V2VChannelModel1(i,10);
    
    %Fading Spectral Shape
    spec_type = V2VChannelModel1(i,11);
    
    
    if fMOD == 1
        
        [r_norm ] = fadingpathsim (N, fd, fm, spec_type);
        
        %plot(10*log10(r_norm));
        
        % Path Total power
        TPL = 10^(PL_dB/10);
        r_norm1(i,:) = (TPL)*r_norm;
        
        %plot(10*log10(r_norm1));
    
    elseif fMOD ==2
        
        [r_norm ] = fadingpathsim (N, fd, fm, spec_type);
        
        %plot(10*log10(r_norm));
        
        % Path Total power
        
        TPL = 10^(PL_dB/10);
        
        % Rician K-Factor
        
        K = 10^(K_dB/10);
        K123 = ((sqrt(K/(K+1)))*exp(1i*2*pi*fdLOS));
        
        r_norm1(i,:) = (TPL)*((r_norm/sqrt(K+1)) + K123);
        
        %plot(10*log10(abs(r_norm1)));
    end
    
    mul = exp(-1i*2*pi*fc*tau);
    r_norm2(i,:) = r_norm1(i,:) * mul;
    
    % Tap Power
    TapPL = 10^(TP_dB/10);
    
    r_normF(i,:) = TapPL * r_norm2(i,:);

end

h = sum(r_normF).';

end
