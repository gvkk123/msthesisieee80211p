function Ch_Coef_perfectCSI = channelcoefperfectcsi3(txSignal,Ch_Coef,prm80211p)

%% Processing only H
%%
N = prm80211p.NFFT;
%% PPDU Frame Separator for Channel Co-ef.
[~, ~, ~, txWDATA1] = ppduframedissembler(Ch_Coef);
CPremin1 = txWDATA1;

%% Cyclic Prefix Removal for Channel Co-ef.
ofdmtx1 = CPremover(CPremin1,prm80211p);

%%
nSymbol = ceil(length(ofdmtx1)/N);

% formatting the received vector into symbols
tx1=reshape(ofdmtx1,N,nSymbol).';

dt = []; % empty vector

for ij = 1:nSymbol
    
    inputFFT1 = zeros(1,N);
    
    inputFFT1 = tx1(ij,:);
    
    XX = fft(inputFFT1,N);
    
    outputFFT = XX;
    
    dt = [dt outputFFT];

end

Ch_Coef_perfectCSI=dt.';
end
