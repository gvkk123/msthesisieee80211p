%%
clc;
clear all;
close all;

%%
c = -pi:.04:pi;

cx = cos(c);
cy = -sin(c);

hf = figure('color','white');
axis on, axis equal
grid on

line(cx, cy, 'color', [.4 .4 .8],'LineWidth',3);
title('See Pythagoras Run!','Color',[.6 0 0])
hold on

x = [-1 0 1 -1];
y =   [0 0 0 0];

ht = area(x,y,'facecolor',[.6 0 0]);
set(ht,'XDataSource','x')
set(ht,'YDataSource','y')

for j = 1:length(c)
    x(2) = cx(j);
    y(2) = cy(j);
    refreshdata(hf,'caller')
    drawnow
end