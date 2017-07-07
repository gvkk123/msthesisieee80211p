function modout = modulatorbank(modin,rateid,prm80211p)


% Number of bits per symbol k=log2(M)
k=prm80211p.NBPSC(rateid);
NCBPS=prm80211p.NCBPS(rateid);

codeRate=prm80211p.R(rateid);
    
%Rearranging data for conversion from binary to integer.
codewordMat = reshape(modin,k,length(modin)/k)';

%Binary to Decimal Conversion
txSym = bi2de(codewordMat,'left-msb');

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
