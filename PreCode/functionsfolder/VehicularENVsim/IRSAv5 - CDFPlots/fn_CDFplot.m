% This function calculates the CDF of empirical distribution data and plots
% the CDF.

function fn_CDFplot(X)

tmp = X;

% Sorting all the values in ascending order.
stmp = sort(tmp);

% Genarating CDF Values
cdf_values = (1:length(X))./length(X);

% Modifying to start from zero - Not Needed.
% cdf_values1 = [0 cdf_values(1:(end-1))];

% CDF Plot
figure;
plot(stmp,cdf_values);
grid on;
xlabel('Time(seconds)');
ylabel('CDF Value');
legend('Channel Access Delay-IRSA','location','best');
title('CDF plot');
% hold on;

end


% tmp = sort(reshape(X,prod(size(X)),1));
% Xplot = reshape([tmp tmp].',2*length(tmp),1);
% 
% tmp = [1:length(X)].'/length(X);
% Yplot = reshape([tmp tmp].',2*length(tmp),1);
% Yplot = [0; Yplot(1:(end-1))];
% 
% figure(gcf);
% hp = plot(Xplot, Yplot);
