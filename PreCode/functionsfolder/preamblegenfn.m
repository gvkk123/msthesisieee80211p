function preambleout = preamblegenfn(prm80211p)

%clc;
%clear;

%%
%short_training_symbol
st=prm80211p.short_training_symbol;
% st=sqrt(13/6) * [0, 0, 1+1i, 0, 0, 0, -1-1i, 0, 0, 0,...
%     1+1i, 0, 0, 0, -1-1i, 0, 0, 0, -1-1i, 0, 0, 0, 1+1i, 0, 0, 0, 0, 0,...
%     0, 0, -1-1i, 0, 0, 0, -1-1i, 0, 0, 0, 1+1i, 0, 0, 0, 1+1i, 0, 0, 0,...
%     1+1i, 0, 0, 0, 1+1i, 0,0];
%long_training_symbol
lt=prm80211p.long_training_symbol;
% lt=[1, 1, -1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 1, 1,...
%     -1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, 0, 1, -1, -1, 1, 1, -1, 1, -1,...
%     1, -1, -1, -1, -1, -1, 1, 1, -1, -1, 1, -1, 1, -1, 1, 1, 1, 1];
%%
% Frequency Domain Short Sequence.
st2=[0,0,0,0,0,0,st,0,0,0,0,0];

%%
%One period of IFFT of the short sequences
st3=ifft(st2,64);
%%
% single period of the short training sequence is extended periodically for
%161 samples (about 8 uS),, and then multiplied by the window function:
st4=[st3,st3,st3(1:33)];
st5=[0.5*st4(1),st4(2:160),0.5*st4(161)];
%%
% Frequency Domain Long Sequence.
lt2=[0,0,0,0,0,0,lt,0,0,0,0,0];
%%
%Time domain representation of the long sequence
lt3=ifft(lt2,64);
%%
lt4=[lt3,lt3,lt3(1:33)];

lt5=[0.5*lt4(1),lt4(2:160),0.5*lt4(161)];
%%
%Long and Short sequence combined.
final=[st5(1:160),st5(161)+lt5(1),lt5(2:161)];

preambleout=final;

% %%
% 
% stt=final(65:128);
% stt2=fft(stt,64);
% 
% ltt=final(225:288);
% ltt2=fft(ltt,64);
% 
% %%
% %a=isequal((st2),(stt2));
% a=isequal(round(st2),round(stt2));
% b=isequal(round(lt2),round(ltt2));

end
