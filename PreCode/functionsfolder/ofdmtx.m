function ofdmmodout = ofdmtx(ofdmmodin,prm80211p)

% prm80211p.NSD = 48;
% prm80211p.NST = 52;
% prm80211p.NSP = 4;
% prm80211p.NFFT = 64;
% prm80211p.NcyclicPrefix = 16;
% prm80211p.NFFT2 = prm80211p.NFFT + prm80211p.NcyclicPrefix;

% Number of OFDM Symbols
nSymbol = ceil(length(ofdmmodin)/prm80211p.NSD);

subIndex = [1:26];
subcarrierIndex = [-26:-22 -20:-8 -6:-1 1:6 8:20 22:26];%53
subcarrierIndex1=[1:5 7:19 21:32 34:46 48:52];%52
pilotIndex = [-21 -7 7 21];%53
pilotIndex1 = [6 20 33 47];%52

% Pilot final locations after re-arrangement(1:64)
ptnum = [8 22 44 58];
pt = []; % empty vector

% %Zero Padding
% z=zeros(((nSymbol*prm80211p.NST)-length(modout)),1);
% data5=[modout;z];
% Grouping into multiple symbols
ipMod = reshape(ofdmmodin,prm80211p.NSD,nSymbol).';

%Pilots Initial Polarity
pilot1=[1,1,1,-1];


st = []; % empty vector
%st=zeros(1,(nSymbol*(prm80211p.NFFT+prm80211p.NcyclicPrefix)));
ij = 2;

for ii = 1:nSymbol
    %step1
    inputiFFT1 = zeros(1,prm80211p.NST);
    inputiFFT1(subcarrierIndex1) = ipMod(ii,:);
    inputiFFT1(pilotIndex1) = zeros(1,length(pilotIndex1));
    
    %Counter increment factor for Pilot Polarity Multiplier.
    ij = mod(ij,128);
    if ij == 0
        ij =1;
    end
    
    pm = prm80211p.pilotpolarity(ij);
    
    ij = ij+1;
    %Pilot Polarity Multiplier.
    pilot2=pm*pilot1;
    
    %Pilots Insertion
    inputiFFT1(6)=pilot2(1);
    inputiFFT1(20)=pilot2(2);
    inputiFFT1(33)=pilot2(3);
    inputiFFT1(47)=pilot2(4);


%     %step1
%     inputiFFT1 = zeros(1,prm80211p.NST+1);
%     inputiFFT1(subcarrierIndex+prm80211p.NST/2+1) = ipMod(ii,:);
%     inputiFFT1(pilotIndex+prm80211p.NST/2+1) = zeros(1,length(pilotIndex));
    %step2
    inputiFFT = zeros(1,prm80211p.NFFT);
    inputiFFT(subIndex+1) = inputiFFT1(subIndex+prm80211p.NST/2);
    inputiFFT(subIndex+prm80211p.NST/2+12) = inputiFFT1(subIndex);
    
    %printing pilots.
%     inputPilot =  zeros(1,prm80211p.NSP);
%     inputPilot = inputiFFT(ptnum)

%     %step2
%     inputiFFT = zeros(1,prm80211p.NFFT);
%     inputiFFT(1) = inputiFFT1(prm80211p.NST/2+1);
%     inputiFFT(subIndex+1) = inputiFFT1(subIndex+prm80211p.NST/2+1);
%     inputiFFT(subIndex+prm80211p.NST/2+12) = inputiFFT1(subIndex);
    %step3
    outputiFFT = ifft(inputiFFT,prm80211p.NFFT);
    %step4 - adding cyclic prefix of 16 samples
    %outputiFFT_with_CP = [outputiFFT(49:64) outputiFFT];
    %step5
    st = [st outputiFFT];
% inputiFFT = zeros(1,prm80211p.NFFT);
% 
% % assigning bits a1 to a52 to subcarriers [-26 to -1, 1 to 26]
% inputiFFT(subcarrierIndex+prm80211p.NFFT/2+1) = ipMod(ii,:);
% 
% %shift subcarriers at indices [-26 to -1] to fft input indices [38 to 63]
% inputiFFT = fftshift(inputiFFT);
% 
% outputiFFT = ifft(inputiFFT,prm80211p.NFFT);
% % adding cyclic prefix of 16 samples 
% outputiFFT_with_CP = [outputiFFT(49:64) outputiFFT];
% 
% st = [st outputiFFT_with_CP]; 

end

ofdmmodout=st.';
end