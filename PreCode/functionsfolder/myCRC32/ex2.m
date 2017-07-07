clc;
clear;
close all;
%%

%Variable initialization
gx=[1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 1];
num = 1000;
x=randi([0,1],1,num);
x=[x zeros(1,16)];
%%
%Mathematically, the CRC value corresponding to a given frame 
%is defined by the following procedure.
%  The first 16 bits of the input bit sequence are complemented.
rx=bitcmp(x(1:16),1);
%  The bit sequence is divided by G(x), producing a remainder 
%  R(x) of degree <= 15.
for i=1:1000
    nm=[rx x(i+16)];
    if nm(1)==1
        rx=xor(nm(2:17),gx(2:17));
    else
        rx=nm(2:17);
    end
end
rx=bitcmp(rx,1);