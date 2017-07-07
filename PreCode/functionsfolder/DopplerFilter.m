function [S]=DopplerFilter(N, fm, fd, TPL, spec_type)

% Generate Doppler Spectrum

% fm - Maximum Doppler Shift
% fd - Doppler Offset
% f - Frequency
% S - Normalized Doppler Spectrum

% Doppler Filter Types
% 1.Classic 6 dB(C6) - SPIRENT DEFINED
% 2.Classic 3 dB(C3) - SPIRENT DEFINED
% 3.Rounded(R) - SPIRENT DEFINED
% 4.Flat(F) - SPIRENT DEFINED
% 5.Classical Jakes - MATLAB DEFINED
% 6.Round(R) - MATLAB DEFINED
% 7.Flat(F) - MATLAB DEFINED
% 8.Youngs Model

a = TPL;

% To remove infinity values at start and end.
fm = 0.999*fm;

% df is the step size in the frequency domain
df=(2*fm)/(N-1);


f=-fm:df:fm;

switch spec_type
    case 1
        % 1.Classic 6 dB(C6) - SPIRENT DEFINED
        S=a./sqrt(1-((f-fd)./fm).^2);
        
%         % To remove infinity values at start and end.
%         S(1)=2*S(2)-S(3);
%         S(end)=2*S(end-1)-S(end-2);
    case 2
        % 2.Classic 3 dB(C3) - SPIRENT DEFINED
        S1=a./sqrt(1-((f-fd)./fm).^2);
        
%         % To remove infinity values at start and end.
%         S1(1)=2*S1(2)-S1(3);
%         S1(end)=2*S1(end-1)-S1(end-2);
        
        S=sqrt(S1);
    case 3
        % 3.Rounded(R) - SPIRENT DEFINED
        S= a.*sqrt(1-((f-fd)./fm).^2);
    case 4
        % 4.Flat(F) - SPIRENT DEFINED
        for i = 1: length(f)
            S(i) = a;
        end
    case 5
        % 5.Classical Jakes - MATLAB DEFINED
        S=1./(pi*fm*sqrt(1-(f/fm).^2));
        
%         % To remove infinity values at start and end.
%         S(1)=2*S(2)-S(3);
%         S(end)=2*S(end-1)-S(end-2);
    case 6
        % 6.Round(R) - MATLAB DEFINED
        a0 = 1; a2 = -1.72; a4 = 0.785;
        
        Cr = 1/(2*fm*(a0+(a2/3)+(a4/5)));
        
        M = a0 + a2.*(f/fm).^2 + a4.*(f/fm).^4;
        
        S = Cr * M;
    case 7
        % 7.Flat(F) - MATLAB DEFINED
        for i = 1: length(f)
            S(i) = 1/(2*fm);
        end
    case 8
        % 8.Youngs Model
end



end