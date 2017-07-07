function demodin = ofdmrxsplit(EQout,prm80211p)

% prm80211p.NSD = 48;
% prm80211p.NST = 52;
% prm80211p.NSP = 4;
% prm80211p.NFFT = 64;
% prm80211p.NcyclicPrefix = 16;
% prm80211p.NFFT2 = prm80211p.NFFT + prm80211p.NcyclicPrefix;


nSymbol = ceil(length(EQout)/prm80211p.NFFT);

% formatting the received vector into symbols
rx1=reshape(EQout,prm80211p.NFFT,nSymbol).';

subIndex = [1:26];
subcarrierIndex = [-26:-22 -20:-8 -6:-1 1:6 8:20 22:26];%53
subcarrierIndex1=[1:5 7:19 21:32 34:46 48:52];%52
pilotIndex = [-21 -7 7 21];%53
pilotIndex1 = [6 20 33 47];%52

dt = []; % empty vector

for ij = 1:nSymbol
    
    outputFFT = rx1(ij,:);
    %{1,2:27,28:38,39:64}
    %{[1:5 7:19 21:32 34:46 48:52], [6 20 33 47]}
    outputFFT1 = zeros(1,prm80211p.NST);
    outputFFT1(subIndex) = outputFFT(subIndex+prm80211p.NST/2+12);
    outputFFT1(subIndex+prm80211p.NST/2) = outputFFT(subIndex+1);
    
    outputFFT2 = zeros(1,prm80211p.NSD);
    outputFFT2 = outputFFT1(subcarrierIndex1);
    outputPilot = outputFFT1(pilotIndex1);
    dt = [dt outputFFT2];

end

demodin=dt.';

end