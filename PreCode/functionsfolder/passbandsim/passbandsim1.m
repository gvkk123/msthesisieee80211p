%% Passband Modulation with Adjacent Channel Interference
% This example shows how to use baseband modulators and demodulators with
% frequency upconversion and downconversion to simulate passband
% communication systems. In general, it is simpler and faster to model a
% system at complex baseband. However, there are some circumstances where
% it is preferable to model the system at real passband. An example of this
% is when an adjacent band tonal signal is processed with a nonlinearity,
% and causes interference in the band of interest. This example illustrates
% this scenario by assuming a 16-QAM communications system transmitting in
% an additive white Gaussian noise (AWGN) channel with interference in its
% passband. A tone in an adjacent channel that has been processed by a
% cubic nonlinearity causes this interference.

% Copyright 2009-2016 The MathWorks, Inc.

%%
clc;
clear;
close all;

%% Initialization
% First, initialize variables that define simulation parameters, such as
% carrier frequency, number of samples representing a symbol, and noise
% level.

Fc = 2.5e6;         % Carrier frequency (Hz)
Rsym = 1e6;         % Symbol rate (symbols/second)
nSamps = 8;         % Number of samples per symbol
frameLength = 2048; % Number of symbols in a frame
M = 16;             % Modulation order (16-QAM)
EbNo = 15;          % Ratio of baseband bit energy
                    % to noise power spectral density (dB)

% Calculate sampling frequency in Hz
Fs = Rsym * nSamps;

% Calculate passband SNR in dB. The noise variance of the baseband signal
% is double that of the corresponding bandpass signal [1]. Increase the SNR
% value by 10*log10(2) dB to account for this difference and have
% equivalent baseband and passband performance.
SNR = EbNo + 10*log10(log2(M)/nSamps) + 10*log10(2);

%% 
% *Initialize Measurement Tools*
%
% Initialize a constellation diagram to analyze signals at different points
% in the transmitter-receiver chain.

% Create a constellation diagram for received symbols.
constDiag = comm.ConstellationDiagram('SamplesPerSymbol', 1, ...
  'XLimits', [-4.5 4.5], ...
  'YLimits', [-4.5 4.5], ...
  'Position', [70 560 640 460]);

%% Baseband Modulation
% The first step of simulating a passband communication system is to
% modulate the random data in the baseband.  You generate random symbols,
% modulate them with a 16-QAM modulator, and apply pulse shaping using a
% square root raised cosine filter.

%%
% *16-QAM Modulation*

% Create a 16-QAM modulator.
qam16Mod = comm.RectangularQAMModulator(M);

% Set the expected constellation of the constellation diagram.
constDiag.ReferenceConstellation = constellation(qam16Mod);

% Generate random data symbols.
b = randi([0 M-1], frameLength, 1);

% Modulate the random data.
txSym = qam16Mod(b);

%%
% *Pulse Shaping*
%
% After modulation, you apply pulse shaping using a square root raised
% cosine filter.  You use the spectrum estimator to verify that the
% frequency spectrum of the baseband signal is centered at zero Hz, and
% that it has been filtered properly.

% Specify a square root raised cosine filter with a filter length of eight
% symbols and a rolloff factor of 0.2.
nSym = 8;       % Length of the filter in symbols
beta = 0.2;     % Rolloff factor

% Design the transmitter filter. Apply a gain to normalize passband gain to
% unity.
rctFilt = comm.RaisedCosineTransmitFilter('RolloffFactor', 0.2, ...
  'OutputSamplesPerSymbol', nSamps, ...
  'FilterSpanInSymbols', nSym, ...
  'Gain', 0.3578);

% Apply pulse shaping by upsampling and filtering.  Alternatively, you can
% use an efficient multirate filter. See help for fdesign.interpolator for
% more information.
x = rctFilt(txSym);

% Plot spectrum estimate of pulse shaped signal.
Fig = figure;
pwelch(x,hamming(512),[],[],Fs,'centered')

%% Frequency Upconversion
% You apply frequency upconversion to obtain a passband signal around the
% specified carrier frequency.  You achieve this by multiplying the complex
% baseband signal with a complex sinusoidal and taking the real part.

