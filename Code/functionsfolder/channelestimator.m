function [estcoef] = channelestimator(rxpreambleout,prm80211p, estmode)

% Channel Estimation from Long Training Symbols

% Original Transmit Sequence
txpreambleout = preamblegenfn(prm80211p);
txWLTS = txpreambleout(161:321);
txL = length(txWLTS);
txLTS = [2*0.5*txWLTS(1) txWLTS(2:txL-1) 2*txWLTS(txL)];

NFFT = 64;

%LTS1 = txLTS(1:NFFT);
txLTS2 = txLTS(NFFT+1:2*NFFT);
txLTS1 = txLTS2;

% Received Sequence
rxWLTS = rxpreambleout.';
%rxWLTS = rxpreambleout(161:321);
rxL = length(rxWLTS);
rxLTS = [2*0.5*txWLTS(1) txWLTS(2:rxL-1) 2*0.5*txWLTS(rxL)];

rxLTS1 = [rxLTS(2*NFFT+1) rxLTS(2:NFFT)];
rxLTS2 = rxLTS(NFFT+1:2*NFFT);

% Converting to Frequency Domain

rxlts1 = fft(rxLTS1,NFFT);
rxlts2 = fft(rxLTS2,NFFT);

txlts1 = fft(txLTS1,NFFT);
txlts2 = fft(txLTS2,NFFT);

% estmode = 1;
% X = txlts1;
% Y = rxlts1;
[H1] = estimator(txlts1,rxlts1, estmode);
[H2] = estimator(txlts2,rxlts2, estmode);

% Averaged Estimation
H = (H1+H2)/2;

estcoef = H;