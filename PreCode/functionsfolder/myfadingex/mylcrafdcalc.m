%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PROGRAM TO CALCULATE THE LEVEL CROSSING RATE AND AVERAGE FADE DURATION
% Rth: Level to calculate the LCR and AFD
% Rrms: RMS level of the signal r
% rho: Ratio of defined threshold and RMS level
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [LCR_Meas, LCR_Th, AFD_Meas, AFD_Th] = mylcrafdcalc(r, fm, T, Ts)

Rth=0.50;

mean_r=sum(r)/length(r);
r=r/mean_r;

mean_r2=sum(r.^2)/length(r.^2);
Rrms=sqrt(mean_r2);

rho=Rth/Rrms;

count1=0;
count2=0;

for n=1:length(r)-1
    
    if r(n)<Rth && r(n+1)>Rth
        count1=count1+1;
    end
    
    if r(n) < Rth
        count2=count2+1;
    end
end

LCR_Meas=count1/(T);
AFD_Meas=((count2*Ts)/T)/LCR_Meas;

LCR_Th=sqrt(2*pi)*fm*rho*exp(-(rho^2));
AFD_Th=(exp(rho^2)-1)/(rho*fm*sqrt(2*pi));