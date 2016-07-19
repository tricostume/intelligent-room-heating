samples = 365*24*60*60/time_gap;
samples = time_gap*samples/600; %sampling every ten minutes

%Initialiazation

%Ground
ground_temperature = Tground_ten; %zeros(1,samples); %conresponding to the wall6      
%wall1 = south; wall2 = west; wall3 = north; wall4 = east; %wall5 = floor; wall6 = roof;     

%Air Out
c_var_temp = 0; c_pid = 0;
for ty = 1 : 365*24*60*60/time_gap;
    c_var_temp = c_var_temp +1;
    if c_var_temp == 600/time_gap;
        c_pid = c_pid +1;
        exterior_temperature(c_pid) = T0_out_all(ty); %zeros(1,samples); %conresponding to the wall6      
        c_var_temp = 0;
    end
end
clear c_var_temp c_pid

%rooms
for f = 1 : n_floors    %f is the compact version of 'floor'
    for i = 1 : cells
       for j = 1 : cells
           if hotel_matrix(i,j,f) == 2 || hotel_matrix(i,j,f) == 3 || hotel_matrix(i,j,f) == 4
               room_var(i,j,f).id = hotel_matrix (i,j,f);
               room_var(i,j,f).temperature = zeros(1,samples);        
               room_var(i,j,f).num = room(i,j,f).num;
               
               temp_room1 = room(i,j,f).wall1;
               temp_room1(5) = temp_room1(6); temp_room1(6) = temp_room1(7);
               temp_room2 = room(i,j,f).wall2;
               temp_room2(5) = temp_room2(6); temp_room2(6) = temp_room2(7);
               temp_room3 = room(i,j,f).wall3;
               temp_room3(5) = temp_room3(6); temp_room3(6) = temp_room3(7);
               temp_room4 = room(i,j,f).wall4;
               temp_room4(5) = temp_room4(6); temp_room4(6) = temp_room4(7);
               temp_room5 = room(i,j,f).wall5;
               temp_room5(5) = temp_room5(6); temp_room5(6) = temp_room5(7);
               temp_room6 = room(i,j,f).wall6;
               temp_room6(5) = temp_room6(6); temp_room6(6) = temp_room6(7);
               
               for h2 = 1 : 6
                  room_var(i,j,f).wall(1,h2) = temp_room1(h2); %[dim1 dim2 thick room_wall area_w flag_sun; second wall; third; ...]
                  %wall1 = south; wall2 = west; wall3 = north; wall4 = east; %wall5 = floor; wall6 = roof;
                  room_var(i,j,f).wall(2,h2) = temp_room2(h2);
                  room_var(i,j,f).wall(3,h2) = temp_room3(h2);
                  room_var(i,j,f).wall(4,h2) = temp_room4(h2);
                  room_var(i,j,f).wall(5,h2) = temp_room5(h2);
                  room_var(i,j,f).wall(6,h2) = temp_room6(h2);
               end
               clear temp_room1 temp_room2 temp_room3 temp_room4 temp_room5 temp_room6 h2
               
               room_var(i,j,f).wall_HC_flux = zeros(1,samples); %flux of wall and heater and cooler        
               room_var(i,j,f).solar_flux = zeros(1,samples);   %flux of sun through windows
               room_var(i,j,f).activation = room_var(i,j,f).activation +0;   %'0' nothing; 1 costumer in; 2 custumer in + heating; 3 customer in + cooling
               %already defined in ìinitial_definition_variables.m'
           end
        end
    end
 end

    
    