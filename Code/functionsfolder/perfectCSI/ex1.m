clc;
clear;

%%
N = 64;
x1 = randi([0,1],1,N);

x2 = ifft(x1,N);

x = [x2(end-(N/4)+1:end) x2];

%%
h = 1:N+(N/4);

y= h.*x;

%%

y1 = y(end-N+1:end);

y2 = fft(y1,N);

%%
H = fft(y1,N)./fft(x2,N);

XX = round(y2./H);

hh = ifft(H,N);

%%
err = biterr(x1,XX)