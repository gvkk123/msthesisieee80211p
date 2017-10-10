function [channel_stN1,tx_start,tx_end] = fnCSMACA(usertime,channel_stN,T_AIFS,t_pack,aSlotTime,prioity_mode,CW_min,CW_max)

channel_stN_tmp = channel_stN;

%1.Wait T_AIFS
ptimer = usertime + T_AIFS*10^6;
%freedtime = channel_stN(t1);

if channel_stN_tmp(ptimer) == 0
    tx_start = ptimer;
    tx_end = tx_start + t_pack*10^6;
    channel_stN_tmp(tx_start:tx_end-1) = 1;
    
elseif channel_stN_tmp(ptimer) == 1
    % Defining Back-off Timer
    [BO_T] = fnCSMABO(aSlotTime,prioity_mode,CW_min,CW_max);
    
    % Wait till channel gets IDLE
    channelfreedtime = fnchannelIDLEfinder(channel_stN_tmp,ptimer);
    
    % Wait T_AIFS
    ptimer2 = channelfreedtime + T_AIFS*10^6;
    
    % Start Back-off Timer
    ptimer3 = ptimer2 + BO_T*10^6;
    
    %Check Again if Channel IDLE
    if channel_stN_tmp(ptimer3) == 0
        tx_start = ptimer3;
        tx_end = tx_start + t_pack*10^6;
        channel_stN_tmp(tx_start:tx_end-1) = 1;
    elseif channel_stN_tmp(ptimer3) == 1
        tx_start = Inf;
        tx_end = Inf;
    end
    
end

channel_stN1 = channel_stN_tmp;

end