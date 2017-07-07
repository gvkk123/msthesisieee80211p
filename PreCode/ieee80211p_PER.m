%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Estimate PER
%%
% Set the simulation parameters.
clc;
clear ;
close all;

%%
% Add path (at beginning of script)
added_path = [pwd,'/functionsfolder'];
%change to: added_path = '/path' for your required path
addpath(added_path);

%%
%Channel Bandwidth in MHz.
chanBW = 10;

%Loading Table 17-4 Timing-related parameters
prm80211p = ieee80211p_init(chanBW);

%%
%Number of Octets(Bytes) Transfer
%PSDU LENGTH
NB = 400;

%Rate-ID to determine type of modulation
rateid = 3;
% Eb/No values (dB)
EbNoVec = (7)';

%%
% Initialize the PER results vectors.
PEREst = zeros(size(EbNoVec));

%%
% The |while| loop continues to process data until 100  packet errors are
% encountered.
%
for n = 1:length(EbNoVec)
    
    %Counter for Number of Packets Transmitted.
    [numPErrs,numPTotal] = deal(0);
    
    %Counter for Number of Packets Transmitted.
    NFF=0;
    
    %Display Iterations
    fprintf('Iteration number %d for EbNo = %d.\n',n,EbNoVec(n));
    
    while numPErrs < 100 %&& numPTotal < 1e4
        
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
        ChannelMode = 2;
        [rxSignal,Ch_Coef,NoiseVariance] = ieee80211pCHANNEL(txSignal,EbNoVec(n),rateid,ChannelMode,prm80211p);
        
        % Channel Co-ef Calc. for perfect CSI
        Ch_Coef_perfectCSI = channelcoefperfectcsi(txSignal,Ch_Coef,prm80211p);
        
        % Receiver
        %rxdata = ieee80211pRX(rxSignal,rateid,numBits,NoiseVariance,prm80211p);
        rxdata = ieee80211pRX_Genie(rxSignal,Ch_Coef_perfectCSI,rateid,numBits,NoiseVariance,prm80211p);

        % Calculate the number of bit errors in the frame. Adjust for the
        % decoding delay, which is equal to the traceback depth.
        
        numErrsInFrame = biterr(txdata,rxdata);
        %tbl=64;
        %numErrsInFrame = biterr(txdata(1:end-tbl),rxdata(tbl+1:end));
        
        % Increment the Packet Error counter
        if numErrsInFrame > 0
            numPErrs = numPErrs+1;
        end
        
        % Increment the Packet counter
        numPTotal = numPTotal+1;
        NFF = NFF+1;
    end
    % Estimate the PER
    PEREst(n) = numPErrs/numPTotal;
end


%%
% Plot the estimated PER
figure
semilogy(EbNoVec,PEREst);
hold on
legend('PEREst,QPSK-1/2','location','best');
grid;
xlabel('Eb/No (dB)');
ylabel('Packet Error Rate');
title('Packet Error Rate curve for PSDU Length of 400 bytes');

%%
% Remove path (at end of script/script clean-up)
rmpath(added_path);
