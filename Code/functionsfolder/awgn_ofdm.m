function [rxSignal, NoiseVariance] = awgn_ofdm(txSignal,snrdB)

%%
%y=awgn_ofdm(x,SNR) adds AWGN noise vector to signal 'x' to generate a
%resulting signal vector y of specified SNR in dB

%set the random generator seed to default (for comparison only)
%rng('default');
%%

L=length(txSignal);

SNR = 10^(snrdB/10); %SNR to linear scale

Esym=sum(abs(txSignal).^2)/(L); %Calculate actual symbol energy

N0=Esym/SNR; %Find the noise spectral density

%%

if(isreal(txSignal))
    
    %Standard deviation for AWGN Noise when x is real
    NoiseSigma = sqrt(N0);
    %computed noise
    n = NoiseSigma*randn(1,L);

else
    
    %Standard deviation for AWGN Noise when x is complex
    NoiseSigma=sqrt(N0/2);
    %computed noise
    n = NoiseSigma*(randn(1,L)-1i*randn(1,L));
    
end

%received signal
rxSignal = txSignal + n.'; 

%% Noise Variance

NoiseVariance = var(n);

end