%%
clc;
clear all;
close all;

%%

% Data rate rdata 6 Mbps
rdata = 6*10^6;

% PHY preamble tpream 40 탎
tpream = 40*10^-6;

% CSMA slot duration tcsma 13 탎
tcsma = 13*10^-6;

% AIFS time taifs 58 탎
taifs = 58*10^-6;

% Frame duration tframe 100 ms
t_frame = 100* 10^-3;

% Guard interval tguard 5 탎
tguard = 5*10^-6;

% Packet size dpack 200 400 byte
dpack = 200*8;

% Packet duration tpack 312 576 탎
tpack = 576*10^-6;

% Slot duration tslot 317 581 탎
tslot = tpack+tguard;

% Number of slots n 315 172
num_slots = floor(t_frame/tslot);


%%

% patient(1).name = 'John Doe';
% patient(1).billing = 127.00;
% patient(1).test = [79, 75, 73; 180, 178, 177.5; 220, 210, 205];
% 
% field1 = 'Index';  value1 = zeros(1,10);
% field2 = 'NumSlots';  value2 = ['a', 'b'];
% field3 = 'SlotValues';  value3 = [pi, pi.^2];
% 
% DATA = struct(field1,value1,field2,value2,field3,value3);


user_density = 50;

r = rand(1,user_density);

DATA = struct;

tmp = [];
for i = 1: length(r)
    tmp = [];
    if r(i) <= 0.86
        r1(i) = 3;
    else
        r1(i) = 8;
    end
    
    DATA(i).Index = i;
    DATA(i).Numslots = r1(i);
    tmp = randperm(num_slots,r1(i));
    DATA(i).SlotValues = tmp;
    DATA(i).Packet = [1,1,1,1,1];
end

% histogram(r1);

Total_Packets = sum(r1);


%% Frame Arrangement

DATA1 = struct;

for iii = 1:num_slots
    DATA1(iii).Index = iii;
end


for ii = 1:user_density
    for jj = 1:DATA(ii).Numslots
    for jj = 1:C{ii,2}
        DATA1(C{ii,3}(jj)).UsersTX = [DATA1(C{ii,3}(jj)).UsersTX DATA(ii).Index];
        C1{C{ii,3}(jj),2} = [C1{C{ii,3}(jj),2} C{ii,1}];
    end
end

for ij = 1:num_slots
    C1{ij,3} = length(C1{ij,2});
end

for jj = 1:num_slots
    if C1{jj,3} == 0
        
    else
        C1{jj,4} = zeros(1,length(C{1,4}));
        for jk = 1:C1{jj,3}
            C1{jj,4} = C1{jj,4}+C{C1{jj,2}(jk),4};
        end
    end
end

