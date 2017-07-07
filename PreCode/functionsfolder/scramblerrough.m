%%
clc;
clear all;
close all;

%%

% Data is fed in as coloumn vector

% N = 8;
% 
% data = randi([0 N-1],5,1)
% 
% data = randi([0 1],8,1)


% Scrambler Polynomial - S(x) = x^7 + x^4 + 1

% The 127-bit sequence generated repeatedly by the scrambler shall be 
%(leftmost used first), when the all ones initial state is used.

% seq =[ 00001110 11110010 11001001 00000010 00100110 00101110 10110110 ...
%     00001100 11010100 11100111 10110100 00101010 11111010 01010001 ...
%     10111000 1111111 ];
 

% The same scrambler is used to scramble transmit data and to descramble 
% receive data. When transmitting, the initial state of the scrambler shall
% be set to a pseudorandom nonzero state. The seven LSBs of the SERVICE 
% field shall be set to all zeros prior to scrambling to enable estimation 
% of the initial state of the scrambler in the receiver.

%'1 + z^-4 + z^-7'


data = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;1;0;0;0;0;0];

% Initial states
IN_ST =  [1 0 1 1 1 0 1];

% % Calculation base
% N = 2;
% 
% 
% 
% scr1 = comm.Scrambler(N,'1 + z^-4 + z^-7',IN_ST);
% 
% scr = comm.Scrambler(N, [0 -4 -7],...
%           IN_ST); 
%  
%  
%       scrData = scr1(data)
%       
%       descr = comm.Descrambler(N, [0 -4 -7],...
%           IN_ST); 
%       
%       dataout = descr(scrData);
%       
%       isequal(data,dataout)
%       

%%


input_bits = data;

initial_state = (IN_ST);


output_bits = scramblerfn(input_bits, initial_state);



%isequal(output_bits,scrData)

%end



finalscrdata = [0;1;1;0;1;1;0;0;0;0;0;1;1;0;0;1;1;0;0;0;1;0;0;1]

%isequal(scrData,finalscrdata)

isequal(output_bits,finalscrdata)
%%


doutput_bits = descramblerfn(output_bits, initial_state);

isequal(input_bits,doutput_bits)
