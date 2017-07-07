function demodout = demodulatorbank_soft(demodin,rateid,prm80211p)


switch rateid
    case 1
        %BPSK, Rate-1/2
        % Size of signal constellation        
        M=2;
        
        demodLLR = comm.PSKDemodulator('ModulationOrder',M,...
            'PhaseOffset',pi,...
            'BitOutput',true,...
            'SymbolMapping','Gray',...
            'DecisionMethod','Log-likelihood ratio');
        demoddataout = demodLLR(demodin);
        
    case 2
        %BPSK, Rate-3/4
        % Size of signal constellation
        M=2;
        
        demodLLR = comm.PSKDemodulator('ModulationOrder',M,...
            'PhaseOffset',pi,...
            'BitOutput',true,...
            'SymbolMapping','Gray',...
            'DecisionMethod','Log-likelihood ratio');
        demoddataout = demodLLR(demodin);
        
    case 3
        %QPSK, Rate-1/2
        % Size of signal constellation
        M=4;
        
        %demodLLR = comm.QPSKDemodulator(...
        demodLLR = comm.PSKDemodulator('ModulationOrder',M,...
            'PhaseOffset',pi/M,...
            'BitOutput',true,...
            'SymbolMapping','Gray',...
            'DecisionMethod','Log-likelihood ratio');
        demoddataout = demodLLR(demodin);
    
    case 4
        %QPSK, Rate-3/4
        % Size of signal constellation
        M=4;
        
        demodLLR = comm.PSKDemodulator('ModulationOrder',M,...
            'PhaseOffset',pi/M,...
            'BitOutput',true,...
            'SymbolMapping','Gray',...
            'DecisionMethod','Log-likelihood ratio');
        demoddataout = demodLLR(demodin);
        
    case 5
        % 16-QAM output , Rate-1/2 , phase offset = 0, Gray-coded
        % Size of signal constellation
        M=16;
        demoddataout = qamdemod(demodin, M,'gray','OutputType','llr','UnitAveragePower',true);
    
    case 6
        % 16-QAM output , Rate-3/4 , phase offset = 0, Gray-coded
        % Size of signal constellation
        M=16;
        demoddataout = qamdemod(demodin, M,'gray','OutputType','llr','UnitAveragePower',true);
    
    case 7
        % 64-QAM output , Rate-2/3 , phase offset = 0, Gray-coded
        % Size of signal constellation
        M=64;
        demoddataout = qamdemod(demodin, M,'gray','OutputType','llr','UnitAveragePower',true);
    
    case 8    
        % 64-QAM output , Rate-3/4 , phase offset = 0, Gray-coded
        % Size of signal constellation
        M=64;
        demoddataout = qamdemod(demodin, M,'gray','OutputType','llr','UnitAveragePower',true);
    
    otherwise
        disp('Error in Soft-Demodulator Bank');
end

%%
% % Number of bits per symbol, k=log2(M)
% k=prm80211p.NBPSC(rateid);
% %Convert the output of the demodulator into a binary column vector.
% demodSigMat = de2bi(demoddataout,k,'left-msb')';
% demodout = reshape(demodSigMat,[],1);

%%
demodout = demoddataout;

end