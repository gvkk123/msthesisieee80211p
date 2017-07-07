function tnet = interpol2(we,alpha, ford)

%ford is a data file containing the engine map

m= 17; n= 11;

temp_array=ford(:,1);
%first column of ford -- engine speed

we_array = temp_array(1:m:m*n,1);

ind_speed = return_index(we_array,we);

%[we alpha ind_speed]

if ind_speed <= 2 
    ind_speed = 2;
end

%for we = we_array(ind_speed-1), find the array of throttle settings
throttle1 = ford((ind_speed-2)*m+1:(ind_speed-1)*m,2);
torq1 = ford((ind_speed-2)*m+1:(ind_speed-1)*m,3);
throttle2 = ford((ind_speed-1)*m+1:ind_speed*m,2);
torq2 = ford((ind_speed-1)*m+1:ind_speed*m,3);

%now isolate the throttle settings
ind_thr1 = return_index(throttle1, alpha);
ind_thr2 = return_index(throttle2, alpha);


%Time for interpolation
slope1 = (torq1(ind_thr1)-torq1(ind_thr1-1))/(throttle1(ind_thr1)-throttle1(ind_thr1-1));
tnet1 = torq1(ind_thr1-1)+slope1*(alpha-throttle1(ind_thr1-1));

slope2 = (torq2(ind_thr2)-torq2(ind_thr2-1))/(throttle2(ind_thr2)-throttle2(ind_thr2-1));
tnet2 = torq2(ind_thr2-1)+slope2*(alpha-throttle2(ind_thr2-1));

tnet = tnet1 + (tnet2-tnet1)/(we_array(ind_speed)-we_array(ind_speed-1))*(we-we_array(ind_speed-1));


