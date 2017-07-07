function CP_OFDM = CPadder(ofdmmodout,prm80211p)

% prm80211p.NSD = 48;
% prm80211p.NFFT = 64;
% prm80211p.NcyclicPrefix = 16;
% prm80211p.NFFT2 = prm80211p.NFFT + prm80211p.NcyclicPrefix;

%step4 - adding cyclic prefix of 16 samples

% Number of OFDM Symbols
nSymbol = ceil(length(ofdmmodout)/prm80211p.NFFT);

ip = reshape(ofdmmodout,prm80211p.NFFT,nSymbol).';

st = [];
for ii = 1:nSymbol
    
    outputiFFT = ip(ii,:);
    
    outputiFFT_with_CP = [outputiFFT(49:64) outputiFFT];
    
    st = [st outputiFFT_with_CP];
    
end

CP_OFDM = st.';
end