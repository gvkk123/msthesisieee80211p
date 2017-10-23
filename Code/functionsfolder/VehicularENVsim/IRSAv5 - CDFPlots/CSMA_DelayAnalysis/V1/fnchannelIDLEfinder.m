function channelfreedtime = fnchannelIDLEfinder(channel_stN,ptimer)

tmp_timer = ptimer;

while channel_stN(tmp_timer) == 1
    tmp_timer = tmp_timer + 1;
end

channelfreedtime = tmp_timer;

end