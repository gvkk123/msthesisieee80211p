function [crcout,err] = mycrc32detfn(crcin)

% crc32genpoly = 'z^32 + z^26 + z^23 + z^22 + z^16 + z^12 + z^11 + z^10...
%                   + z^8 + z^7 + z^5 + z^4 + z^2 + z + 1';
% poly=[1,0,0,0,0,0,1,0,0,1,1,0,0,0,0,0,1,0,0,0,1,1,1,0,1,1,0,1,1,0,1,1,1];
% FLIPLR of POLY
poly2 = [1,1,1,0,1,1,0,1,1,0,1,1,1,0,0,0,1,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,1];

pxr2 = fliplr(crcin');

[~,r]=gfdeconv(pxr2,poly2);

if r ==0
    err = 0;
    crcout = crcin(1:end-32);
else
    err = 1;
    crcout = crcin(1:end-32);
end
 
end