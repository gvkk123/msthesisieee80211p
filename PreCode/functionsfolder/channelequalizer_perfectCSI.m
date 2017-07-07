function [EQout] = channelequalizer_perfectCSI(EQin, Ch_Coef_perfectCSI, NoiseVariance,EqMode,prm80211p)

%EQin=demodin;
% hD = 1;
% EqMode = 2;

% prm80211p.NFFT = 64;

nVar = NoiseVariance;
hD1 = Ch_Coef_perfectCSI;

nSymbol = ceil(length(EQin)/prm80211p.NFFT);

% formatting the received vector into symbols
EQin1=reshape(EQin,prm80211p.NFFT,nSymbol).';
hD2=reshape(hD1,prm80211p.NFFT,nSymbol).';


dt = []; % empty vector

for ij = 1:nSymbol
    
    EQtemp = zeros(1,prm80211p.NFFT);
    EQtemp = EQin1(ij,:);
    
    hD = zeros(1,prm80211p.NFFT);
    hD = hD2(ij,:);
    
    [EQtempout] = equalizer(EQtemp, hD, nVar, EqMode);
    
    dt = [dt EQtempout];
end

EQout=dt.';

end