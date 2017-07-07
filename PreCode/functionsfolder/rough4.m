%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All rights reserved by Krishna Pillai, http://www.dsplog.com
% The file may not be re-distributed without explicit authorization
% from Krishna Pillai.
% Checked for proper operation with Octave Version 3.0.0
% Author        : Krishna Pillai
% Email         : krishna@dsplog.com
% Version       : 1.0
% Date          : 14th January 2009
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Script for computing BER with Binary Convolutional Code 
% and Viterbi decoding. 
% Convolutional code of Rate-1/2, Generator polynomial - [7,5] octal 
% Hard decision and soft decison decoding is used. 

clear
N = 10^6 ;% number of bits or symbols

Eb_N0_dB = [0:1:10]; % multiple Eb/N0 values
Ec_N0_dB = Eb_N0_dB - 10*log10(2);

refHard = [0 0 ; 0 1; 1 0  ; 1 1 ];
refSoft = -1*[-1 -1; -1 1 ;1 -1; 1 1 ];

ipLUT = [ 0   0   0   0;...
	  0   0   0   0;...
          1   1   0   0;...
	  0   0   1   1 ];

for yy = 1:length(Eb_N0_dB)

   % Transmitter
   ip = rand(1,N)>0.5; % generating 0,1 with equal probability

   % convolutional coding, rate - 1/2, generator polynomial - [7,5] octal
   cip1 = mod(conv(ip,[1 1 1 ]),2);
   cip2 = mod(conv(ip,[1 0 1 ]),2);
   cip = [cip1;cip2];
   cip = cip(:).';

   s = 2*cip-1; % BPSK modulation 0 -> -1; 1 -> 0 

   n = 1/sqrt(2)*[randn(size(cip)) + j*randn(size(cip))]; % white gaussian noise, 0dB variance 

   % Noise addition
   y = s + 10^(-Ec_N0_dB(yy)/20)*n; % additive white gaussian noise

   % receiver 
   cipHard = real(y)>0; % hard decision
   cipSoft = real(y);   % soft decision

   % Viterbi decoding
   pmHard  = zeros(4,1);  % hard path metric
   svHard_v  = zeros(4,length(y)/2); % hard survivor path
   pmSoft  = zeros(4,1);  % soft path metric
   svSoft_v  = zeros(4,length(y)/2); % soft survivor path
   
   for ii = 1:length(y)/2
      rHard = cipHard(2*ii-1:2*ii); % taking 2 hard bits
      rSoft = cipSoft(2*ii-1:2*ii); % taking 2 soft bits
      
      % computing the Hamming distance and euclidean distance
      rHardv = kron(ones(4,1),rHard);
      rSoftv = kron(ones(4,1),rSoft);
      hammingDist = sum(xor(rHardv,refHard),2);
      euclideanDist = sum(rSoftv.*refSoft,2);
 

      if (ii == 1) || (ii == 2) 

         % branch metric and path metric for state 0
         bm1Hard = pmHard(1,1) + hammingDist(1);
         pmHard_n(1,1)  = bm1Hard; 
         svHard(1,1)  = 1; 
         bm1Soft = pmSoft(1,1) + euclideanDist(1);
         pmSoft_n(1,1)  = bm1Soft; 
         svSoft(1,1)  = 1; 
 
         % branch metric and path metric for state 1
         bm1Hard = pmHard(3,1) + hammingDist(3);
         pmHard_n(2,1) = bm1Hard;
         svHard(2,1)  = 3; 
         bm1Soft = pmSoft(3,1) + euclideanDist(3);
         pmSoft_n(2,1) = bm1Soft;
         svSoft(2,1)  = 3; 
         

         % branch metric and path metric for state 2
         bm1Hard = pmHard(1,1) + hammingDist(4);
         pmHard_n(3,1) = bm1Hard;
         svHard(3,1)  = 1; 
         bm1Soft = pmSoft(1,1) + euclideanDist(4);
         pmSoft_n(3,1) = bm1Soft;
         svSoft(3,1)  = 1; 

         % branch metric and path metric for state 3
         bm1Hard = pmHard(3,1) + hammingDist(2);
         pmHard_n(4,1) = bm1Hard;
         svHard(4,1)  = 3; 
         bm1Soft = pmSoft(3,1) + euclideanDist(2);
         pmSoft_n(4,1) = bm1Soft;
         svSoft(4,1)  = 3; 

      else
         % branch metric and path metric for state 0
         bm1Hard = pmHard(1,1) + hammingDist(1);
         bm2Hard = pmHard(2,1) + hammingDist(4);
         [pmHard_n(1,1) idx] = min([bm1Hard,bm2Hard]);
         svHard(1,1)  = idx; 
         bm1Soft = pmSoft(1,1) + euclideanDist(1);
         bm2Soft = pmSoft(2,1) + euclideanDist(4);
         [pmSoft_n(1,1) idx] = min([bm1Soft,bm2Soft]);
         svSoft(1,1)  = idx; 
 
         % branch metric and path metric for state 1
         bm1Hard = pmHard(3,1) + hammingDist(3);
         bm2Hard = pmHard(4,1) + hammingDist(2);
         [pmHard_n(2,1) idx] = min([bm1Hard,bm2Hard]);
         svHard(2,1)  = idx+2; 
         bm1Soft = pmSoft(3,1) + euclideanDist(3);
         bm2Soft = pmSoft(4,1) + euclideanDist(2);
         [pmSoft_n(2,1) idx] = min([bm1Soft,bm2Soft]);
         svSoft(2,1)  = idx+2; 

         % branch metric and path metric for state 2
         bm1Hard = pmHard(1,1) + hammingDist(4);
         bm2Hard = pmHard(2,1) + hammingDist(1);
         [pmHard_n(3,1) idx] = min([bm1Hard,bm2Hard]);
         svHard(3,1)  = idx; 
         bm1Soft = pmSoft(1,1) + euclideanDist(4);
         bm2Soft = pmSoft(2,1) + euclideanDist(1);
         [pmSoft_n(3,1) idx] = min([bm1Soft,bm2Soft]);
         svSoft(3,1)  = idx; 

         % branch metric and path metric for state 3
         bm1Hard = pmHard(3,1) + hammingDist(2);
         bm2Hard = pmHard(4,1) + hammingDist(3);
         [pmHard_n(4,1) idx] = min([bm1Hard,bm2Hard]);
         svHard(4,1)  = idx+2; 
         bm1Soft = pmSoft(3,1) + euclideanDist(2);
         bm2Soft = pmSoft(4,1) + euclideanDist(3);
         [pmSoft_n(4,1) idx] = min([bm1Soft,bm2Soft]);
         svSoft(4,1)  = idx+2; 

      end
   
   pmHard = pmHard_n; 
   svHard_v(:,ii) = svHard;
   pmSoft = pmSoft_n; 
   svSoft_v(:,ii) = svSoft;

   end

   % trace back unit
   currHardState = 1;
   currSoftState = 1;
   ipHatHard_v = zeros(1,length(y)/2);
   ipHatSoft_v = zeros(1,length(y)/2);
   for jj = length(y)/2:-1:1
      prevHardState   = svHard_v(currHardState,jj); 
      ipHatHard_v(jj) = ipLUT(currHardState,prevHardState);
      currHardState   = prevHardState;

      prevSoftState   = svSoft_v(currSoftState,jj); 
      ipHatSoft_v(jj) = ipLUT(currSoftState,prevSoftState);
      currSoftState   = prevSoftState;
   end

   % counting the errors
   nErrHardViterbi(yy) = size(find([ip- ipHatHard_v(1:N)]),2);
   nErrSoftViterbi(yy) = size(find([ip- ipHatSoft_v(1:N)]),2);

end

simBer_HardViterbi = nErrHardViterbi/N; % simulated ber - hard decision Viterbi decoding BER
simBer_SoftViterbi = nErrSoftViterbi/N; % simulated ber - soft decision Viterbi decoding BER

theoryBer = 0.5*erfc(sqrt(10.^(Eb_N0_dB/10))); % theoretical ber uncoded AWGN

close all
figure
semilogy(Eb_N0_dB,theoryBer,'bd-','LineWidth',2);
hold on
semilogy(Eb_N0_dB,simBer_HardViterbi,'mp-','LineWidth',2);
semilogy(Eb_N0_dB,simBer_SoftViterbi,'cd-','LineWidth',2);
axis([0 10 10^-5 0.5])
grid on
legend('theory - uncoded', 'simulation - hard Viterbi', 'simulation - soft Viterbi');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('BER for BCC with Viterbi decoding for BPSK in AWGN');
