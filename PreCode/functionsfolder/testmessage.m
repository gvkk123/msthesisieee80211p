function txdata = testmessage()
%%
% clc;
% clear all;
% close all;

%%
% str='....Joy, bright spark of divinity, Daughter of Elysium, Fire-insired we tre';
% a=sprintf('%X', str);
% S = reshape(a,10,[])';
% display(S);

%% Table G1-Data
% DATA is for string below with MAC Header and CRC32 - Total 100 Octets.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Joy, bright spark of divinity,
% Daughter of Elysium,
% Fire-insired we trea
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DATA='0402002E006008CD37A60020D6013CF1006008AD3BAF00004A6F792C2062726967687420737061726B206F6620646976696E6974792C0A4461756768746572206F6620456C797369756D2C0A466972652D696E73697265642077652074726561DA5799ED';

S = reshape(DATA,10,[])';
%display(S);

BINU=hexToBinaryVector(DATA);
BINU = [0 0 0 0 0 BINU];
%display(BINU);
%%
BINU1 = reshape(BINU,8,[])';

for i = 1: length(BINU1)
    BINU1(i,:)=fliplr(BINU1(i,:));
end

BINU2 =  BINU1';
BINU3 = reshape(BINU2,[],1);
%%
txdata = BINU3;
% service = zeros(16,1);
% 
% tail = zeros(6,1);
% 
% zerobits = zeros(42,1);
% 
% txdata = [service', BINU3', tail', zerobits']';

end
