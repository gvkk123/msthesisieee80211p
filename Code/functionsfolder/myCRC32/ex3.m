clc;
clear;
close all;
%%

num = 100;
bits=randi([0,1],1,num);

Output = crc32(bits);

crcout = crc32genfn(bits');

Output2 = crcout(end-31:end);

biterr(Output,Output2)

[resto] = crc16(bits)';

biterr(resto,Output2)