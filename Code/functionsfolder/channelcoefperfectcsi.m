function Ch_Coef_perfectCSI = channelcoefperfectcsi(txSignal,Ch_Coef,prm80211p)

%%
N = prm80211p.NFFT;
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
    
    %EE = (conj(XX))./((conj(XX).*XX));
    %outputFFT = YY.*EE;
    
    dt = [dt outputFFT];
    
    %outputIFFT = ifft(outputFFT,N);
    
    %st = [st outputIFFT];
end

Ch_Coef_perfectCSI=dt.';
end
