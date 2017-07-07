function Pr_dBm_d = dualslopemodelfn2(Pt_dBm,d,dataset_selector)
%The averaged received power Pr(d) is following a dual-slope model:

%% Parameters:

%carrier frequency of f = 5,9 GHz
f = 5.9*10^9;

%Wave length ?[m] = 0.0508
lambda = (3*10^8)/f;

% Antenna Gain[dB]
G = 4.5;

% Assuming two meters of antenna cable with a typical loss of 1.7 dB/m
% Antenna Cable Losses[dB]
L = 3.4;

%Reference distance d0[m]
d0 = 10;

%Fresnel Cut-off distance dc[m]
dc = 100;

%% Selecting Pathloss Dataset:

switch dataset_selector
    case 1
        %Path gain 1
        gamma1=2.1;
        
        %Path gain 2
        gamma2=3.8;
        
        %Standard Deviation 1 sigma1[dB]
        m1 = 0;
        sigma1 = 2.6;
        
        %Standard Deviation 2 sigma2[dB]
        m2 = 0;
        sigma2 = 4.4;
    case 2
        %Path gain 1
        gamma1=2;
        
        %Path gain 2
        gamma2=4;
        
        %Standard Deviation 1 sigma1[dB]
        m1 = 0;
        sigma1 = 5.6;
        
        %Standard Deviation 2 sigma2[dB]
        m2 = 0;
        sigma2 = 8.4;
end
%%
% Free space path gain formula:
PL_dB_d0 = -(10*2*log10(lambda/(4*pi*d0))) + G - L;

Pr_dB_d0 = Pt_dBm - PL_dB_d0;

%%
%Dual-slope Model
X1 = m1 + sigma1.*randn(1) ;
X2 = m2 + sigma2.*randn(1) ;


if d<=dc
    Pr_dBm_d = Pr_dB_d0 - 10*gamma1*log10(d/d0) + X1;
elseif d>dc
    Pr_dBm_d = Pr_dB_d0- (10*gamma1*log10(dc/d0))- (10*gamma2*log10(d/dc)) + X2;
else
    disp('Error in Dual-slope Model');
end

end
%%
