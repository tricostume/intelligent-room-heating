global i j f
count_room_order = count_room_order +1;


%------------------ EMARO - Hotel Optimization ----------------------------%
%                     Emanuele Sansebastiano
%
%In this code we are generating theparameter required for our hotel
%there is a struct calle 'room_order' which contains:
%1) the number of the room ('num')
%2) the price caracteristics of the room high/low level dimension bed size ('id')
%3) the capacity parameter ready to use [kW/K] ('capacity')
%4) the exogenous imput of the sun [kW] ('q_sun')
%5) the room dependency with the close rooms ('dependences')
%6) the relation beetween the rooms - heat transfer [kW/K] ('K_relation')


%% External and Internal fixed parameter

if count_room_order == 1
    %Solar radiation and ground temperature definition
    run solar_radiation

    %External temperature for the whole year
    load Textern
    pid3 = Textern; 
    hours = 365*24;
    step_h = 60*60/time_gap;
    for fz = 1 : hours
        for iz = 1 : step_h
            T0_out_all(iz + (fz-1)*step_h) = pid3(fz) + C2K;
        end
    end
    clear iz fz pid3
    
    total_step_30 = hours*step_h;

    %Corridor temperature
    T_corr = 23 + C2K;
    T_corridor = ones(hours*step_h,1); T_corridor = T_corridor * T_corr;

    % for i = 1 : steps_day
    %     T0_out(i) = T0_out_all(i + (day-1)*steps_day);
    % end
end

%%

room_order(count_room_order).num = count_room_order; %num

%quality of the room; dimension of the room; bed definition; change the first two manually.
room_order(count_room_order).id = 100 + hotel_matrix(i,j,f)*10 + 1;

%Capacitance
VOL = room(i,j,f).wall1(1)*room(i,j,f).wall2(1)*height;
room_order(count_room_order).capacity = heat_capacity_air*density_air*VOL; %kW/K
%eval(['room_order(count_room_order).capacity = c_', num2str(count_room_order),'_']);

a_air = VOL*density_air*heat_capacity_air;

% heat flux from the air-exchange every hour I change the 8% of the air
% with a external window and the 10% with a internal door
% q = density_air*Cp*Vol*(Tfin-Too)/t 
a_air_window = a_air/5; a_air_door = a_air/8;  %[(kg/hour)*Cp]
a_air_window = a_air_window/(60*60); a_air_door = a_air_door/(60*60);  %[(kg/sec)*Cp] = kW/K


dependences = cell(1,6);
%wall1
    if hotel_matrix(i,j-1,f) ~= 0
        solar_rad1 = solar_rad_norm_all; %kW/m
        %solar_rad_w1 = solar_rad1 * (room(i,j,f).wall1(1)*height)/9; %kW
        solar_rad_w1 = zeros(1,total_step_30);
        %solar_rad_wall1 = solar_rad1 * 8*(room(i,j,f).wall1(1)*height)/9; %kW
        %solar_rad_wall1 = zeros(1,total_step_30);
        dependences{1} = num2str(room(i,j-1,f).c4ernesto);
        %(h*A+k*A/s+h*A)
        heat_flux(1) = (2*conv_coeff + thermal_condu/S1)*(room(i,j,f).wall1(1)*height);
        if room(i,j-1,f).c4ernesto == 0
            heat_flux(1) = heat_flux(1) + a_air_door;
        end
    else
        solar_rad1 = solar_rad_norm_all; %kW/m2
        solar_rad_w1 = solar_rad1 * (room(i,j,f).wall1(1)*height)/9; %kW
        %solar_rad_w1 = zeros(1,total_step_30);
        %solar_rad_wall1 = solar_rad1 * 8*(room(i,j,f).wall1(1)*height)/9; %kW
        %solar_rad_wall1 = zeros(1,total_step_30);
        dependences{1} = num2str(room(i,j-1,f).c4ernesto);
        %(h*A+k*A/s+h*A)
        heat_flux(1) = ((8*(2*conv_coeff + thermal_condu/S2)/9)+((2*conv_coeff + thermal_cond_window/Wthick)/9))*(room(i,j,f).wall1(1)*height);
        heat_flux(1) = heat_flux(1) + a_air_window;
    end
   
