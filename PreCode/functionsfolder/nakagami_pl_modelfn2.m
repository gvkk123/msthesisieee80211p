function [Pr_dBm_d,H_Nakagami_pl] = nakagami_pl_modelfn2(Pt_dBm,Num,dist,dataset_selector)
%%

% Transmitted Power, dBm
%Pt_dBm = 30;
%dist = 100;
%Num = 10000;

Pr_dBm_d = dualslopemodelfn2(Pt_dBm,dist,dataset_selector);
%%
[N_RV] = nakagamimodelfn2(Num,dist,Pr_dBm_d,dataset_selector);

H_Nakagami_pl = N_RV;

end