function Ch_Coef_perfectCSI = channelcoefperfectcsi2(txSignal,Ch_Coef,prm80211p)

%% This uses LTS symbols instead of txsignal for CSI estimation
N = prm80211p.NFFT;

% %% Generating LTS
% %p.long_training_symbol
% lt=[1, 1, -1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 1, 1,...
%     -1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 0, 1, -1, -1, 1, 1, -1, 1, -1,...
%     1, -1, -1, -1, -1, -1, 1, 1, -1, -1, 1, -1, 1, -1, 1, 1, 1, 1];
% % Frequency Domain Long Sequence.
% lt2=[0,0,0,0,0,0,lt,0,0,0,0,0];
% %Time domain representation of the long sequence
% lt3=ifft(lt2,64);
% 
% lt4=[lt3(49:64),lt3];
% lt5 = lt4.';

%%
lt = hadamard(8);
lt2 = lt(:).';
lt3=ifft(lt2,64);

lt4=[lt3(49:64),lt3];
lt5 = lt4.';

%% Changing TXSIGNAL to all LTS for estimation purpose.
txSignal = ones(length(txSignal),1);
count = length(txSignal)/80;

jj =1;
for k = 1:count
    for i =1:80
        txSignal(jj,1) = lt5(i);
        jj = jj + 1;
    end
end

txSignal_Chan = txSignal.*Ch_Coef;

%% PPDU Frame Separator for TX SIGNAL
[~, ~, ~, txWDATA1] = ppduframedissembler(txSignal);
CPremin1 = txWDATA1;

%% Cyclic Prefix Removal for TX SIGNAL
ofdmtx1 = CPremover(CPremin1,prm80211p);

%% PPDU Frame Separator for channel modulated TX SIGNAL
[~, ~, ~, txWDATA2] = ppduframedissembler(txSignal_Chan);
CPremin2 = txWDATA2;

%% Cyclic Prefix Removal for channel modulated TX SIGNAL
ofdmtx2 = CPremover(CPremin2,prm80211p);

%%
nSymbol = ceil(length(ofdmtx1)/N);

% formatting the received vector into symbols
tx1=reshape(ofdmtx1,N,nSymbol).';
tx2=reshape(ofdmtx2,N,nSymbol).';

dt = []; % empty vector
%st = [];

for ij = 1:nSymbol
    
    inputFFT1 = zeros(1,N);
    inputFFT2 = zeros(1,N);
    
    inputFFT1 = tx1(ij,:);
    inputFFT2 = tx2(ij,:);
    
    XX = fft(inputFFT1,N);
    YY = fft(inputFFT2,N);
    
    % outputFFT = (fft(inputFFT2,N))./(fft(inputFFT1,N));
    outputFFT = YY./XX;
    
    dt = [dt outputFFT];
    
    %outputIFFT = ifft(outputFFT,N);
    
    %st = [st outputIFFT];
end

Ch_Coef_perfectCSI=dt.';

end
