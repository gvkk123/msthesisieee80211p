function Pr_dBm_d = dualslopemodelfn(Pt_dBm,d)
%The averaged received power Pr(d) is following a dual-slope model:

%%
% Parameters:

%carrier frequency of f = 5,9 GHz
f = 5.9*10^9;

%Wave length ?[m] = 0.0508
lambda = (3*10^8)/f;

%Reference distance d0[m]
d0 = 10;

%Cut-off distance dc[m]
dc = 80;

%Path gain 1
gamma1=1.9;

%Path gain 2
gamma2=3.8;

%%
% Free space path gain formula:

Pr_dB_d0 = Pt_dBm + (10*2*log10(lambda/(4*pi*d0)));

%%
%Dual-slope Model

if d>dc
    Pr_dBm_d = Pr_dB_d0- (10*gamma2*log10(d/dc)) - (10*gamma1*log10(dc/d0));
elseif d<=dc
    Pr_dBm_d = Pr_dB_d0 - 10*gamma1*log10(d/d0);
else
    disp('Error in Dual-slope Model');
end

end
%%