%wall2
    if hotel_matrix(i-1,j,f) ~= 0
        solar_rad2 = solar_rad_normW_all; %kW/m
        %solar_rad_w1 = solar_rad1 * (room(i,j,f).wall1(1)*height)/9; %kW
        solar_rad_w2 = zeros(1,total_step_30);
        %solar_rad_wall1 = solar_rad1 * 8*(room(i,j,f).wall1(1)*height)/9; %kW
        %solar_rad_wall1 = zeros(1,total_step_30);
        dependences{2} = num2str(room(i-1,j,f).c4ernesto);
        %(h*A+k*A/s+h*A)
        heat_flux(2) = (2*conv_coeff + thermal_condu/S1)*(room(i,j,f).wall2(1)*height);
        if room(i-1,j,f).c4ernesto == 0
            heat_flux(2) = heat_flux(2) + a_air_door;
        end
    else
        solar_rad2 = solar_rad_normW_all; %kW/m2
        solar_rad_w2 = solar_rad2 * (room(i,j,f).wall2(1)*height)/9; %kW
        %solar_rad_w1 = zeros(1,total_step_30);
        %solar_rad_wall1 = solar_rad1 * 8*(room(i,j,f).wall1(1)*height)/9; %kW
        %solar_rad_wall1 = zeros(1,total_step_30);
        dependences{2} = num2str(room(i-1,j,f).c4ernesto);
        %(h*A+k*A/s+h*A)
        heat_flux(2) = ((8*(2*conv_coeff + thermal_condu/S2)/9)+((2*conv_coeff + thermal_cond_window/Wthick)/9))*(room(i,j,f).wall2(1)*height);
        heat_flux(2) = heat_flux(2) + a_air_window;
    end
    
%wall3
    if hotel_matrix(i,j+1,f) ~= 0
        solar_rad3 = zeros(1,total_step_30); %kW/m
        %solar_rad_w1 = solar_rad1 * (room(i,j,f).wall1(1)*height)/9; %kW
        solar_rad_w3 = zeros(1,total_step_30);
        %solar_rad_wall1 = solar_rad1 * 8*(room(i,j,f).wall1(1)*height)/9; %kW
        %solar_rad_wall1 = zeros(1,total_step_30);
        dependences{3} = num2str(room(i,j+1,f).c4ernesto);
        %(h*A+k*A/s+h*A)
        heat_flux(3) = (2*conv_coeff + thermal_condu/S1)*(room(i,j,f).wall3(1)*height);
        if room(i,j+1,f).c4ernesto == 0
            heat_flux(3) = heat_flux(3) + a_air_door;
        end
    else
        solar_rad3 = zeros(1,total_step_30); %kW/m2
        solar_rad_w3 = solar_rad3 * (room(i,j,f).wall3(1)*height)/9; %kW
        %solar_rad_w1 = zeros(1,total_step_30);
        %solar_rad_wall1 = solar_rad1 * 8*(room(i,j,f).wall1(1)*height)/9; %kW
        %solar_rad_wall1 = zeros(1,total_step_30);
        dependences{3} = num2str(room(i,j+1,f).c4ernesto);
        %(h*A+k*A/s+h*A)
        heat_flux(3) = ((8*(2*conv_coeff + thermal_condu/S2)/9)+((2*conv_coeff + thermal_cond_window/Wthick)/9))*(room(i,j,f).wall3(1)*height);
        heat_flux(3) = heat_flux(3) + a_air_window;
    end    

%wall4
    if hotel_matrix(i+1,j,f) ~= 0
        solar_rad4 = solar_rad_normE_all; %kW/m
        %solar_rad_w1 = solar_rad1 * (room(i,j,f).wall1(1)*height)/9; %kW
        solar_rad_w4 = zeros(1,total_step_30);
        %solar_rad_wall1 = solar_rad1 * 8*(room(i,j,f).wall1(1)*height)/9; %kW
        %solar_rad_wall1 = zeros(1,total_step_30);
        dependences{4} = num2str(room(i+1,j,f).c4ernesto);
        %(h*A+k*A/s+h*A)
        heat_flux(4) = (2*conv_coeff + thermal_condu/S1)*(room(i,j,f).wall4(1)*height);
        if room(i+1,j,f).c4ernesto == 0
            heat_flux(4) = heat_flux(4) + a_air_door;
        end
    else
        solar_rad4 = solar_rad_normE_all; %kW/m2
        solar_rad_w4 = solar_rad4 * (room(i,j,f).wall4(1)*height)/9; %kW
        %solar_rad_w1 = zeros(1,total_step_30);
        %solar_rad_wall1 = solar_rad1 * 8*(room(i,j,f).wall1(1)*height)/9; %kW
        %solar_rad_wall1 = zeros(1,total_step_30);
        dependences{4} = num2str(room(i+1,j,f).c4ernesto);
        %(h*A+k*A/s+h*A)
        heat_flux(4) = ((8*(2*conv_coeff + thermal_condu/S2)/9)+((2*conv_coeff + thermal_cond_window/Wthick)/9))*(room(i,j,f).wall4(1)*height);
        heat_flux(4) = heat_flux(4) + a_air_window;
    end
    
