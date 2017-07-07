function rxdata = demodulatorbank(demodin,rateid,numBits,prm80211p)

% %Define trellis.
% %trellis = poly2trellis(ConstraintLength,CodeGenerator);
% trellis = poly2trellis(7,[171 133]);
%Viterbi Decoder Traceback length
tbl=96;
NCBPS=prm80211p.NCBPS(rateid);

switch rateid
    case 1
        %BPSK, Rate-1/2
        % Size of signal constellation        
        M=2;
        demoddataout=pskdemod(demodin,M,pi,'gray');
        
    case 2
        %BPSK, Rate-3/4
        % Size of signal constellation
        M=2;
        demoddataout=pskdemod(demodin,M,pi,'gray');
    case 3
        %QPSK, Rate-1/2
        % Size of signal constellation
        M=4;
        demoddataout=pskdemod(demodin,M,pi/M,'gray');
    case 4
        %QPSK, Rate-3/4
        % Size of signal constellation
        M=4;
        demoddataout=pskdemod(demodin,M,pi/M,'gray');
    case 5
        % 16-QAM output , Rate-1/2 , phase offset = 0, Gray-coded
        % Size of signal constellation
        M=16;
        demoddataout = qamdemod(demodin, M,'gray','OutputType','integer','UnitAveragePower',true);
    case 6
        % 16-QAM output , Rate-3/4 , phase offset = 0, Gray-coded
        % Size of signal constellation
        M=16;
        demoddataout = qamdemod(demodin, M,'gray','OutputType','integer','UnitAveragePower',true);
    case 7
        % 64-QAM output , Rate-2/3 , phase offset = 0, Gray-coded
        % Size of signal constellation
        M=64;
        demoddataout = qamdemod(demodin, M,'gray','OutputType','integer','UnitAveragePower',true);
    case 8    
        % 64-QAM output , Rate-3/4 , phase offset = 0, Gray-coded
        % Size of signal constellation
        M=64;
        demoddataout = qamdemod(demodin, M,'gray','OutputType','integer','UnitAveragePower',true);
    otherwise
        clc;
end

% Number of bits per symbol, k=log2(M)
k=prm80211p.NBPSC(rateid);
%Convert the output of the demodulator into a binary column vector.
demodSigMat = de2bi(demoddataout,k);
demodSig = demodSigMat(:);

%De-Interleaving Data
%Block De-Interleaver
deinterleaverin=reshape(demodSig,length(demodSig)/NCBPS,NCBPS);
deinterleaverout=zeros(length(demodSig)/NCBPS,NCBPS);
for ij=1:length(demodSig)/NCBPS
    deinterleaverout(ij,:)=myblockdeinterleaver(deinterleaverin(ij,:),prm80211p,rateid);
end
demodSigBinary=reshape(deinterleaverout,length(demodSig),1);

%demodSigBinary = deinterleaverin;
%demodSigBinary = myblockdeinterleaver(deinterleaverin,prm80211p,rateid);

%Viterbi Decoder
%Decoding data
if (rateid == 1 ||  rateid == 3 ||rateid == 5)
    demodout= vitdec(demodSigBinary,prm80211p.trellis,tbl,'cont','hard');
elseif (rateid == 2 ||rateid == 4 || rateid == 6 ||rateid == 8)
    %codepuncturepattern=[1 1 0 1 1 0].'; for rate 3/4
    codepuncturepattern34=[1 1 0 1 1 0].';
    demodout= vitdec(demodSigBinary,prm80211p.trellis,tbl,'term','hard',codepuncturepattern34);
elseif (rateid == 7)
    %codepuncturepattern=[1 1 1 0].'; for rate 2/3
    codepuncturepattern23=[1 1 1 0].';
    demodout= vitdec(demodSigBinary,prm80211p.trellis,tbl,'term','hard',codepuncturepattern23);
end

%Remove Zero Padding
rxdata=demodout(1:numBits,:);