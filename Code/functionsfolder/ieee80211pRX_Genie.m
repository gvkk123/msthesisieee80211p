%% IEEE 802.11p RECEIVER

function rxdata = ieee80211pRX_Genie(rxSignal,Ch_Coef_perfectCSI,rateid,numBits,NoiseVariance,prm80211p)
%% PPDU Frame Separator
%[rxpreambleout, rxsignalfield, CPremin] = ppduframedissembler(rxSignal);
[rxSTS, rxLTS, rxSIGNALDATA, rxWDATA] = ppduframedissembler(rxSignal);
CPremin = rxWDATA;
rxpreambleout = rxLTS;

%% Data Rate Extractor -- Not using
% rateid_rx = signaldataextractor(rxSIGNALDATA ,prm80211p);
rateid_rx = rateid;
%disp('rateid_rx=');disp(rateid_rx);

%% Cyclic Prefix Removal
ofdmrxin = CPremover(CPremin,prm80211p);

%% OFDM Demodulator (FFT)
EQin = ofdmrx(ofdmrxin,prm80211p);

%% COMB-TYPE Pilot Separator
%combpilots = combseparatorfn(EQin,prm80211p);

%% Channel Estimation -- NOT USED HERE
% estmode = 1;
% [estcoef] = channelestimator(rxpreambleout,prm80211p, estmode);

%% Channel Equalizer
EqMode = 1;
[EQout] = channelequalizer_perfectCSI(EQin, Ch_Coef_perfectCSI,NoiseVariance,EqMode,prm80211p);

%% OFDM Symbol Separation
demodin = ofdmrxsplit(EQout,prm80211p);

%% Demodulator Bank
demodout = demodulatorbank_soft(demodin,rateid_rx,prm80211p);
% demodout = demodulatorbank_hard(demodin,rateid_rx,prm80211p);

%rxdata = demodulatorbankuncoded(demodin,rateid,numBits,prm80211p);

%% Decoding and De-Interleaving
decoderin=demodout;

decoderout = decoderfn_unquant(decoderin,rateid_rx,numBits,NoiseVariance,prm80211p);
% decoderout = decoderfn_soft(decoderin,rateid_rx,numBits,NoiseVariance,prm80211p);
% decoderout = decoderfn_hard(decoderin,rateid_rx,numBits,prm80211p);

rxdata=decoderout;

%% Figures

% scatterplot(demodin,1,0,'g.');
% grid;
% title('Rx. Gray-coded Symbol Mapping')

end
