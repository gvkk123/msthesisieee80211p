function [Pr_dBm_d,H_Nakagami_pl] = nakagami_pl_modelfn(Pt_dBm,Num,dist)
%%

% Transmitted Power, dBm
%Pt_dBm = 30;
%dist = 100;
%Num = 10000;


Pr_dBm_d = dualslopemodelfn(Pt_dBm,dist);

%%
[N_RV] = nakagamimodelfn(Num,dist,Pt_dBm);

H_Nakagami_pl = N_RV;

end