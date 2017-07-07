function [H] = estimator(X,Y, estmode)

% Frequency Domain Channel Estimation
% Y = H*X + N

switch estmode
    case 1
        
        %disp('LS used')

        % Frequency Domain LS Channel Estimator
        H_LS = Y./X;
        H = H_LS;
    case 2
        
        %disp('LMMSE used')

        % Frequency Domain MMSE Estimator
        
        % Estimation done based on the Block-Type Preamble MMSE with Rh and
        % SNR being estimated simultaneously.
        [H_LMMSE,H_LS,SNR_est, nVar_est] = mmseestfn(X,Y);
        H = H_LMMSE;
    case 3
        % No Estimation
        H = 1;
    case 4
        % Time Domain LS Channel Estimator
        % H = inv(X)*Y;
        % conjugate transpose of X.
        %X1 = X';
        %This method Fails because X'*X is Singular.
        %H = inv(X'*X)*X'*Y;
        
        % Basic Solution
        H = X\Y;
        
        % Minimal Norm Solution
        % H = pinv(X)*Y;
end

end