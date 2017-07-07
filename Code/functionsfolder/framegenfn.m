function frameout = framegenfn(rateid,numBits,prm80211p)

preambleout = preamblegenfn(prm80211p);

i=length(preambleout);

signalfield = mysignalfunc(rateid,prm80211p);

j=length(signalfield);

prnsg=[preambleout(1:i-1) preambleout(i)+signalfield(1) signalfield(2:j)];

k=length(prnsg);

l=length(ofdmdata);

frameout=[prnsg(1:k-1) preambleout(k)+ofdmdata(1) ofdmdata(2:l)];