% Generate carrier. The sqrt(2) factor ensures that the power of the
% frequency upconverted signal is equal to the power of its baseband
% counterpart.
t = (0:1/Fs:(frameLength/Rsym)-1/Fs).';
carrier = sqrt(2)*exp(1i*2*pi*Fc*t);

% Frequency upconvert to passband.
xUp = real(x.*carrier);

% Plot spectrum estimate.
pwelch(xUp,hamming(512),[],[],Fs,'centered')

%% Channel Simulation
% Simulate the communications channel as a passband real AWGN channel with
% an adjacent channel interference caused by a tone processed with a cubic
% nonlinearity.
    
% Create the passband interference by raising an adjacent channel tone to
% the third power.
Fint = Fc/3+50e3;
interference = 0.7*cos(2*pi*Fint*t+pi/8).^3;

%%

% Calculate the total signal power for the given pulse shape. Account for
% the average power of the baseband 16-QAM upsampled signal. For a
% constellation that contains points with +/- 1 and +/- 3 amplitude levels,
% the average power of a 16-QAM signal is 10 W. The upsampling operation
% reduces this power by a factor of nSamps leading to a net power of
% 10*log10(10/nSamps), or 0.97 dBW for nSamps = 8.
avgPwrBaseBand16QAM = 10*log10(sum(abs(constellation(qam16Mod)).^2)...
                     /(M*nSamps));
filterCoeffs = coeffs(rctFilt);
sigPower = 10*log10(sum(filterCoeffs.Numerator.^2)) + avgPwrBaseBand16QAM;

% Add white Gaussian noise based on the computed signal power.
yUp = awgn(xUp, SNR, sigPower); 

% Add the adjacent channel interference to the signal.
yUpACI = yUp + interference;

% Estimate spectrum of the noisy signal and compare it to the spectrum of
% the original upconverted signal.
figure(Fig);
hold on;
pwelch(yUpACI,hamming(512),[],[],Fs,'centered')
ax = Fig.CurrentAxes;
hLines = ax.Children;
hLines(1).Color = [1 0 0];
legend('Signal at channel input',...
    'Signal at channel output','Location','southwest')


%% Frequency Downconversion
% You apply frequency downconversion to obtain a baseband signal before
% demodulation.  You achieve this by multiplying the complex passband
% signal with a complex sinusoidal.  The following code assumes perfect
% phase synchronization, so it uses the same carrier signal as the
% transmitter.

% Downconvert to baseband (Assumes perfect synchronization).
yACI = yUpACI.*conj(carrier);

% Estimate spectrum of the downconverted signal with adjacent channel
% interference.
figure(Fig);
hold off;
pwelch(yACI,hamming(512),[],[],Fs,'centered')

%% Baseband Demodulation
% Once the signal is in baseband, you can apply matched filtering.  Note
% that the matched filter also removes the unwanted higher frequency
% components due to frequency downconversion.

%%
% *Matched Filtering*

% Design the receive filter. Apply a gain to normalize passband gain to
% unity.
rcrFilt = comm.RaisedCosineReceiveFilter(...
  'RolloffFactor', rctFilt.RolloffFactor, ...
  'InputSamplesPerSymbol', rctFilt.OutputSamplesPerSymbol, ...
  'FilterSpanInSymbols', rctFilt.FilterSpanInSymbols, ...
  'DecimationFactor', 1, ...
  'Gain', 0.3578);

% Filter the frequency downconverted signal.
rcvSymACI = rcrFilt(yACI);

% Estimate spectrum of the filtered signal and compare it to the spectrum
% of the signal at the filter input.
figure(Fig);
hold on;
pwelch(rcvSymACI,hamming(512),[],[],Fs,'centered');
ax = Fig.CurrentAxes;
hLines = ax.Children;
hLines(1).Color = [1 0 0];
legend('Signal at filter input',...
    'Signal at filter output','Location','southwest')

% Amplify the signal to compensate for the power loss caused by pulse
% shaping and matched filtering. This places the received signal symbols
% around the expected 16-QAM constellation points.
rcvSymACI = nSym*rcvSymACI;

%%
% *Demodulate*
%
% After matched filtering, you downsample and demodulate the 16-QAM signal
% to obtain the data symbols.

% Downsample the filtered signal.  Discard the first nSym symbols due to
% filter delay.
e2eDelay = nSamps*nSym;
rcvSymDownACI = rcvSymACI(e2eDelay+1:nSamps:end);

