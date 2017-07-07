function [out] = equalizer(in, hD, nVar, EqMode)

switch EqMode
    case 1
        % Zero forcing -- 1/h^2
        Eq = (conj(hD))./((conj(hD).*hD));
    case 2
        % MMSE -- 1/h^2+n
        Eq = (conj(hD))./((conj(hD).*hD)+nVar);
    otherwise
        error('Two equalization mode viable: Zero forcing or MMSE');
end

out=in.*Eq;

end
