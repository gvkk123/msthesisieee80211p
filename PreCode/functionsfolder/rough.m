% The following code generates an OFDM signal for IEEE 802.11 a
% specification
% Base band data uses 16 QAM modulation
% code developed by K.VINOTH BABU,VIT UNIVERSITY on 05/10/2010
clc;
close all;
clear all;
n = 256; % Number of bits to process
x = randint(n,1); % Random binary data stream
M = 16; % Size of signal constellation
k = log2(M); % Number of bits per symbol
xsym = bi2de(reshape(x,k,length(x)/k).','left-msb');% Convert the bits in x into k-bit symbols.
y = modulate(modem.qammod(M),xsym); % Modulate using 16-QAM.
tu=3.2e-6;%useful symbol period
tg=0.8e-6;%guard interval length
ts=tu+tg;%total symbol duration
nmin=0;
nmax=64;%total number of subcarriers
scb=312.5e3;%sub carrier spacing
fc=3.6e9;%carrier frequency
Rs=fc;
tt=0:1/Rs:ts;
TT=length(tt);
k=nmin:(nmax-1);
for t=0:(TT-1)
phi=((y(k+1).').*exp((1j*2*(((t*(1/Rs))-tg))*pi/tu).*((k-(nmax-nmin)/2))));
s(t+1)=real(exp(1j*2*pi*fc*(t*(1/Rs))).*sum(phi));
end
plot(tt,s,'b');