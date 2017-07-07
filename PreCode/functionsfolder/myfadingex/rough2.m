%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PROGRAM TO CALCULATE THE LEVEL CROSSING RATE AND AVERAGE FADE DURATION
% Rth: Level to calculate the LCR and AFD
% Rrms: RMS level of the signal r
% rho: Ratio of defined threshold and RMS level
% Copyright RAYmaps (www.raymaps.com)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Rth=0.30;
Rrms=sqrt(mean(r.^2));
rho=Rth/Rrms;

count1=0;
count2=0;

r=r/mean(r);
for n=1:length(r)-1

     if r(n)<Rth && r(n+1)>Rth
        count1=count1+1;
     end
    if r(n) < Rth
        count2=count2+1;
    end

end
LCR=count1/(T)
AFD=((count2*Ts)/T)/LCR

LCR_num=sqrt(2*pi)*fm*rho*exp(-(rho^2))
AFD_num=(exp(rho^2)-1)/(rho*fm*sqrt(2*pi))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%