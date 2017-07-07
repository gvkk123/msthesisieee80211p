function ppduframe = ppduframeassembler(prm80211p, rateid, CP_OFDM)

% Follows Figure 17.1 - PPDU Frame Format Creation

% Preamble and Signal Fields already Windowed.

%% Generating Preamble
preambleout = preamblegenfn(prm80211p);
pb = preambleout;
plp = length(preambleout);

%% Generating Signal Field
signalfield = mysignalfunc(rateid,prm80211p);
sf = signalfield;
sfp = length(signalfield);

%% Combining Preamble and Signal
pbnsf = [pb(1:plp-1) pb(plp)+sf(1) sf(2:sfp)];
psp = length(pbnsf);

%% Windowing Input DATA
DATA = CP_OFDM.';
Dl = length(DATA);
WDATA = [0.5*DATA(1) DATA(2:Dl-1) 0.5*DATA(Dl)];
WDp = length(WDATA);

%% Combining Preamble and Signal with WDATA to create PPDU Frame.
ppduframe1 = [pbnsf(1:psp-1) pbnsf(psp)+WDATA(1) WDATA(2:WDp)];

ppduframe = ppduframe1.';

end