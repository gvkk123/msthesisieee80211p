function decoderout = decoderfn_soft(decoderin,rateid,numBits,NoiseVariance,prm80211p)

NCBPS=prm80211p.NCBPS(rateid);

demodSig=decoderin;

%% De-Interleaving Data -- Block De-Interleaver

deinterleaverin=reshape(demodSig,length(demodSig)/NCBPS,NCBPS);
deinterleaverout=zeros(length(demodSig)/NCBPS,NCBPS);
for ij=1:length(demodSig)/NCBPS
    deinterleaverout(ij,:)=myblockdeinterleaver(deinterleaverin(ij,:),prm80211p,rateid);
end
demodSigBinary=reshape(deinterleaverout,length(demodSig),1);


%% Quantizer Block
% *Quantization for soft-decoding*
%
% Before using a |comm.ViterbiDecoder| object in the soft-decision mode,
% the output of the demodulator needs to be quantized. This example uses a
% |comm.ViterbiDecoder| object with a |SoftInputWordLength| of 3. This
% value is a good compromise between short word lengths and a small BER
% penalty. Create a
% ScalarQuantizerEncoder> object with 3-bit quantization.
scalQuant = dsp.ScalarQuantizerEncoder('Partitioning','Unbounded');
%snrdB = EbNo + 10*log10(k);
%NoiseVariance = 10.^(-snrdB/10);

scalQuant.BoundaryPoints = (-1.5:0.5:1.5)/NoiseVariance;

%% Quantizing Data
% _Soft-decision decoding_
%
% Pass the demodulated data to the quantizer. This data must be multiplied
% by |-1| before being passed to the quantizer, because, in soft-decision
% mode, the Viterbi decoder assumes that positive numbers correspond to 1s
% and negative numbers to 0s. Pass the quantizer output to the Viterbi
% decoder. Compute the error statistics.
quantizedValue1 = scalQuant(-demodSigBinary);
quantizedValue = double(quantizedValue1);

%% Viterbi Decoder -- Decoding data

% %Define trellis.
% %trellis = poly2trellis(ConstraintLength,CodeGenerator);
% trellis = poly2trellis(7,[171 133]);
%Viterbi Decoder Traceback length
tbl=64;

nsdec = 3;

if (rateid == 1 ||  rateid == 3 ||rateid == 5)
    demodout= vitdec(quantizedValue,prm80211p.trellis,tbl,'term','soft',nsdec);
elseif (rateid == 2 ||rateid == 4 || rateid == 6 ||rateid == 8)
    %codepuncturepattern=[1 1 0 1 1 0].'; for rate 3/4
    codepuncturepattern34=[1 1 0 1 1 0].';
    demodout= vitdec(quantizedValue,prm80211p.trellis,tbl,'term','soft',nsdec,codepuncturepattern34);
elseif (rateid == 7)
    %codepuncturepattern=[1 1 1 0].'; for rate 2/3
    codepuncturepattern23=[1 1 1 0].';
    demodout= vitdec(quantizedValue,prm80211p.trellis,tbl,'term','soft',nsdec,codepuncturepattern23);
end

%% DE-SCRAMBLING DATA

initial_state = [1 0 1 1 1 0 1];

demodout1 = descramblerfn(demodout, initial_state);

%% Remove Zero Padding

% numBits1 = numBits+ 16 Service bits + 6 Tail bits
numBits1=numBits+22;

%Since demodout1 = demodout2 + zero_padded_bits, taking out only demodout2.

demodout2=demodout1(1:numBits1,:);

%% Remove Service field Prepended data and Tail Bits.

%16 SERVICE Field bits, 6 Tail Bits.

decoderout=demodout2(17:(length(demodout2)-6),:);

end