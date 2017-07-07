function rxSignal = channel_stdchanex(txSignal,EbNoVec,rateid,prm80211p)

%% Filter Signal Through 802.11a Channel
%
%%
% Set the sample rate and RMS delay profile. Set the maximum Doppler shift.
fs = 20e6;
trms = 100e-9;
fd = 0;
%%
% Create a 802.11g channel object.
chan = stdchan(1/fs,fd,'802.11a',trms);
%%
% Generate random data and apply QPSK modulation.
%data = randi([0 3],10000,1);
%txSig = pskmod(data,4,pi/4);
%%
% Filter the QPSK signal through the 802.11g channel.
rxSignal = filter(chan,txSignal);
%%
% Plot the spectrum of the filtered signal.
sa = dsp.SpectrumAnalyzer('SampleRate',fs,'SpectralAverages',10);
step(sa,rxSignal)

