%% COMB-TYPE Pilot Separator

% This function separates the comb-type pilots for channel estimation.

function combpilots = combseparatorfn(EQin,prm80211p)

% prm80211p.NSD = 48;
% prm80211p.NST = 52;
% prm80211p.NSP = 4;
% prm80211p.NFFT = 64;
% prm80211p.NcyclicPrefix = 16;
% prm80211p.NFFT2 = prm80211p.NFFT + prm80211p.NcyclicPrefix;

nSymbol = ceil(length(EQin)/prm80211p.NFFT);

% formatting the received vector into symbols
rx1=reshape(EQin,prm80211p.NFFT,nSymbol).';

subIndex = [1:26];
subcarrierIndex = [-26:-22 -20:-8 -6:-1 1:6 8:20 22:26];%53
subcarrierIndex1=[1:5 7:19 21:32 34:46 48:52];%52
pilotIndex = [-21 -7 7 21];%53
pilotIndex1 = [6 20 33 47];%52

% Pilot final locations after re-arrangement(1:64)
ptnum = [8 22 44 58];

%Pilots Initial Polarity
pilot1=[1,1,1,-1];

ij = 2;

pt = []; % empty vector

for jj = 1:nSymbol

    %% Recieved Pilots
    outputFFT = rx1(jj,:);
    
    outputPilot =  zeros(1,prm80211p.NSP);
    
    outputPilot = outputFFT(ptnum)
    
    %% Transmitted Pilots
    %Counter increment factor for Pilot Polarity Multiplier.
    ij = mod(ij,128);
    if ij == 0
        ij =1;
    end
    
    pm = prm80211p.pilotpolarity(ij);
    
    ij = ij+1;
    %Pilot Polarity Multiplier.
    pilot2=pm*pilot1;
    
    %Pilots Insertion
    inputPilot(1)=pilot2(3);
    inputPilot(2)=pilot2(4);
    inputPilot(3)=pilot2(1);
    inputPilot(4)=pilot2(2);
    
    inputPilot
    
    %% COMB-TYPE LS ESTIMATION for Pilot Positions
    
    H_LS = outputPilot./inputPilot
    
    %% Interpolation of Pilots
    
    
    
    
    
end

combpilots = outputPilot;

end