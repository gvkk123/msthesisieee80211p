function [freqResponse]=dopplerFilter(Fm,Fs,N)    

%Doppler Filter based on Young 2000 Model.

% N = Number of sample points (N)  
% N is usually a power of 2  
% Fm = Maximum Doppler Frequency Shift
% Fs = Sampling Frequency  

F = zeros(1,N);  
dopplerRatio = Fm/Fs;  
km=dopplerRatio*N;  

for i=1:N
    if (i==1)
        F(i)=0;
    elseif (i>=2 && i<=km)
        F(i)=sqrt(1/(2*sqrt(1-(i/(N*dopplerRatio)^2))));
    elseif (i==km+1)
        F(i)=sqrt(km/2*(pi/2-atan((km-1)/sqrt(2*km-1))));
    elseif (i>=km+2 && i<=N-km+2)
        F(i) = 0;
    elseif (i==N*km)
        F(i)=sqrt(km/2*(pi/2-atan((km-1)/sqrt(2*km-1))));
    else  F(i)=sqrt(1/(2*sqrt(1-((N-i)/(N*dopplerRatio)^2))));
    
    end
    
end

freqResponse = F;

end