if f >= 2 && f < n_floors
%wall5
    if hotel_matrix(i,j,f-1) ~= -1
        %solar_rad4 = solar_rad_normE_all; %kW/m
        %solar_rad_w1 = solar_rad1 * (room(i,j,f).wall1(1)*height)/9; %kW
        %solar_rad_w4 = zeros(1,total_step_30);
        %solar_rad_wall1 = solar_rad1 * 8*(room(i,j,f).wall1(1)*height)/9; %kW
        %solar_rad_wall1 = zeros(1,total_step_30);
        dependences{5} = num2str(room(i,j,f-1).c4ernesto);
        %(h*A+k*A/s+h*A)
        heat_flux(5) = (2*conv_coeff + thermal_condu/S1)*(room(i,j,f).wall5(1)*room(i,j,f).wall5(2));
        %if room(i+1,j,f).c4ernesto == 0
        %    heat_flux4 = heat_flux4 + a_air_door;
        %end
    else
        %solar_rad4 = solar_rad_normE_all; %kW/m2
        %solar_rad_w4 = solar_rad4 * (room(i+1,j,f).wall4(1)*height)/9; %kW
        %solar_rad_w1 = zeros(1,total_step_30);
        %solar_rad_wall1 = solar_rad1 * 8*(room(i,j,f).wall1(1)*height)/9; %kW
        %solar_rad_wall1 = zeros(1,total_step_30);
        dependences{5} = num2str(room(i,j,f-1).c4ernesto);
        %(h*A+k*A/s+h*A)
        heat_flux(5) = (2*conv_coeff + thermal_condu/S2)*(room(i,j,f).wall5(1)*room(i,j,f).wall5(2));
        %heat_flux5 = heat_flux4 + a_air_window;
    end
    
%wall6
    if hotel_matrix(i,j,f+1) ~= 0
        %solar_rad4 = solar_rad_normE_all; %kW/m
        %solar_rad_w1 = solar_rad1 * (room(i,j,f).wall1(1)*height)/9; %kW
        %solar_rad_w4 = zeros(1,total_step_30);
        %solar_rad_wall1 = solar_rad1 * 8*(room(i,j,f).wall1(1)*height)/9; %kW
        %solar_rad_wall1 = zeros(1,total_step_30);
        dependences{6} = num2str(room(i,j,f+1).c4ernesto);
        %(h*A+k*A/s+h*A)
        heat_flux(6) = (2*conv_coeff + thermal_condu/S1)*(room(i,j,f).wall6(1)*room(i,j,f).wall6(2));
        %if room(i+1,j,f).c4ernesto == 0
        %    heat_flux4 = heat_flux4 + a_air_door;
        %end
    else
        %solar_rad4 = solar_rad_normE_all; %kW/m2
        %solar_rad_w4 = solar_rad4 * (room(i+1,j,f).wall4(1)*height)/9; %kW
        %solar_rad_w1 = zeros(1,total_step_30);
        %solar_rad_wall1 = solar_rad1 * 8*(room(i,j,f).wall1(1)*height)/9; %kW
        %solar_rad_wall1 = zeros(1,total_step_30);
        dependences{6} = num2str(room(i,j,f+1).c4ernesto);
        %(h*A+k*A/s+h*A)
        heat_flux(6) = (2*conv_coeff + thermal_condu/S2)*(room(i,j,f).wall6(1)*room(i,j,f).wall6(2));
        %heat_flux5 = heat_flux4 + a_air_window;
    end
    
end


    
% Solar radiation summation
room_order(count_room_order).q_sun = solar_rad_w1 + solar_rad_w2 + solar_rad_w3 + solar_rad_w4;

%dependences
cont_dep = 1;
room_order(count_room_order).dependences{cont_dep} = dependences{1};

for pid_dep = 2 : 6
    room_order(count_room_order).dependences{pid_dep} = NaN;
    flag_par = 0;
    for pid_dep2 = 1 : pid_dep -1
        if dependences{pid_dep} == dependences{pid_dep - pid_dep2}
            flag_par = flag_par +1;
        end
    end
    if flag_par == 0
        cont_dep = cont_dep +1;
        room_order(count_room_order).dependences{cont_dep} = dependences{pid_dep};
    end
end

for pid_dep = 1 : 6
    room_order(count_room_order).K_relation{pid_dep} = 0;
    for pid_dep2 = 1 : 6
        if room_order(count_room_order).dependences{pid_dep} == dependences{pid_dep2}
            room_order(count_room_order).K_relation{pid_dep} = room_order(count_room_order).K_relation{pid_dep} + heat_flux(pid_dep2); 
        end
    end
end


clear solar_rad1 solar_rad2 solar_rad3 solar_rad4 solar_rad_w1 solar_rad_w2 solar_rad_w3 solar_rad_w4
clear cont_dep pid_dep flag_par cont_dep pid_dep2 heat_flux v
clear Solar_horiz Solar_norm Solar_normE Solar_normW


