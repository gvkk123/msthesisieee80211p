function [rxSignal,Ch_Coef,NoiseVariance] = channel_awgn(txSignal,EbNoVec,rateid,prm80211p)
%using EbNo
%CORRECCTION TERM to be changed from 48 to 52 after pilots are added.

k=prm80211p.NBPSC(rateid);
codeRate=prm80211p.R(rateid);
numSamplesPerSymbol=1;
%numSamplesPerSymbol=Tsym/Tsamp for complex signals


snrdB=EbNoVec + 10*log10(k*codeRate*(48/64))-10*log10(numSamplesPerSymbol);

% EbNoVec=snrdB-10*log10(k*codeRate*(48/64))+10*log10(numSamplesPerSymbol);

%rng('default');
%rxSignal1 = awgn(txSignal,snrdB,'measured');

%rng('default');
[rxSignal, NoiseVariance] = awgn_ofdm(txSignal,snrdB);

Ch_Coef = ones(length(txSignal),1);

 %NoiseVariance_Th = (10^(-snrdB/10));
 %NoiseVariance = NoiseVariance_Th;

end