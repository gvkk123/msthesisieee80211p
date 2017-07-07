function modout = modulatorbank(data,rateid,numBits,prm80211p)

%Zero Padding
zp=zeros((((ceil(numBits/prm80211p.NDBPS(rateid)))...
    *prm80211p.NDBPS(rateid))-numBits),1);
zpdata=[data;zp];


% Number of bits per symbol k=log2(M)
k=prm80211p.NBPSC(rateid);
NCBPS=prm80211p.NCBPS(rateid);

codeRate=prm80211p.R(rateid);

%Define trellis.
%trellis = poly2trellis(ConstraintLength,CodeGenerator);
%trellis=poly2trellis(7, [171 133]);
t=prm80211p.trellis;

%Encoding data - Convolutional Encoder.
if (rateid == 1 ||  rateid == 3 ||rateid == 5)
    codeddata=convenc(zpdata,t);
elseif (rateid == 2 ||rateid == 4 || rateid == 6 ||rateid == 8)
    %codepuncturepattern=[1 1 0 1 1 0].'; for rate 3/4
    codepuncturepattern34=[1 1 0 1 1 0].';
    codeddata=convenc(zpdata,t,codepuncturepattern34);
elseif (rateid == 7)
    %codepuncturepattern=[1 1 1 0].'; for rate 2/3
    codepuncturepattern23=[1 1 1 0].';
    codeddata=convenc(zpdata,t,codepuncturepattern23);
end

%Block Interleaver
interleaverin=reshape(codeddata,length(codeddata)/NCBPS,NCBPS);
interleaverout=zeros(length(codeddata)/NCBPS,NCBPS);
for ij=1:length(codeddata)/NCBPS
    interleaverout(ij,:)=myblockinterleaver(interleaverin(ij,:),prm80211p,rateid);
end
interleaverout1=reshape(interleaverout,length(codeddata),1);
    
%Rearranging data for conversion from binary to integer.
codewordMat = reshape(interleaverout1,length(interleaverout1)/k,k);

%Interleaving Data
%codedinterleaverout=codeddata;
%codedinterleaverout = myblockinterleaver(codeddata,prm80211p,rateid);

%Binary to Decimal Conversion
txSym = bi2de(codewordMat);

switch rateid
    case 1
        %BPSK, Rate-1/2
        % Size of signal constellation
        M=2;
        modout = pskmod(txSym,M,pi,'gray');
    case 2
        %BPSK, Rate-3/4
        % Size of signal constellation
        M=2;
        modout = pskmod(txSym,M,pi,'gray');
    case 3
        %QPSK, Rate-1/2
        % Size of signal constellation
        M=4;
        modout = pskmod(txSym,M,pi/M,'gray');
    case 4
        %QPSK, Rate-3/4
        % Size of signal constellation
        M=4;
        modout = pskmod(txSym,M,pi/M,'gray');
    case 5
        %QAM, Rate-1/2
        % Size of signal constellation
        M=16;
        %Symbol Order
        %symOrder=
        modout = qammod(txSym,M,'gray','PlotConstellation',false,'InputType','integer','UnitAveragePower',true);
    case 6
        %QAM, Rate-3/4
        % Size of signal constellation
        M=16;
        modout = qammod(txSym,M,'gray','PlotConstellation',false,'InputType','integer','UnitAveragePower',true);
    case 7
        %QAM, Rate-2/3
        % Size of signal constellation
        M=64;
        modout = qammod(txSym,M,'gray','PlotConstellation',false,'InputType','integer','UnitAveragePower',true);
    case 8
        %QAM, Rate-3/4
        % Size of signal constellation
        M=64;
        modout = qammod(txSym,M,'gray','PlotConstellation',false,'InputType','integer','UnitAveragePower',true);
    otherwise
        clc;
end

% scatterplot(modout)
% text(real(modout)+0.1, imag(modout), dec2bin(txSym));
% title('Tx. Gray-coded Symbol Mapping')
% grid on;
% %axis([-1.5 1.5 -1.5 1.5]);