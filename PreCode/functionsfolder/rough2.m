%{
Alexander Serrano & Max Howald
ECE 408 - Wireless Communications
Prof. Keene
02/18/16
802.11a Standard
%}


%% SIMULATION PARAMETERS ( source: Mathworks  ) 
clc;
close all;
clear all;
% See 17.3.2.2-3 Timing & rate-related parameters in 802.11a standard doc
% We implement 12 Mbits/s (QPSK, rate 1/2 code), and 6 Mbits/s (BPSK, rate
% 1/2 code) Note: selected because there's no (easy) way to calculate the
% theory curve for higher order modulations with FEC, AFAIK (at least, it
% can't be done with bercoding()).

% http://www.wardriving.ch/hpneu/info/doku/802.11a-1999.pdf
% http://www.mathworks.com/help/comm/gs/qpsk-and-ofdm-with-matlab-system-objects-1.html

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Common Stuff   %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

numSC = 52;            % Number of OFDM subcarriers  (standard -> 52 (table 79, 17.3.2.3)
cpLen = 16;            % OFDM cyclic prefix length
maxBitErrors = 100;    % Maximum number of bit errors
maxNumBits = 1e5;      % Maximum number of bits transmitted

hConEnc = comm.ConvolutionalEncoder;
hDec = comm.ViterbiDecoder('InputFormat','Hard');
delay = hDec.TracebackDepth*...
                    log2(hDec.TrellisStructure.numInputSymbols);
hError = comm.ErrorRate('ReceiveDelay',delay,'ResetInputPort', true);
codeRate = hDec.TrellisStructure.numInputSymbols / hDec.TrellisStructure.numOutputSymbols;
% see link below for more info on convolutional encoding
% http://www.mathworks.com/help/comm/ref/comm.convolutionalencoder-class.html

%set modulator and demodulator
hQPSKMod = comm.QPSKModulator('BitInput',true);
hQPSKDemod = comm.QPSKDemodulator('BitOutput',true);

hOFDMmod = comm.OFDMModulator('FFTLength',numSC,'CyclicPrefixLength',cpLen,'NumGuardBandCarriers',[2;2]);
hOFDMdemod = comm.OFDMDemodulator('FFTLength',numSC,'CyclicPrefixLength',cpLen,'NumGuardBandCarriers',[2;2]);

hChan = comm.AWGNChannel('NoiseMethod','Variance', ...
    'VarianceSource','Input port');

ofdmInfo = info(hOFDMmod); 
numDC = ofdmInfo.DataInputSize(1) ; 
EbNoVec = (-2:0.5:3)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% QPSK, rate 1/2 %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
M = 4;                 % Modulation Order
k = log2(M);           % # of bits per symbol


% if configured correctly, size should be 48 (17.3.2.2, table 78). 
frameSize = [k*numDC*codeRate 1];

snrVec = EbNoVec + 10*log10(k) + 10*log10(numDC/numSC);
berVec = zeros(length(EbNoVec),3);

parfor m = 1:length(EbNoVec)
    snr = snrVec(m);
    errorStats = zeros(1,3);
    dataIn = zeros(frameSize);
    dataOut = zeros(frameSize);
    while errorStats(2) <= maxBitErrors && errorStats(3) <= maxNumBits
        dataIn = randi([0,1],frameSize);              % Generate binary data
        dataECC = step(hConEnc, dataIn);              % Apply Convolutional Code
        qpskTx = step(hQPSKMod,dataECC);              % Apply QPSK modulation
        txSig = step(hOFDMmod,qpskTx);                % Apply OFDM modulation
        powerDB = 10*log10(var(txSig));               % Calculate Tx signal power
        noiseVar = 10.^(0.1*(powerDB-snr));           % Calculate the noise variance
        rxSig = step(hChan,txSig,noiseVar);           % Pass the signal through a noisy channel
        qpskRx = step(hOFDMdemod,rxSig);              % Apply OFDM demodulation
        ECCOut = step(hQPSKDemod,qpskRx);             % Apply QPSK demodulation
        dataOut = step(hDec, ECCOut);                 % Apply convolutional decode
        errorStats = step(hError,dataIn,dataOut,0);   % Collect error statistics
    end

    berVec(m,:) = errorStats;                         % Save BER data
    errorStats = step(hError,dataIn,dataOut,1);       % Reset the error rate calculator
end

correctionFactor = 10*log10(1/codeRate); % to calculate effective SNR given the code rate
berTheory = bercoding(EbNoVec+correctionFactor,'conv','hard',codeRate,distspec(hDec.TrellisStructure));

figure
semilogy(EbNoVec,berVec(:,1),'*')
hold on
semilogy(EbNoVec,berTheory)
legend('Simulation','Theory','Location','Best')
xlabel('Eb/No (dB)')
ylabel('Bit Error Rate')
title('12 Mbit/s Data rate (QPSK)')
grid on
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% BPSK, rate 1/2 %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% http://www.wardriving.ch/hpneu/info/doku/802.11a-1999.pdf
%http://www.mathworks.com/help/comm/gs/qpsk-and-ofdm-with-matlab-system-objects-1.html
M = 2;                 % Modulation Order
k = log2(M);           % # of bits per symbol

%set modulator and demodulator
hBPSKMod = comm.BPSKModulator;
hBPSKDemod = comm.BPSKDemodulator;

% if configured correctly, size should be 24 (17.3.2.2, table 78).
frameSize = [k*numDC*codeRate 1];

snrVec = EbNoVec + 10*log10(k) + 10*log10(numDC/numSC);
berVec = zeros(length(EbNoVec),3);

parfor m = 1:length(EbNoVec)
    snr = snrVec(m);
    errorStats = zeros(1,3);
    dataIn = zeros(frameSize);
    dataOut = zeros(frameSize);
    while errorStats(2) <= maxBitErrors && errorStats(3) <= maxNumBits
        dataIn = randi([0,1],frameSize);              % Generate binary data
        dataECC = step(hConEnc, dataIn);              % Apply Convolutional Code
        qpskTx = step(hBPSKMod,dataECC);              % Apply BPSK modulation
        txSig = step(hOFDMmod,qpskTx);                % Apply OFDM modulation
        powerDB = 10*log10(var(txSig));               % Calculate Tx signal power
        noiseVar = 10.^(0.1*(powerDB-snr));           % Calculate the noise variance
        rxSig = step(hChan,txSig,noiseVar);           % Pass the signal through a noisy channel
        qpskRx = step(hOFDMdemod,rxSig);              % Apply OFDM demodulation
        ECCOut = step(hBPSKDemod,qpskRx);             % Apply BPSK demodulation
        dataOut = step(hDec, ECCOut);                 % Apply convolutional decode
        errorStats = step(hError,dataIn,dataOut,0);   % Collect error statistics
    end

    berVec(m,:) = errorStats;                         % Save BER data
    errorStats = step(hError,dataIn,dataOut,1);       % Reset the error rate calculator
end

correctionFactor = 10*log10(1/codeRate); % to calculate effective SNR given the code rate
berTheory = bercoding(EbNoVec+correctionFactor,'conv','hard',codeRate,distspec(hDec.TrellisStructure));

figure
semilogy(EbNoVec,berVec(:,1),'*')
hold on
semilogy(EbNoVec,berTheory)
legend('Simulation','Theory','Location','Best')
xlabel('Eb/No (dB)')
ylabel('Bit Error Rate')
title('6 Mbit/s Data rate (BPSK)')
grid on
hold off