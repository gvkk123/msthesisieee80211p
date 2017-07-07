function [crcout,err] = crc32detfn(crcin)

crc32genpoly = 'z^32 + z^26 + z^23 + z^22 + z^16 + z^12 + z^11 + z^10 + z^8 + z^7 + z^5 + z^4 + z^2 + z + 1';


%crcGen = comm.CRCGenerator(crc32genpoly);
crcDet = comm.CRCDetector(crc32genpoly);

% Append CRC bits
[crcout, err] = step(crcDet,crcin);
%crcout = step(crcDet,crcin);

end