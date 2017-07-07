function bertheory = theoryber(rateid,encoded,EbNoVec,prm80211p)

%%codeRate
r=prm80211p.R(rateid);

if encoded==1
    dspec = distspec(prm80211p.trellis);
elseif encoded==0
    rateid=rateid+8;
end


switch rateid
    %%%%%%%%%%%%%%%%%%%%%%%
    %Coded BER
    %%%%%%%%%%%%%%%%%%%%%%%
    case 1
        %BPSK, Rate-1/2
        %berub = bercoding(EbNo,'conv',decision,coderate,dspec)
        berub = bercoding(EbNoVec,'conv','hard',r,dspec);
        bertheory=berub;
    case 2
        %BPSK, Rate-3/4
        M=2;
        berub = bercoding(EbNoVec,'conv','hard',r,dspec);
        bertheory=berub;
    case 3
        %QPSK, Rate-1/2
        M=4;
        berub = bercoding(EbNoVec,'conv','hard',r,dspec);
        bertheory=berub;
    case 4
        %QPSK, Rate-3/4
        M=4;
        berub = bercoding(EbNoVec,'conv','hard',r,dspec);
        bertheory=berub;
    case 5
        %QAM, Rate-1/2
        M=16;
        berub = bercoding(EbNoVec,'conv','hard',r,dspec,'qam',M);
        bertheory=berub;
    case 6
        %QAM, Rate-3/4
        M=16;
        berub = bercoding(EbNoVec,'conv','hard',r,dspec,'qam',M);
        bertheory=berub;
    case 7
        %QAM, Rate-2/3
        M=64;
        berub = bercoding(EbNoVec,'conv','hard',r,dspec,'qam',M);
        bertheory=berub;
    case 8
        %QAM, Rate-3/4
        M=64;
        berub = bercoding(EbNoVec,'conv','hard',r,dspec,'qam',M);
        bertheory=berub;
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %Uncoded BER
        %%%%%%%%%%%%%%%%%%%%%%%%
    case 9||10
        %BPSK
        M=2;
        bertheory=berawgn(EbNoVec,'psk',M,'nondiff');
    case 11||12
        %QPSK
        M=4;
        bertheory=berawgn(EbNoVec,'psk',M,'nondiff');
    case 13||14
        %16-QAM
        M=16;
        bertheory = berawgn(EbNoVec,'qam',M);
    case 15||16
        %64-QAM
        M=64;
        bertheory = berawgn(EbNoVec,'qam',M);
end