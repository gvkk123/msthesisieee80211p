function bin = num2bin(num)

% s = num2bin(x)
%       for double precision number x, gives IEEE binary representation 
%       as string of 64 characters (each is 0 or 1)

s = sprintf('%bx',num);

t = sprintf('%bx',2);

% [n,p,f] = fopen(1);  % check for little or big-endian
% if f(1:7)=='ieee-le'

if t(1)==0
  s = reshape(fliplr(reshape(s,2,8)),1,16); 
end

s = reshape(dec2bin(hex2dec(s'),4)',1,4*16);


bin = zeros(1,length(s));

for i=1:length(s)
    bin(i) = str2double(s(i));
end

end
