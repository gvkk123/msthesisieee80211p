function [EQout] = channelequalizer(EQin, hD, NoiseVariance,EqMode,prm80211p)

%EQin=demodin;
% hD = 1;
% EqMode = 2;

% prm80211p.NFFT = 64;

nVar = NoiseVariance;

nSymbol = ceil(length(EQin)/prm80211p.NFFT);

% formatting the received vector into symbols
EQin1=reshape(EQin,prm80211p.NFFT,nSymbol).';

dt = []; % empty vector

for ij = 1:nSymbol
    
    EQtemp = zeros(1,prm80211p.NFFT);
    EQtemp = EQin1(ij,:);
    
    [EQtempout] = equalizer(EQtemp, hD, nVar, EqMode);
    
    dt = [dt EQtempout];
end

EQout=dt.';

end