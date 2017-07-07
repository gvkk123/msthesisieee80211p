clc;
clear;
close all;

%%
num = 32;

Input = randi([0,1],1,num);

Output = CRC_gen(Input);

Output1 = [Input Output];

crcout = crc32genfn(Input');

Output2 = crcout';

biterr(Output1,Output2);

[resto] = crc16(Input);

Output3 = [resto Output];

biterr(Output3,Output2)