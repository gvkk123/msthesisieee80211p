
%% Tapped Delay Line Model

function [rxSignal,Ch_Coef,NoiseVariance] = channel_TDL(txSignal,EbNoVec,rateid,prm80211p)

%% Tap-Delay Channel
N = length(txSignal);

% 1.V2V Expressway Oncoming
% 2.V2V Urban Canyon Oncoming
% 3.RTV Expressway
% 4.RTV Urban Canyon
V2VChannelModel_Num =4 ;

[h] = TDLChannelModel(N,V2VChannelModel_Num);

txSignal_Chan = txSignal.*h;

Ch_Coef = h;
%% AWGN Noise
k=prm80211p.NBPSC(rateid);
codeRate=prm80211p.R(rateid);
numSamplesPerSymbol=1;
%numSamplesPerSymbol=Tsym/Tsamp for complex signals

snrdB=EbNoVec + 10*log10(k*codeRate*(48/64))-10*log10(numSamplesPerSymbol);

%NoiseVariance_Th = (10.^(-snrdB/10))/2;

%%
[rxSignal, NoiseVariance] = awgn_ofdm(txSignal_Chan,snrdB);

end


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

%%
%using SNR
% function rxSignal = channel(txSignal,snrdB)
% 
% rxSignal = awgn(txSignal,snrdB,'measured');
% 
% end


%%
% function rxSignal = channel(txSignal,EbNoVec,rateid,prm80211p)
% 
% k=prm80211p.NBPSC(rateid);
% codeRate=prm80211p.R(rateid);
% numSamplesPerSymbol=1;
% %numSamplesPerSymbol=Tsym/Tsamp for complex signals
% 
% 
% 
% %snrdB = EbNoVec + 10*log10(k*codeRate)-10*log10(numSamplesPerSymbol);
% snrdB=10;
% rxSignal = awgn(txSignal,snrdB,'measured');
% estimatednv =  (1/length(rxSignal))*(rxSignal-txSignal)'*(rxSignal-txSignal);
% 10*log10(1/(2*estimatednv))
% end
%%

% %%using EbNo
% function rxSignal = channel(txSignal,EbNo)
% 
% %EbNo = 10;
% %snrdB = EbNo + 10*log10(k*codeRate)-10*log10(numSamplesPerSymbol);
% rxSignal = awgn(txSignal,snrdB,'measured');
% 
% end

% % Convert Eb/No to SNR
% EbNoVec(n)--Eb/No values (dB)
%k = log2(M);            % Bits per symbol
% snrdB = EbNoVec(n) + 10*log10(k);
% 
% EbN0dB = [0:10]; % bit to noise ratio
% EsN0dB = EbN0dB + 10*log10(nDSC/nFFT) + 10*log10(64/80); % converting to symbol to noise ratio