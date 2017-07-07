function crcout = mycrc32genfn(crcin)

% crc32genpoly = 'z^32 + z^26 + z^23 + z^22 + z^16 + z^12 + z^11 + z^10...
%                   + z^8 + z^7 + z^5 + z^4 + z^2 + z + 1';
% poly=[1,0,0,0,0,0,1,0,0,1,1,0,0,0,0,0,1,0,0,0,1,1,1,0,1,1,0,1,1,0,1,1,1];
% FLIPLR of POLY
poly2 = [1,1,1,0,1,1,0,1,1,0,1,1,1,0,0,0,1,0,0,0,0,0,1,1,0,0,1,0,0,0,0,0,1];

pxr=[crcin' zeros(1,length(poly2)-1)];
pxr2 = fliplr(pxr);

[~,r]=gfdeconv(pxr2,poly2);

rr = [r zeros(1,(length(pxr2)-length(r)))];

crcout=fliplr((rr + pxr2))';
    
end