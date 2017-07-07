% Comb-type test case
clc;clear;close all;

ip = 1:64;

data = 1:48;

pilots = 49:52;

dc = 53;

noness = 54:64;

subIndex = [1:26];
subcarrierIndex = [-26:-22 -20:-8 -6:-1 1:6 8:20 22:26];%53
subcarrierIndex1=[1:5 7:19 21:32 34:46 48:52];%52
pilotIndex = [-21 -7 7 21];%53
pilotIndex1 = [6 20 33 47];%52

%step1

prm80211pNST = 52;

    inputiFFT1 = zeros(1,prm80211pNST);
    
    %inputiFFT1(subcarrierIndex1) = ipMod(ii,:);
     i1 = 1:48;
    inputiFFT1(subcarrierIndex1) = data(i1);
    
    i2 = 1:4;
    %inputiFFT1(pilotIndex1) = zeros(1,length(pilotIndex1));
    inputiFFT1(pilotIndex1) = pilots(i2);
    
    %step2
    prm80211pNFFT = 64;
    inputiFFT = zeros(1,prm80211pNFFT);
    inputiFFT(subIndex+1) = inputiFFT1(subIndex+prm80211pNST/2);
    inputiFFT(subIndex+prm80211pNST/2+12) = inputiFFT1(subIndex);