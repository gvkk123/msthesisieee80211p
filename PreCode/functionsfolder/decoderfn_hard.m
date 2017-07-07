function decoderout = decoderfn_hard(decoderin,rateid,numBits,prm80211p)

NCBPS=prm80211p.NCBPS(rateid);

demodSig=decoderin;

%% De-Interleaving Data -- Block De-Interleaver

deinterleaverin=reshape(demodSig,length(demodSig)/NCBPS,NCBPS);
deinterleaverout=zeros(length(demodSig)/NCBPS,NCBPS);
for ij=1:length(demodSig)/NCBPS
    deinterleaverout(ij,:)=myblockdeinterleaver(deinterleaverin(ij,:),prm80211p,rateid);
end
demodSigBinary=reshape(deinterleaverout,length(demodSig),1);

%% Viterbi Decoder -- Decoding data

% %Define trellis.
% %trellis = poly2trellis(ConstraintLength,CodeGenerator);
% trellis = poly2trellis(7,[171 133]);
%Viterbi Decoder Traceback length
tbl=64;

%nsdec = 3;

if (rateid == 1 ||  rateid == 3 ||rateid == 5)
    demodout= vitdec(demodSigBinary,prm80211p.trellis,tbl,'term','hard');
elseif (rateid == 2 ||rateid == 4 || rateid == 6 ||rateid == 8)
    %codepuncturepattern=[1 1 0 1 1 0].'; for rate 3/4
    codepuncturepattern34=[1 1 0 1 1 0].';
    demodout= vitdec(demodSigBinary,prm80211p.trellis,tbl,'term','hard',codepuncturepattern34);
elseif (rateid == 7)
    %codepuncturepattern=[1 1 1 0].'; for rate 2/3
    codepuncturepattern23=[1 1 1 0].';
    demodout= vitdec(demodSigBinary,prm80211p.trellis,tbl,'term','hard',codepuncturepattern23);
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