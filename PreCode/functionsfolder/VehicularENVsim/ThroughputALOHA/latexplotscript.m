clc;
clear;
close all;

%%
%For printing into eps file with 600dpi

print('-deps','-r600','plr.eps')

%%
%Setting font name and title

%fontname = 'Times';
%fontname = 'Helvetica';
%fontname = 'Palatino';
%Palatino Linotype
%fontsize = 10;

set(0,'DefaultTextFontName','Helvetica',...
'DefaultTextFontSize',10,...
'DefaultAxesFontName','Helvetica',...
'DefaultAxesFontSize',10);
% 'DefaultLineLineWidth',1,...
% 'DefaultLineMarkerSize',7.75)

%%

% Only black color plots in current session

%set(groot,'DefaultAxesColorOrder',[0 0 0])
  
set(groot,'DefaultAxesColorOrder',[0 0 0],...
      'DefaultAxesLineStyleOrder','-|--|-.|:|-*')
  
% https://www.mathworks.com/help/matlab/creating_plots/
% set-default-line-styles.html?s_tid=answers_rc2-2_p5_MLT

%%

% x0=10;
% y0=10;
% width=550;  %default-560
% height=400; %default-420
% set(gcf,'units','points','position',[x0,y0,width,height]);