% Obtain the constellation diagram of the received signal with adjacent
% channel interference.
constDiag(rcvSymDownACI)

% Create demodulator.
qam16Demod = comm.RectangularQAMDemodulator(M);

% Demodulate received symbols and count the number of symbol errors.
xHatACI = qam16Demod(rcvSymDownACI);
numErr = sum(xHatACI~=b(1:end-nSym))

%%
% Repeat the steps above to obtain received symbols without adjacent
% channel interference. The symbol error rate (SER) results of the
% interference-free passband 16-QAM system should match the theoretical SER
% for a 16-QAM baseband system in an AWGN channel.

y = yUp.*conj(carrier);
rcvSym = rcrFilt(y);
rcvSym = nSym*rcvSym;
rcvSymDown = rcvSym(e2eDelay+1:nSamps:end);
scatScope2 = clone(constDiag);
hide(constDiag);
% Update the constellation diagram for the interference-free received
% symbols.
scatScope2(rcvSymDown)

xHat = qam16Demod(rcvSymDown);
numErr = sum(xHat~=b(1:end-nSym))

%% 
% *Symbol Error Rate Curves*
%
% To obtain SER curves for the 16-QAM communications system with and
% without adjacent channel interference in the passband, you can format the
% steps of this example into a for-loop to run simulations for several
% transmitted frames. In such simulations, you need to carry the state of
% the system components, such as the filter, the carrier, and the nonlinear
% adjacent channel tonal interference, from one iteration to the next.
% Setting the PersistentMemory property of the filters to true
% automatically saves the filter states.  You need to manually keep track
% of the carrier and tone phases by generating a continuous time vector
% (t).
%
% Using the simulation function, simulations for Eb/No in the [0, 12] dB
% interval were performed for 2e3 transmissions of frames of length 5e3
% symbols. The passbandmoddemo_results.mat file contains the results of the
% simulations. The interference tone amplitude was equal to 0.45 in these
% simulations. You can compare the results of 16-QAM passband modulation
% with and without adjacent channel interference and the theoretical curve
% of 16-QAM modulation in a baseband AWGN channel by loading the
% aforementioned file. If the Parallel Computing Toolbox(TM) (PCT) is
% installed these simulations are performed in real time across the maximum
% number of available workers.


[licensePCT,~] = license( 'checkout' , 'Distrib_Computing_Toolbox');
if ( licensePCT && ~isempty(ver('distcomp')))
    EbNoVect = 0:12;
    nTx = 3e2;
    [passbandSER, passbandSERACI] = passbandSERWithPCT(nTx,EbNoVect);
else
    load passbandmoddemo_results.mat
end

% Theoretical SER for 16-QAM in AWGN
[~,serAWGN] = berawgn(EbNoVect,'qam',16);
figure(Fig);
hold off;
semilogy(EbNoVect,serAWGN,'-*');
hold on;
semilogy(EbNoVect,passbandSER,'g');
semilogy(EbNoVect,passbandSERACI,'r'); 
legend('Theoretical Performance',...
    'Simulation with no ACI', 'Simulation with ACI','Location','southwest')
grid on; 
xlabel('Eb/No')
ylabel('SER')

%%
% The truncated root raised cosine filter causes the slight degradation
% seen in the interference-free simulation results.
%% Summary
% This example illustrated how to use a baseband modulation object together
% with frequency upconversion and downconversion to simulate a passband
% communication system with a cubic nonlinearity acting on an adjacent
% channel. Even though it is usually simple and faster to simulate a system
% at complex baseband, there are some circumstances where it is preferable
% to model the system at real passband. The example presented the case when
% an adjacent band signal is processed with a nonlinearity, and causes
% interference in the band of interest.

%% Appendix
% This example uses the following helper functions:
%
% * <matlab:edit('passbandSERWithPCT.m') passbandSERWithPCT.m>
% * <matlab:edit('commPassbandModPCT.m') commPassbandModPCT.m>

%% Selected Bibliography
% # W. Zhang, M. J. Miller, "Baseband Equivalents in Digital Communication
% System Simulation", IEEE(R) Transactions on Education, vol. 35, No. 4,
% November 1992.

displayEndOfDemoMessage(mfilename)
