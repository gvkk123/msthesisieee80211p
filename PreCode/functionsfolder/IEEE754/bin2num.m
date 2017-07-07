function num = bin2num(bin)

% x = bin2num(s)
%     s is string of 64 characters (each is 0 or 1), corresponding
%       to IEEE representation
%     x is corresponding double precision number

% pad with zeros from left so that length is multiple of 4

A = mat2str(bin);

for i = 1:length(bin)
    B(i) = A(2*i);
end

s=B;

r = rem(length(s),4);

if r>0
  s = [48*ones(1,4-r),s];
end

n = length(s)/4;

num = hex2num(dec2hex(bin2dec(reshape(s,4,n)'))');

end