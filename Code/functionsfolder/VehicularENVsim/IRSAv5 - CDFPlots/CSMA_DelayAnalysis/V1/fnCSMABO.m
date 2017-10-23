function [BO_T] = fnCSMABO(aSlotTime,prioity_mode,CW_min,CW_max)

% Broadcast Mode Back-Off
%BO = [0 1 2 3];
switch prioity_mode
    case 1
        BO = randi([0 CW_min],1,1);
        BO_T = aSlotTime * BO;
        
    otherwise
        disp('error_in_CSMA_BO');
end

end