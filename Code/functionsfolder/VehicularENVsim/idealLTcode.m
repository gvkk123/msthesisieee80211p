%%
clc;
clear all;
close all;

%% IDEAL SOLITON DISTRIBUTION

N = 100;

p = zeros(1,N);

p(1) = 1/N;

for k = 2:N
    p(k) = 1/(k*(k-1));
end

%%

figure
stem(p);
hold on;
plot(p);
grid on;