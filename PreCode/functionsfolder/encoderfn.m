function encoderout = encoderfn(encoderin,rateid,numBits,prm80211p)

%% SERVICE field prepending.

%prepended by the 16 SERVICE field bits and are appended by 6 tail bits
%Scrambler Initialization. 7 Zero Bits.

scrin=[0 0 0 0 0 0 0];

%Reserved Bits
reser=[0 0 0 0 0 0 0 0 0];

%Tail Bits
tl=[0 0 0 0 0 0];

scrdata=[scrin reser encoderin' tl];

scrdata1=scrdata';

%% Zero Padding

% numBits1 = numBits+ 16 Service bits + 6 Tail bits

numBits1=numBits+22;

zp=zeros((((ceil(numBits1/prm80211p.NDBPS(rateid)))...
    *prm80211p.NDBPS(rateid))-numBits1),1);

% zp=zeros((((ceil(numBits/prm80211p.NDBPS(rateid)))...
%     *prm80211p.NDBPS(rateid))-numBits),1);

zpdata1=[scrdata1;zp];

%% SCRAMBLER

initial_state = [1 0 1 1 1 0 1];

zpdata2 = scramblerfn(zpdata1, initial_state);

% Changing last 6 bits to zeros after scrambling.
% only at place of 6 zero bits
sixplaces = numBits+16+1 : numBits+16+6;

zpdata2(sixplaces) = 0;

zpdata = zpdata2;
%zpdata3 = [0 0 0 0 0 0];

%zpdata = [zpdata2(1:end-6);zpdata3'];

%% Encoding data - Convolutional Encoder

%Number of bits per symbol k=log2(M)
%k=prm80211p.NBPSC(rateid);
%codeRate=prm80211p.R(rateid);

NCBPS=prm80211p.NCBPS(rateid);

%Define trellis.
%trellis = poly2trellis(ConstraintLength,CodeGenerator);
%trellis=poly2trellis(7, [171 133]);
t=prm80211p.trellis;

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

%% Block Interleaver

interleaverin=reshape(codeddata,length(codeddata)/NCBPS,NCBPS);
interleaverout=zeros(length(codeddata)/NCBPS,NCBPS);
for ij=1:length(codeddata)/NCBPS
    interleaverout(ij,:)=myblockinterleaver(interleaverin(ij,:),prm80211p,rateid);
end

%%
encoderout=reshape(interleaverout,length(codeddata),1);

end