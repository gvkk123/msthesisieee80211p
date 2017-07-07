%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Estimate BER
%%
% Set the simulation parameters.
clc;
clear all;
close all;

%% Use default random number generator
%rng default;
%%
%Channel Bandwidth in MHz.
chanBW=10;
%Number of Frames to be Transmitted.not used here.
Nf=1;
%Number of OFDM symbols per Frame to be Transmitted.
numSymPerFrame=1000;
%Rate-ID to determine type of modulation
rateid=1;
% Eb/No values (dB)
EbNoVec = (0:10)';

%Loading Table 17-4 Timing-related parameters
prm80211p = ieee80211p_init(chanBW, numSymPerFrame, Nf );
%%
% Initialize the BER results vectors.
berEst = zeros(size(EbNoVec));
%%
% The |while| loop continues to process data until either 100 errors are
% encountered or 1e7 bits are transmitted.
%
for n = 1:length(EbNoVec)
    % Reset the error and bit counters
    [numErrs,numBitsTotal] = deal(0);
    
    %Counter for Number of Frames Transmitted.
    NFF=0;
       
    while numErrs < 200 && numBitsTotal < 1e7
        % Generate binary data and convert to symbols
        % Number of bits per frame
        numBits = numSymPerFrame*prm80211p.NSD*prm80211p.NBPSC(rateid)*prm80211p.R(rateid);
        % coderate=prm80211p.R(rateid)=R
        % k=prm80211p.NBPSC(rateid);=log2(M)
        % NSD: Number of data subcarriers=48
        
        %Generate uniformly distributed random integers
        data = randi([0 1],numBits,1);
        
        %Modulator Bank
        %modout = modulatorbank(data,rateid,numBits,prm80211p);
        modout = modulatorbankuncoded(data,rateid,numBits,prm80211p);
        
        %OFDM Modulator
        txSignal = ofdmtx(modout,prm80211p);
        
        %Channel
        % snrdB=0;
        % rxSignal = channel(txSignal,snrdB);
        %EbNoVec=5;
        rxSignal = channel(txSignal,EbNoVec(n),rateid,prm80211p);
        %demodin = channel(modout,snrdB);
        %demodin = channel(modout,EbNoVec(n),rateid,prm80211p);
        
        %OFDM Demodulator
        demodin = ofdmrx(rxSignal,prm80211p);
        
        %Demodulator Bank
        %rxdata = demodulatorbank(demodin,rateid,numBits,prm80211p);
        rxdata = demodulatorbankuncoded(demodin,rateid,numBits,prm80211p);
        
        % Calculate the number of bit errors in the frame. Adjust for the
        % decoding delay, which is equal to the traceback depth.
        %tbl=34;
        numErrsInFrame = biterr(data,rxdata);
        %numErrsInFrame = biterr(data(1:end-tbl),rxdata(tbl+1:end));
        
        % Increment the error and bit counters
        numErrs = numErrs + numErrsInFrame;
        numBitsTotal = numBitsTotal + numBits;
        NFF = NFF+1;

    end
    % Estimate the BER
    berEst(n) = numErrs/numBitsTotal;
end


%%
% Plot the estimated BER data
semilogy(EbNoVec,berEst,'-*');
hold on
semilogy(EbNoVec,berawgn(EbNoVec,'psk',2,'nondiff'));
%semilogy(EbNoVec,berawgn(EbNoVec,'qam',16));
% %berub = bercoding(EbNo,'conv',decision,coderate,dspec);
%trellis = poly2trellis(7,[171 133]);
dspec = distspec(prm80211p.trellis);
berub = bercoding(EbNoVec,'conv','hard',1/2,dspec);
%berub = bercoding(EbNoVec,'conv','hard',1/2,dspec,'qam',16);
semilogy(EbNoVec,berub);
%legend('Decoded','Theoritical Uncoded BPSK','Theoritical Coded BPSK UB','location','best');
legend('Decoded','Theoritical Uncoded 16-QAM','Theoritical Coded 16-QAM UB','location','best');
grid;
xlabel('Eb/No (dB)');
ylabel('Bit Error Rate');
title('Bit error probability curve for BPSK,OFDM with no coding gain');
%title('Bit error probability curve for 16-QAM with OFDM, with coding gain');