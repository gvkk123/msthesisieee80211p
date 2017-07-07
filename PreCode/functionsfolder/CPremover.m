function ofdmrxin = CPremover(CPremin,prm80211p)


% prm80211p.NSD = 48;
% prm80211p.NST = 52;
% prm80211p.NSP = 4;
% prm80211p.NFFT = 64;
% prm80211p.NcyclicPrefix = 16;
% prm80211p.NFFT2 = prm80211p.NFFT + prm80211p.NcyclicPrefix;

nSymbol = ceil(length(CPremin)/prm80211p.NFFT2);

% formatting the received vector into symbols
rx1=reshape(CPremin,prm80211p.NFFT2,nSymbol).';
% removing cyclic prefix
rx2 = rx1(:,17:80);

dt = []; % empty vector

for ij = 1:nSymbol
    
    rx3 = rx2(ij,:);
    dt = [dt rx3];
    
end

ofdmrxin = dt.';

end