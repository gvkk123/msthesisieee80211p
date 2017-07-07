function demodout = demodulatorbank_hard(demodin,rateid,prm80211p)


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
demodSigMat = de2bi(demoddataout,k,'left-msb')';
demodout = reshape(demodSigMat,[],1);

end
