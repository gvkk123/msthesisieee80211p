function [H_LMMSE,H_LS,SNR_est, nVar_est] = mmseestfn(X,Y)

% Frequency Domain MMSE Estimator
% Estimation done based on the Block-Type Preamble MMSE with Rh and
% SNR being estimated simultaneously.

%% LS Estimate
H_LS = (Y./X).'; % 1xM matrix

%H_LS = H_LS'; % Mx1 matrix

Rh_LS = H_LS*H_LS' ; %MxM matrix

%% Initialisation

% M-point DFT
M = 64;

% Identity Matrix
Ident = eye(M);

% Setting parameter values
nVar_init = 0.05;
Threshold = 0.0001;


%% Step 1

i = 1;

% LMMSE Initialisation
H_LMMSE = Rh_LS*(inv(Rh_LS + nVar_init*Ident))*H_LS;

nVar_est = (1/M)*(sum((abs(H_LS-H_LMMSE)).^2));

Rh_MMSE = H_LMMSE*H_LMMSE';
%% Iterative Algorithm

nVar_past = nVar_init
nVar_present = nVar_est

while abs(nVar_present - nVar_past)>Threshold
    
    nVar_past = nVar_present;
    
    H_LMMSE = Rh_MMSE*(inv(Rh_MMSE + nVar_present*Ident))*H_LS;
    
    nVar_est = (1/M)*(sum((abs(H_LS-H_LMMSE)).^2));
    
    Rh_MMSE = H_LMMSE*H_LMMSE';
    
    nVar_present = nVar_est
    
    i = i+1

end

%%
% Estimate Noise Variance
% nVar_est = nVar;

% Estimate SNR
M2 = (1/M)*sum(abs(Y).^2);
SNR_est = (M2/nVar_est)-1

H_LMMSE = H_LMMSE';

end