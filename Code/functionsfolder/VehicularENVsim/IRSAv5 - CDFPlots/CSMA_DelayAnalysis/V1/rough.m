n = input('1. Number of stations : ');
 if(isempty(n))
     n = 5;
 end
 
 simul_time = input ('2. Simulation time(slot time = 2) : ');
 if(isempty(simul_time))
     simul_time = 600;
 end
  
 
 fsize = input('3. Frame Size : ');
 if(isempty(fsize))
     fsize = 5;
 end
 
 
 motion_scale = input('4. Time Scale for random motion (0 - 10):' );
 if(isempty(motion_scale) | motion_scale > 10)
     motion_scale = 5;
 end
 
 
 range = input('5. Range of each station : ');
 if (isempty(range))
     range = 3;
 end
 
 count = 0;
 state = zeros(1,n);
 traffic = 0.1;
 CWmax = 10;
 CWmin = 3;
 CW = CWmin * ones(1,n);
 frame_length = zeros(1,n);
 frame_dest = zeros(1,n);
 ack_dest = zeros(1,n);
 ack_length = 4;
 sifs = 2;
 slot_time = 2;
 BCounter = zeros(1,n);
 difs = sifs + 2*slot_time;
 timer = zeros(1,n);
 stimer = zeros(1,n);
 total_transmissions = 0;
 successful_transmission = 0;
 total_collisions = 0;
 unreachable_packets = 0;
 total_acks = 0;
 ack_collisions = 0;
 unreachable_acks = 0;
 successful_acks = 0;
 
 Eb2=0.0001 * motion_scale;
 pos_x = randn(1,n);
 pos_y = randn(1,n);
 
 distance_matrix = ones(n,n);
 sending = zeros(1,n);
 busy_medium = zeros(1,n);
 
 pos_x_change = sqrt(Eb2) * randn(1,n);
 pos_y_change = sqrt(Eb2) * randn(1,n);
 
 
 
 
 for i = 1:simul_time
     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Random Motion
    
    if (count == 0)
        pos_x_change =  pos_x_change + randn(1,n) * sqrt(Eb2);
        pos_y_change =  pos_y_change + randn(1,n) * sqrt(Eb2);
        pos_x = pos_x  + pos_x_change;
        pos_y = pos_y  + pos_y_change;
    end
    
 
    if (count == 1)
        pos_x_change =  pos_x_change + randn(1,n) * sqrt(Eb2);
        pos_y_change =  pos_y_change + randn(1,n) * sqrt(Eb2);
        pos_x = pos_x  + pos_x_change;
        pos_y = pos_y  - pos_y_change;    
    end


    if (count == 2)
        pos_x_change =  pos_x_change - randn(1,n) * sqrt(Eb2);
        pos_y_change =  pos_y_change - randn(1,n) * sqrt(Eb2);
        pos_x = pos_x  - pos_x_change;
        pos_y = pos_y  - pos_y_change;    
    end

   
    
    if (count == 3)
        pos_x_change =  pos_x_change + randn(1,n) * sqrt(Eb2);
        pos_y_change =  pos_y_change + randn(1,n) * sqrt(Eb2);
        pos_x = pos_x  - pos_x_change;
        pos_y = pos_y  + pos_y_change;    
    end
    
    count = count + 1;
    
    if(count > 3)
        count = 0;
    end
    
    distance_matrix = ones(n,n);
    
    for i = 1:n
        for j = 1:n
            
            if ((pos_x(i)-pos_x(j))^2 + (pos_y(i)-pos_y(j))^2 > range^2)
                                
                distance_matrix(i,j) = 0;
                
            end
        end
    end
    
      
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     
     
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
      % State - 0
     
     transition_0to1 = zeros(1,n);
     to_send = rand(1,n);
     
     transition_0to1(state == 0 & to_send < traffic) = 1;
     
     temp_vec = sifs + rand(1,n) * 2 * fsize;
     frame_length(state ==0 & transition_0to1 > 0) = temp_vec(state ==0 & transition_0to1 > 0);
     
     temp_vec = ceil(rand(1,n) * n);
     frame_dest(state == 0 & transition_0to1 > 0)  = temp_vec(state ==0 & transition_0to1 > 0);
     
     for i = 1:n
         while ( frame_dest(i) == i | frame_dest(i) == 0)
             frame_dest(i) = ceil(rand * n);
         end
     end
     
    temp_vec = floor(rand(1,n) .* (2.^CW));
    BCounter(state == 0 & transition_0to1 > 0) = temp_vec(state == 0 & transition_0to1 > 0) * slot_time;
    
    state(transition_0to1 > 0) = 1;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     % State - 1
     
    % Medium Sensing 
     sending = zeros(1,n);
     sending(state <= -1 | state >= 5) = 1;
     %sending
     busy_medium = sending * distance_matrix;
     
     transition_1to2 = zeros(1,n);     
     transition_1to2(state == 1 & busy_medium < 1) = 1;
     
     
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     % State - 2 
     % Difs Timer
     
     timer(transition_1to2 > 0) = difs;
     transition_2to1 = zeros(1,n);
     transition_2to1(state == 2 & busy_medium > 0) = 1;
     
     timer(state == 2) = timer(state == 2) - 1;
     
     
     transition_2to3 = zeros(1,n);
     transition_2to3(state == 2 & timer<0) = 1;
     
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     
     % State - 3
     
     BCounter(state == 3 & busy_medium < 1) =  BCounter(state == 3 & busy_medium < 1) - 1;
     
     transition_3to5 = zeros(1,n);
     transition_3to5(state == 3 & BCounter<0) = 1;
     
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     % State - 5
     
     for i = 1:n
         
         if (state(i) == 5 & busy_medium(frame_dest(i)) > 1)
             
             state(i) = 6;
             
         end
         
         if (state(i) == 5 & distance_matrix(i,frame_dest(i)) < 1)
             
             state(i) = 7;
             
         end
         
     end
     
     frame_length(state >= 5) = frame_length(state >= 5) - 1;
     
     transition_5to0 = zeros(1,n);
     transition_5to0(state >=5 & frame_length < 0) = 1;
     
     CW(state > 5 & transition_5to0 > 0) = CW(state > 5 & transition_5to0 > 0) + 1;
     CW(CW > CWmax) = CWmax;
     CW(state == 5 & transition_5to0 > 0) = CWmin;
     
     total_transmissions = total_transmissions + length(state(state >= 5 & transition_5to0 > 0));
     successful_transmission = successful_transmission + length(state(state == 5 & transition_5to0 >0));
     total_collisions = total_collisions + length(state(state == 6 & transition_5to0 > 0));
     unreachable_packets = unreachable_packets + length(state(state == 7 & transition_5to0 > 0));
     
     transition_5to4 = zeros(1,n);
     
     for i = 1:n
         if(state(i) == 5 & transition_5to0(i) > 0)
         
             transition_5to4(frame_dest(i)) = 1;
             timer(frame_dest(i)) = sifs;             
             ack_dest(frame_dest(i)) = i;
             
         end
     end
     
     %state(transition_5to4 > 0) = 4;
     timer(state == 4 & busy_medium > 0) = sifs;
     
     timer(state == 4 & busy_medium < 1) = timer(state == 4 & busy_medium < 1) - 1;
     
     %timer(state == 4) = timer(state == 4) - 1
     
     
     transition_4tom1 = zeros(1,n);
     transition_4tom1(state == 4 & timer < 0) = 1;
     timer(transition_4tom1 > 0) = ack_length;
     
     
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     % State - -1
     
     for i = 1:n
         
              
         if (state(i) == -1 && busy_medium(ack_dest(i)) > 1)
                   
             state(i) = -2;
             
         end
         
         if (state(i) == -1 && distance_matrix(i,ack_dest(i)) < 1)
                                      
             state(i) = -3;
             
         end
         
         
        
     end
     
     timer(state <= -1) = timer(state <= -1) - 1;
     
     transition_m1to0 = zeros(1,n);
     transition_m1to0(state <= -1 & timer < 0) = 1;
     
     total_acks = total_acks + length(state(state <= -1 & transition_m1to0 > 0));
     successful_acks = successful_acks + length(state(state == -1 & transition_m1to0 > 0));
     ack_collisions = ack_collisions + length(state(state == -2 & transition_m1to0 > 0));
     unreachable_acks = unreachable_acks + length(state(state == -3 & transition_m1to0 > 0));
         
     %state        
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % States Conversion
     
     state(transition_0to1 > 0)  =  1;
     state(transition_1to2 > 0)  =  2;
     state(transition_2to3 > 0)  =  3;
     state(transition_3to5 > 0)  =  5;     
     state(transition_2to1 > 0)  =  1;
     state(transition_5to0 > 0)  =  0;
     state(transition_5to4 > 0)  =  4;
     state(transition_4tom1 > 0) = -1;
     state(transition_m1to0 > 0) =  0;
     
     
     %state
 end
 total_transmissions
 successful_transmission
 total_collisions
 unreachable_packets
 total_acks
 successful_acks
 ack_collisions
 unreachable_acks 
 eff = successful_transmission/total_transmissions
