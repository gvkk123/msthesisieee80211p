function demodin = ofdmrx(ofdmrxin,prm80211p)

% prm80211p.NSD = 48;
% prm80211p.NST = 52;
% prm80211p.NSP = 4;
% prm80211p.NFFT = 64;
% prm80211p.NcyclicPrefix = 16;
% prm80211p.NFFT2 = prm80211p.NFFT + prm80211p.NcyclicPrefix;

nSymbol = ceil(length(ofdmrxin)/prm80211p.NFFT);

% formatting the received vector into symbols
rx1=reshape(ofdmrxin,prm80211p.NFFT,nSymbol).';
% % removing cyclic prefix
% rx2 = rx1(:,17:80);
rx2 = rx1;
%rx1=rx1';

subIndex = [1:26];
subcarrierIndex = [-26:-22 -20:-8 -6:-1 1:6 8:20 22:26];%53
subcarrierIndex1=[1:5 7:19 21:32 34:46 48:52];%52
pilotIndex = [-21 -7 7 21];%53
pilotIndex1 = [6 20 33 47];%52


%%

dt = []; % empty vector

for ij = 1:nSymbol
    
    inputFFT = zeros(1,prm80211p.NFFT);
    inputFFT = rx2(ij,:);
    outputFFT = fft(inputFFT,prm80211p.NFFT);

    dt = [dt outputFFT];
end

demodin=dt.';
end