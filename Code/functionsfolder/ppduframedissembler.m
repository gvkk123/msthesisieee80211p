function [rxSTS, rxLTS, rxSIGNALDATA, rxWDATA] = ppduframedissembler(rxSignal)

% Follows Figure 17.1 - PPDU Frame Format

rxppduframe = rxSignal;
rxl = length(rxppduframe);

% Separating Preamble and Signal AND WDATA from a Rx. PPDU Frame.
% ppduframe1 = [pbnsf(1:psp-1) pbnsf(psp)+WDATA(1) WDATA(2:WDp)];

rxSTS = rxppduframe(1:161);
rxLTS = rxppduframe(161:321);
rxSIGNALDATA = rxppduframe(321:401);
rxWDATA = rxppduframe(401:rxl);

% 
% psp = 401;
% rxWDATA = [0.5*rxppduframe(psp) rxppduframe(psp+1:rxl)];
% % rxWDp = length(rxWDATA);
% 
% % rxDATA = [2*rxWDATA(1) rxWDATA(2:rxWDp-1) 2*rxWDATA(rxWDp)];
% % rxDATA = rxDATA';
% 
% plp = 321;
% %rxpreambleout = [rxppduframe(1:plp-1) 0.5*rxppduframe(plp)];
% rxpreambleout = rxppduframe(1:plp);
% 
% rxsignalfield = rxppduframe(plp:psp);


end