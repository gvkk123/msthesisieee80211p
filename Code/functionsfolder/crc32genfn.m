% % function crcout = crcgenfn(crcin)
% % 
% % crc32genpoly = 'z^32 + z^26 + z^23 + z^22 + z^16 + z^12 + z^11 + z^10 + z^8 + z^7 + z^5 + z^4 + z^2 + z + 1';
% % 
% % end
% 
% %%
% %% Cyclic Redundancy Check of Noisy BPSK Data Frames
% % Use a CRC code to detect frame errors in a noisy BPSK signal.
% %%
% % Create a CRC generator and detector pair using a standard CRC-4
% % polynomial, $z^4 + z^3 + z^2 + z + 1$.
% 
% % Copyright 2015 The MathWorks, Inc.
% 
% crcGen = comm.CRCGenerator('z4+z3+z2+z+1');
% crcDet = comm.CRCDetector('z4+z3+z2+z+1');
% %%
% % Generate 12-bit frames of binary data and append CRC bits. Based on the
% % degree of the polynomial, 4 bits are appended to each frame. Apply BPSK
% % modulation and pass the signal through an AWGN channel. Demodulate and
% % use the CRC detector to determine if the frame is in error.
% numFrames = 20;
% frmError = zeros(numFrames,1);
% 
% k=1;
% %for k = 1:numFrames
%     data = randi([0 1],12,1);                   % Generate binary data
%     encData = step(crcGen,data);                % Append CRC bits
%     modData = pskmod(encData,2);                % BPSK modulate
%     rxSig = awgn(modData,5);                    % AWGN channel, SNR = 5 dB
%     demodData = pskdemod(rxSig,2);              % BPSK demodulate
%     [~,frmError(k)] = step(crcDet,demodData);  % Detect CRC errors
% %end
% %%
% % Identify the frames in which bit errors are detected.
% find(frmError)


%%
%close all; clear all; clc;
function crcout = crc32genfn(crcin)

crc32genpoly = 'z^32 + z^26 + z^23 + z^22 + z^16 + z^12 + z^11 + z^10 + z^8 + z^7 + z^5 + z^4 + z^2 + z + 1';


crcGen = comm.CRCGenerator(crc32genpoly);
%crcDet = comm.CRCDetector(crc32genpoly);

% Append CRC bits
crcout = step(crcGen,crcin);

end