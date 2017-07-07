clc;
clear;
close all;
%%

num = 3200;
crcin=randi([0,1],num,1);

%%
% Output = CRC_gen(crcin);
% 
% crcout = [crcin;Output'];
% %%
% 

for i = 1:100
crcout = mycrc32genfn(crcin);

crcout2 = crc32genfn(crcin);

biterr(crcout,crcout2)

end


