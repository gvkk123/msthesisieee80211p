function rateid_rx = signaldataextractor(rxSIGNALDATA ,prm80211p)

% This funtion extracts the length and rateid of the received data.

% The PLCP LENGTH field shall be an unsigned 12-bit integer that indicates 
% the number of octets in the PSDU that the MAC is currently requesting the
% PHY to transmit.

%% Removing CP

rx2 = rxSIGNALDATA(18:81);

% rx1 = rxSIGNALDATA(17:80);
% 
% rx2(1:63) = rx1(2:64);
% rx2(64) = rx2(1);

%% FFT
rx3 = fft(rx2,64);

%% sub-carrier data extraction

% prm80211p.NST = 52;
rx4=zeros(1,prm80211p.NST);
rx4(1:26) = rx3(7:32);
rx4(27:52) = rx3(34:59);

%pilotIndex = [-21 -7 7 21];%53

%pilotIndex1 = [6 20 33 47];%52

%subcarrierIndex = [-26:-22 -20:-8 -6:-1 1:6 8:20 22:26];%53
subcarrierIndex1=[1:5 7:19 21:32 34:46 48:52];%52

%prm80211p.NSD = 48;
demodin=zeros(1,prm80211p.NSD);
demodin(1:prm80211p.NSD) = rx4(subcarrierIndex1);


%% BPSK Demodulation
M =2 ;
demoddataout=pskdemod(demodin,M,pi,'gray');

%% De-Interleaving of the SIGNAL field bits
deinterleaverout=myblockdeinterleaver(demoddataout,prm80211p,1);

%% Viterbi Decoder
% Rate 1/2 convolutional encoding for SIGNAL
%Viterbi Decoder Traceback length
tbl = 16;
demodout= vitdec(deinterleaverout,prm80211p.trellis,tbl,'term','hard');

%% Data Rate Extraction

R1_R4 = demodout(1:4);

if ((R1_R4(1)==1) && (R1_R4(2)==1) && (R1_R4(3)==0) && (R1_R4(4)==1))
    rateid_rx = 1;
elseif ((R1_R4(1)==1) && (R1_R4(2)==1) && (R1_R4(3)==1) && (R1_R4(4)==1))
    rateid_rx = 2;
elseif ((R1_R4(1)==0) && (R1_R4(2)==1) && (R1_R4(3)==0) && (R1_R4(4)==1))
    rateid_rx = 3;
elseif ((R1_R4(1)==0) && (R1_R4(2)==1) && (R1_R4(3)==1) && (R1_R4(4)==1))
    rateid_rx = 4;
elseif ((R1_R4(1)==1) && (R1_R4(2)==0) && (R1_R4(3)==0) && (R1_R4(4)==1))
    rateid_rx = 5;
elseif ((R1_R4(1)==1) && (R1_R4(2)==0) && (R1_R4(3)==1) && (R1_R4(4)==1))
    rateid_rx = 6;
elseif ((R1_R4(1)==0) && (R1_R4(2)==0) && (R1_R4(3)==0) && (R1_R4(4)==1))
    rateid_rx = 7;
elseif ((R1_R4(1)==0) && (R1_R4(2)==0) && (R1_R4(3)==1) && (R1_R4(4)==1))
    rateid_rx = 8;
else
    % Falling back to lowest data rate possible, if all else fails.
    %disp('rateid_rx error');
    rateid_rx = 1;
    %rateid_rx
end

%rateid_rx

end