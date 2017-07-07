function prm80211p = ieee80211p_init(chanBW)

%%
% clc;
% clear all;
% %Dummies
% chanBW=10;
% Nf=20;
% numSymPerFrame=16;

%%
p.trellis = poly2trellis(7,[133 177]);
%RateID=0;

%%
%Table 17-4-Timing-related parameters

%Channel spacing = 20MHz for IEEE802.11a
%Channel spacing = 10MHz for IEEE802.11p
p.BW=chanBW*10^6;
%NSD: Number of data subcarriers=48
p.NSD=48;
%NSP: Number of pilot subcarriers=4
p.NSP=4;
%NST: Number of subcarriers, total=52
p.NST=p.NSD+p.NSP;
%NFFT: Total subcarriers=64
p.NFFT=p.NST+12;
%DF: Subcarrier frequency spacing=0.15625MHz
p.DF=p.BW/p.NFFT;
%TFFT: Inverse Fast Fourier Transform (IFFT) / Fast Fourier Transform (FFT)
%period=6.4us
p.TFFT=1/p.DF;
%TGI: GI duration (TFFT/4)=1.6us
p.TGI=p.TFFT/4;
%TGI2: Training symbol GI duration (TFFT/2)=3.2us
p.TGI2=p.TFFT/2;
%TSYM: Symbol interval (TGI + TFFT)=8us
p.TSYM=p.TGI + p.TFFT;
%TSIGNAL: Duration of the SIGNAL BPSK-OFDM symbol=8us
p.TSIGNAL=p.TGI + p.TFFT;
%TSHORT: Short training sequence duration=16us
p.TSHORT=10*(p.TFFT/4);
%TLONG: Long training sequence duration=16us
p.TLONG=(p.TGI2+2*p.TFFT);
%TPREAMBLE: PLCP preamble duration (TSHORT + TLONG)=32us
p.TPREAMBLE=p.TSHORT + p.TLONG;
%Cyclic Prefix Length
p.NcyclicPrefix = 16;
p.NFFT2 = p.NFFT + p.NcyclicPrefix;

%%
%%17.3.3 PLCP preamble (SYNC)

p.short_training_symbol=sqrt(13/6) * [0, 0, 1+1i, 0, 0, 0, -1-1i, 0, 0, 0,...
    1+1i, 0, 0, 0, -1-1i, 0, 0, 0, -1-1i, 0, 0, 0, 1+1i, 0, 0, 0, 0, 0,...
    0, 0, -1-1i, 0, 0, 0, -1-1i, 0, 0, 0, 1+1i, 0, 0, 0, 1+1i, 0, 0, 0,...
    1+1i, 0, 0, 0, 1+1i, 0,0];

p.long_training_symbol=[1, 1, -1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 1, 1,...
    -1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 0, 1, -1, -1, 1, 1, -1, 1, -1,...
    1, -1, -1, -1, -1, -1, 1, 1, -1, -1, 1, -1, 1, -1, 1, 1, 1, 1];

p.pilots=[0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,...
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...
    0, 0, 0, -1, 0, 0, 0, 0, 0];

p.pilotpolarity=[1,1,1,1, -1,-1,-1,1, -1,-1,-1,-1, 1,1,-1,1, -1,-1,1,1,...
    -1,1,1,-1, 1,1,1,1, 1,1,-1,1,1,1,-1,1, 1,-1,-1,1, 1,1,-1,1,...
    -1,-1,-1,1, -1,1,-1,-1, 1,-1,-1,1, 1,1,1,1, -1,-1,1,1,-1,-1,1,-1, ...
    1,-1,1,1, -1,-1,-1,1, 1,-1,-1,-1, -1,1,-1,-1, 1,-1,1,1, 1,1,-1,1, ...
    -1,1,-1,1,-1,-1,-1,-1, -1,1,-1,1, 1,-1,1,-1, 1,1,1,-1, -1,1,-1,-1,...
    -1,1,1,1, -1,-1,-1,-1, -1,-1,-1];

%%
%Table 17-3 Modulation-dependent parameters
% Modulator/Demodulator banks

%Modulation (BPSK,QPSK,16-QAM, 64-QAM)
p.numModulators = 8;
%Coding rate(R)
p.R = [1/2 3/4 1/2 3/4 1/2 3/4 2/3 3/4];
%Coded bits per subcarrier (NBPSC)
p.NBPSC = [1 1 2 2 4 4 6 6];
%Data bits per subcarrier
p.bitsPerSymbol = p.NBPSC .* p.R;


%Coded bits per OFDM symbol (NCBPS)
p.NCBPS = p.NSD * p.NBPSC;
%Data bits per OFDM symbol (NDBPS)
p.NDBPS = p.NCBPS .* p.R;

%%

%Number of OFDM symbols per Frame to be Transmitted.
numSymPerFrame=126;

%Number of Frames to be Transmitted.
Nf=1;

%Number of Frames to be Transmitted
p.numFrames=Nf;
%Number of OFDM symbols per Frame
p.numOFDMSymbols = numSymPerFrame;
%Dummy numPreSym=12;
numPreSym=12;
% Number of preamble OFDM symbols per Frame
p.numPreamOFDMSymbols = numPreSym;
% Number of Total OFDM symbols
%p.totOFDMSym = p.numOFDMSymbols + p.numPreamOFDMSymbols;

% Number of total TX OFDM symbols (Coded Data only)
p.numTxSymbols = p.numOFDMSymbols * p.numFrames;
% Number of total Preamble symbols
p.numTrainingSymbols = p.numPreamOFDMSymbols * p.numFrames;
p.txBitsPerSymBlk = p.NSD * p.numTxSymbols .* p.NBPSC;
p.txBitsPerBlk = p.txBitsPerSymBlk .* p.R;
p.maxBitsPerBlk = max(p.txBitsPerBlk);

%%
 % Timing-related parameters
p.symbolPeriod = p.TSYM/p.NSD;
%blkPeriod = symbolPeriod * NSD * p.numOFDMSymbols;
p.bitPeriod = p.symbolPeriod ./ p.bitsPerSymbol;
p.minBitPeriod =  min(p.bitPeriod);
%%
%%chanTs = p.blkPeriod/(p.totOFDMSym * (p.nfft+p.CPLen)); % channel sample period
prm80211p=p;
%assignin('base', 'prm80211p', p);

end