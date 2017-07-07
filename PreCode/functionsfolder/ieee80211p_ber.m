%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Estimate BER
%%
% Set the simulation parameters.
clc;
clear all;
close all;

%%
%Channel Bandwidth in MHz.
chanBW=10;

%Loading Table 17-4 Timing-related parameters
prm80211p = ieee80211p_init(chanBW);

%%
%Number of Octets(Bytes) Transfer
%PSDU LENGTH
NB=400;

%Rate-ID to determine type of modulation
rateid=3
% Eb/No values (dB)
EbNoVec = (0:5)';

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
    
    %Display Iterations
    fprintf('Iteration number %d for EbNo = %d.\n',n,EbNoVec(n));
    
    while numErrs < 100 && numBitsTotal < 1e3
        
        % Generate binary data and convert to symbols
        numBits = 8*NB;
        
        %Generate uniformly distributed random integers
        txdata = randi([0 1],numBits,1);
        
        %TX
        txSignal = ieee80211pTX(txdata,rateid,numBits,prm80211p);
        
        % Wireless Channel
        % EbNoVec=10;
        % ChannelMode - Decides the type of channel.
        % ChannelMode = 1 - No Channel, 2 - AWGN, 3 - TDL, 4 - Nakagami-m
        % For Channel Mode 4, EbNoVec, does not refer to EbN0, It refers to the
        % transmitted power - Pt_dBm
        ChannelMode = 4;
        [rxSignal,Ch_Coef,NoiseVariance] = ieee80211pCHANNEL(txSignal,EbNoVec(n),rateid,ChannelMode,prm80211p);
                
        %RX
        rxdata = ieee80211pRX(rxSignal,rateid,numBits,NoiseVariance,prm80211p);
        
        % Calculate the number of bit errors in the frame. Adjust for the
        % decoding delay, which is equal to the traceback depth.
        
        numErrsInFrame = biterr(txdata,rxdata);
        %tbl=64;
        %numErrsInFrame = biterr(txdata(1:end-tbl),rxdata(tbl+1:end));
        
        % Increment the error and bit counters
        numErrs = numErrs + numErrsInFrame;
        numBitsTotal = numBitsTotal + numBits;
        NFF = NFF+1;

    end
    % Estimate the BER
    berEst(n) = numErrs/numBitsTotal;
end


%%
% Plot the estimated BER data BPSK
semilogy(EbNoVec,berEst,'-*');
hold on
semilogy(EbNoVec,berawgn(EbNoVec,'psk',4,'nondiff'));
% %berub = bercoding(EbNo,'conv',decision,coderate,dspec);
%trellis = poly2trellis(7,[133 171]);
dspec = distspec(prm80211p.trellis);
berub = bercoding(EbNoVec,'conv','soft',1/2,dspec,'qam',4);
semilogy(EbNoVec,berub);
%plot(ebno0,ber0)
legend('Decoded - AWGN Channel ','Theoritical Uncoded QPSK','Theoritical Coded QPSK UB','location','best');
grid;
xlabel('Eb/No (dB)');
ylabel('Bit Error Rate');
title('Bit error probability curve for QPSK with OFDM, with coding gain');

%%
% %Plot the estimated BER data 16-QAM
% semilogy(EbNoVec,berEst,'-*');
% hold on
% semilogy(EbNoVec,berawgn(EbNoVec,'qam',16));
% % %berub = bercoding(EbNo,'conv',decision,coderate,dspec);
% %trellis = poly2trellis(7,[171 133]);
% dspec = distspec(prm80211p.trellis);
% berub = bercoding(EbNoVec,'conv','hard',1/2,dspec,'qam',16);
% semilogy(EbNoVec,berub);
% %plot(ebno0,ber0)
% legend('Decoded','Theoritical Uncoded 16-QAM','Theoritical Coded 16-QAM UB','location','best');
% grid;
% xlabel('Eb/No (dB)');
% ylabel('Bit Error Rate');
% title('Bit error probability curve for 16-QAM with OFDM, with coding gain');