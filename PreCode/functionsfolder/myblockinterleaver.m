function interleaverout = myblockinterleaver(interleaverin,prm80211p,rateid)

%Block Interleaver

%Interleaver is defined by a two-step permutation

%Coded bits per OFDM symbol (NCBPS)
NCBPS=prm80211p.NCBPS(rateid);
%Coded bits per subcarrier (NBPSC)
NBPSC=prm80211p.NBPSC(rateid);

%First permutation ensures that adjacent coded bits are mapped onto
%nonadjacent subcarriers.


%Second permutation ensures that adjacent coded bits are mapped alternately
%onto less and more significant bits of the constellation and, thereby, 
%long runs of low reliability (LSB) bits are avoided.

%Index of the coded bit before the first permutation shall be denoted by k.

%i shall be the index after the first and before the second permutation.

%j shall be the index after second permutation, just prior to modulation mapping.

s = max(NBPSC/2,1);

i=zeros(1,NCBPS);

for k=0:(NCBPS-1)
    i(k+1)=(NCBPS/16)*(mod(k,16))+floor(k/16);
end

i=i+1;

interleaverout1=zeros(1,length(interleaverin));

for x=1:NCBPS
    interleaverout1(x)=interleaverin(i(x));
end

j=zeros(1,NCBPS);

for ii=0:(NCBPS-1)
    j(ii+1)=s*floor(ii/s)+mod((ii+NCBPS-floor(16*ii/NCBPS)),s);
end

j=j+1;

interleaverout2=zeros(1,length(interleaverin));

for y=1:NCBPS
    interleaverout2(y)=interleaverout1(j(y));
end

interleaverout=interleaverout2';