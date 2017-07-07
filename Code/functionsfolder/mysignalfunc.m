function signalfield = mysignalfunc(rateid,prm80211p)

%SIGNAL Field generation

%rateid=6;
%%
switch rateid
    case 1
        R1_R4=[1 1 0 1];
    case 2
        R1_R4=[1 1 1 1];
    case 3
        R1_R4=[0 1 0 1];
    case 4
        R1_R4=[0 1 1 1];
    case 5
        R1_R4=[1 0 0 1];
    case 6
        R1_R4=[1 0 1 1];
    case 7
        R1_R4=[0 0 0 1];
    case 8
        R1_R4=[0 0 1 1];
end
%%
%Bits 0 to 3 - Signal Rate, Modulation type
b0_b3=R1_R4;

%Bit 4 - Reserved for future use
b4=0;

%Bits 5 to 16 LENGTH field of TXVECTOR
%b5-LSB,b16-MSB
%b5_b16=[0 0 0 0 0 0 0 0 0 0 0 0];
 b5_b16=[0 0 1 0 0 1 1 0 0 0 0 0];

%Bit 17 - Even Parity bit for b5_b16
b17=0;

%Bits 18-23 TAIL Field, set to 0;
b18_b23=[0 0 0 0 0 0];

signaldata=[b0_b3 b4 b5_b16 b17 b18_b23];
%%
% Rate 1/2 convolutional encoding for SIGNAL
%Define trellis.
%trellis = poly2trellis(ConstraintLength,CodeGenerator);
%trellis=poly2trellis(7, [133 171]);
t=prm80211p.trellis;

encodedsignaldata=convenc(signaldata,t);
%%
%Interleaving of the SIGNAL field bits
%interleaveddata=myblockinterleaver(encodedsignaldata,prm80211p,rateid);
%rateid=1 always in this case.
interleaveddata=myblockinterleaver(encodedsignaldata,prm80211p,1);

% deinterleaverin=interleaveddata;
% deinterleaverout=myblockdeinterleaver(deinterleaverin,prm80211p,1);
% 
% f=biterr(encodedsignaldata',deinterleaverout);
%%

%BPSK modulating of SIGNAL field bits
% Size of signal constellation
M=2;
modout = pskmod(interleaveddata,M,pi,'gray');
%%
%Pilot Polarity Multiplier.
pm = prm80211p.pilotpolarity(1);

%Pilots
pilot1=[1,1,1,-1];
pilot2=pm*pilot1;

%%
%pilotIndex = [-21 -7 7 21];%53
%pilotIndex1 = [6 20 33 47];%52

%subcarrierIndex = [-26:-22 -20:-8 -6:-1 1:6 8:20 22:26];%53
subcarrierIndex1=[1:5 7:19 21:32 34:46 48:52];%52

% prm80211p.NST = 52;
modout2=zeros(1,prm80211p.NST);
modout2(subcarrierIndex1)=modout(:);

%Pilots Insertion
modout2(6)=pilot2(1);
modout2(20)=pilot2(2);
modout2(33)=pilot2(3);
modout2(47)=pilot2(4);

% prm80211p.NFFT = 64;
modout3=zeros(1,prm80211p.NFFT);
modout3(7:32)=modout2(1:26);
modout3(34:59)=modout2(27:52);

%%
%IFFT
modout4=ifft(modout3,64);

modout5 = [modout4(48:64) modout4];

modout6=[0.5*modout5(1),modout5(2:80),0.5*modout5(81)];

signalfield=modout6;

end