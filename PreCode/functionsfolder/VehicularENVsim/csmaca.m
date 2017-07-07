%% CSMA/CA Algorithm for CAM - Broadcast Mode

T_AIFS = 13;

CW = aCWmin;

if medium = idle
    BO = rand(0,CW);
    if BO > 0
        BO = BO - 1;
        if BO = 0
            transmit
        end
    end
end