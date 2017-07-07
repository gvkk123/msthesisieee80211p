%Function to add AWGN to a given signal
 
%Authored by Mathuranathan Viswanathan 
 
%How to generate AWGN noise in Matlab/Octave by Mathuranathan Viswanathan 
 
%is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0  International License.
 
%You must credit the author in your work if you remix, tweak, and build upon the work below
 
function y = add_awgn_noise(x,SNR_dB)
    %y=awgn_noise(x,SNR) adds AWGN noise vector to signal 'x' to generate a
    %resulting signal vector y of specified SNR in dB
    rng('default');%set the random generator seed to default (for comparison only)
    L=length(x);
    SNR = 10^(SNR_dB/10); %SNR to linear scale
    Esym=sum(abs(x).^2)/(L); %Calculate actual symbol energy
    N0=Esym/SNR; %Find the noise spectral density
    if(isreal(x)),
        noiseSigma = sqrt(N0);%Standard deviation for AWGN Noise when x is real
        n = noiseSigma*randn(1,L);%computed noise
    else
        noiseSigma=sqrt(N0/2);%Standard deviation for AWGN Noise when x is complex
        n = noiseSigma*(randn(1,L)+1i*randn(1,L));%computed noise
    end    
    y = x + n; %received signal    
end