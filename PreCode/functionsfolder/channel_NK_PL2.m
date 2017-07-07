%%  Working AWGN
% %using EbNo
% %CORRECCTION TERM to be changed from 48 to 52 after pilots are added.
% function [rxSignal, noiseSigma] = channel(txSignal,EbNoVec,rateid,prm80211p)
% 
% k=prm80211p.NBPSC(rateid);
% codeRate=prm80211p.R(rateid);
% numSamplesPerSymbol=1;
% %numSamplesPerSymbol=Tsym/Tsamp for complex signals
% 
% %snrdB=10;
% snrdB=EbNoVec + 10*log10(k*codeRate*(48/64))-10*log10(numSamplesPerSymbol);
% %snrdB = EbNoVec + 10*log10(k*codeRate)-10*log10(numSamplesPerSymbol);
% %snrdB=EbNoVec + 10*log10(k*(48/64))-10*log10(numSamplesPerSymbol);
% %rxSignal = awgn(txSignal,snrdB,'measured');
% [rxSignal, noiseSigma] = awgn_ofdm(txSignal,snrdB);
% %rxSignal=txSignal;
% end

%% Nakagami Path Loss Model -this takes transmitted power(EbN0) as input.CONTAINS ERRORS . NOT USED

function [rxSignal,Ch_Coef,NoiseVariance] = channel_NK_PL2(txSignal,EbNoVec,dist,rateid,prm80211p)

%% AWGN Noise
k=prm80211p.NBPSC(rateid);
codeRate=prm80211p.R(rateid);
numSamplesPerSymbol=1;
%numSamplesPerSymbol=Tsym/Tsamp for complex signals


snrdB=EbNoVec + 10*log10(k*codeRate*(48/64))-10*log10(numSamplesPerSymbol);

Pnoise_dBm = -99;
Pr_dBm_d = snrdB + Pnoise_dBm;

disp('Received Power[dBm]=');disp(Pr_dBm_d);
disp('snrdB=');disp(snrdB);

%% Nakagami Fading
N = length(txSignal);

% Select Dataset for path-loss modelling
dataset_selector = 1;
[Pr_dBm_d,H_Nakagami_pl] = nakagami_pl_modelfn2(Pt_dBm,N,dist,dataset_selector);
%[Pr_dBm_d,H_Nakagami_pl] = nakagami_pl_modelfn(Pt_dBm,N,dist);


txSignal_Chan = txSignal.*H_Nakagami_pl';

Ch_Coef = H_Nakagami_pl';

%% AWGN Noise


Pnoise_dBm = -99;
snrdB = Pr_dBm_d - Pnoise_dBm;

disp('Received Power[dBm]=');disp(Pr_dBm_d);
disp('snrdB=');disp(snrdB);
%snrdB=10;
% snrdB=EbNoVec + 10*log10(k*codeRate*(48/64))-10*log10(numSamplesPerSymbol);

%snrdB = EbNoVec + 10*log10(k*codeRate)-10*log10(numSamplesPerSymbol);
%snrdB=EbNoVec + 10*log10(k*(48/64))-10*log10(numSamplesPerSymbol);
%rxSignal = awgn(txSignal,snrdB,'measured');
[rxSignal, NoiseVariance] = awgn_ofdm(txSignal_Chan,snrdB);
%rxSignal=txSignal;
end
