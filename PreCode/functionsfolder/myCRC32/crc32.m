function ret = crc32(bits)

% crc32genpoly = 'z^32 + z^26 + z^23 + z^22 + z^16 + z^12 + z^11 + z^10...
%                   + z^8 + z^7 + z^5 + z^4 + z^2 + z + 1';
poly =[1,0,0,0,0,0,1,0,0,1,1,0,0,0,0,0,1,0,0,0,1,1,1,0,1,1,0,1,1,0,1,1,1]';

bits = bits(:);

% Flip first 32 bits
bits(1:32) = 1 - bits(1:32);
% Add 32 zeros at the back
bits = [bits; zeros(32,1)];

% Initialize remainder to 0
rem = zeros(32,1);
% Main compution loop for the CRC32
for i = 1:length(bits)
    rem = [rem; bits(i)]; %#ok<AGROW>
    if rem(1) == 1
        rem = mod(rem + poly, 2);
    end
    rem = rem(2:33);
end

% Flip the remainder before returning it
ret = 1 - rem;
end
