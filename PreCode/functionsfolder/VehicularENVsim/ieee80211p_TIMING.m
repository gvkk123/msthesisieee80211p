function prmTIMING = ieee80211p_TIMING(dpack)

% Data rate rdata 6 Mbps
p.rdata = 6*10^6;

% PHY preamble tpream 40 탎
p.tpream = 40*10^-6;

% CSMA slot duration tcsma 13 탎
p.tcsma = 13*10^-6;

% AIFS time taifs 58 탎
p.taifs = 58*10^-6;

% Frame duration tframe 100 ms
p.t_frame = 100* 10^-3;

% Guard interval tguard 5 탎
p.tguard = 5*10^-6;

if dpack == 200*8
    % Packet size dpack 200 400 byte
    p.dpack = 200*8;
    
    % Packet duration tpack 312 576 탎
    p.tpack = 312*10^-6;
    
elseif dpack == 400*8
    % Packet size dpack 200 400 byte
    p.dpack = 400*8;
    
    % Packet duration tpack 312 576 탎
    p.tpack = 576*10^-6;
end

% Slot duration tslot 317 581 탎
p.tslot = p.tpack + p.tguard;

% Number of slots n 315 172
p.num_slots = floor(p.t_frame/p.tslot);

prmTIMING = p;

end