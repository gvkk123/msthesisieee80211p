f = @(x) x.^2;
g = @(x) 5*sin(x)+5;
dmn = -pi:0.001:pi;
xeq = dmn(abs(f(dmn) - g(dmn)) < 0.002);
figure(1);
plot(dmn,f(dmn),'b-',dmn,g(dmn),'r--',xeq,f(xeq),'g*');
xlim([-pi pi]);
legend('f(x)', 'g(x)', 'f(x)=g(x)', 'Location', 'SouthEast');
xlabel('x');
title('Example Figure');
print('example', '-dpng', '-r300'); %<-Save as PNG with 300 DPI