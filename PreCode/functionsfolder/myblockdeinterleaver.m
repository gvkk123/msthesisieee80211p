function deinterleaverout = myblockdeinterleaver(deinterleaverin,prm80211p,rateid)

%Coded bits per OFDM symbol (NCBPS)
NCBPS=prm80211p.NCBPS(rateid);
%Coded bits per subcarrier (NBPSC)
NBPSC=prm80211p.NBPSC(rateid);

s = max(NBPSC/2,1);

i=zeros(1,NCBPS);

for j=0:(NCBPS-1)
    i(j+1)=s*floor(j/s)+mod((j+floor(16*j/NCBPS)),s);
end

i=i+1;

deinterleaverout1=zeros(1,length(deinterleaverin));

for y=1:NCBPS
    deinterleaverout1(y)=deinterleaverin(i(y));
end

k=zeros(1,NCBPS);

for ii=0:(NCBPS-1)
    k(ii+1)=16*ii-(NCBPS-1)*floor(16*ii/NCBPS);
end

k=k+1;

deinterleaverout2=zeros(1,length(deinterleaverin));

for x=1:NCBPS
    deinterleaverout2(x)=deinterleaverout1(k(x));
end

deinterleaverout=deinterleaverout2';