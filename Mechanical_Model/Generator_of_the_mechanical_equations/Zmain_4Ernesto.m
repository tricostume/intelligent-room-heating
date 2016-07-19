%%
clear all

%Hotel definition: in the following matrix the rooms are identified by
%numbers from 1 to 4
load hotel_complex_2 %hotel_line_test_floors
%change values manually;
%%
A2 = 5;          %[m] used for corridors
A3 = 2*A2;       %[m]
A4 = 3*A2;       %[m]
S1 = 0.1;        %[m]
S2 = 0.4;        %[m]
height = 3;      %[m]
Wthick = 0.04;   %[m] thickness window 4cm
init_temperature = 15; %[°C]
l_win = 1.5; h_win = 1;
window_space = l_win*h_win; window_proportion = 1/3;
counter_other = 0;
%n_room2 = 0; defined later 
counter2 = 0;
%n_room3 = 0;
counter3 = 0;
%n_room4 = 0;
counter4 = 0;
roomONlivingroom = 3; %type of room over the living room can be (2,3,4) 
ground = -1; %the gorund is identified as '-1'
selector = 10000; %I add selector to the all room which I don't put anyone
C2K = 273;

global i j floor f qCold qHeat density_wall heat_capacity_wall thermal_condu density_air heat_capacity_air conv_coeff time_gap;
%To dinsionate the heater we need to know the volum of the room; then,
%multiply it for 30 [kcal] and 4,186 [to convert in kW/s]
%used for every room is the FTXZ35N
qHeat = [5 9];  %[6.3 9.4]; %[kW]
qCold = [-3.5 -5.3]; %[-5 -5.8]; %[kW]
Tlow = 20+C2K;
Thigh = 26+C2K;

density_wall = 2000; %[kg/m3]
density_glass = 2400; %[kg/m3]
heat_capacity_wall = 0.9; %[kJ/kg*°K] 0.22; [kcal/kg*°C]
heat_capacity_window = 0.84; %[kJ/kg*°K]
thermal_condu = 0.8/1000; %[kJ/s*m*K]
thermal_cond_window = 0.96/1000; %[kJ/s*m*K]
% we consider the door having, generally, the same effect of a normal wall,
% what is different? the air they let in.

density_air = 1.205; %[kg/m3]
heat_capacity_air = 1.005; %[kJ/kg*°K]
conv_coeff = 15/1000; %[kJ/s*m2*K]
time_gap = 30; %[sec]         %!!!!!!!!!!!! to tune
days = 1;                     %!!!!!!!!!!!! not to tune
year_sec = 60*60*24*days;  %seconds in a year
steps = year_sec / time_gap; %this represents the seconds in a day finally (not a year)
steps_day = steps / days; abc = 1; %in the end steps and steps_day have the same value
real_step = 0; %real step used!

%% STRUCTURE OF THE HOTEL INITIALIZED (ROOM BY ROOM) 
n_floors = n_floors + 2; % real number of floors plus ground and over_roof layer

%Initialization hotel structure
for floor = 2 : n_floors 
    hotel_matrix(:,:,floor) = hotel_matrix(:,:,floor-1);
end

%initialization cells

for floor = 1 : n_floors
    for i = 1 : cells
        for j = 1 : cells
            room(i,j,floor).num = 0;
            
            % ground identified by -1 value
            if floor == 1 && hotel_matrix(i,j,floor) ~= 0
                hotel_matrix(i,j,floor) = ground;
            end
            % floors over the reception one have just cameras
            if floor > 2 && hotel_matrix(i,j,n_floors) == 1.5
                hotel_matrix(i,j,floor) = roomONlivingroom;
            end
            % over roof has just
            if floor == n_floors
                hotel_matrix(i,j,floor) = hotel_matrix(i,j,floor) * 0;
            end
        end
    end
end



%% HEAT FLUXES ARRAY(ON TIME) GENERATION

n_room2 = 0; n_room3 = 0; n_room4 = 0;
pid2 = 0;
while pid2 < 2 
    for floor = 1 : n_floors
        run room_relation_generator

        %room counter by type
        n_room2 = n_room2 + counter2;
        n_room3 = n_room3 + counter3;
        n_room4 = n_room4 + counter4;
    end
    pid2 = pid2 + 1;
end
clear lenght1 lenght2 thickness room_wall init_temperature area_window flag_sun
clear pid2 pid pidG1 pidG2 temp counter2 counter3 counter4 counter_4ernesto counter_other counter0ext counterGround
n_room2 = n_room2/2; n_room3 = n_room3/2; n_room4 = n_room4/2;

clear window_space window_proportion clear roomONlivingroom floor %selector

%% CAPAITY AND SO ON VALUES
%n_room2 = 30; n_room3 = 37; n_room4 = 12; corridor = 1; exterior = 1;

count_room_order = 0;

%starting from the up of the matrix and the ground floor:
for f = 2 : n_floors - 1
    for i = 1 : cells
        for j = 1 : cells
           if hotel_matrix(i,j,f) >= 2
               
               run for_ernesto_func
               
           end
        end
    end
end

%To change thetime_gap of Temperature and Solar radiation uncomment the following lines
room_order_temp = room_order;
clear room_order

pid_dep2 = size(room_order_temp);
gap_des = 60*60;                                %to tune!

new_steps = total_step_30*time_gap/gap_des;
same_iter = total_step_30/new_steps;

for pid_dep = 1 : pid_dep2(2)  
    room_order(pid_dep).num         = room_order_temp(pid_dep).num;
    room_order(pid_dep).id          = room_order_temp(pid_dep).id;
    room_order(pid_dep).capacity    = room_order_temp(pid_dep).capacity;
        
    for pid_dep3 = 1 : new_steps
        new_q_sun = 0;
        for pid_dep4 = 1 : same_iter
            new_q_sun = new_q_sun + room_order_temp(pid_dep).q_sun(pid_dep4+(pid_dep3 -1)*same_iter);
        end
        room_order(pid_dep).q_sun(pid_dep3) = new_q_sun/same_iter;
    end
    
    room_order(pid_dep).dependences = room_order_temp(pid_dep).dependences;
    room_order(pid_dep).K_relation  = room_order_temp(pid_dep).K_relation;
    
    %temperature outside and ground
    if pid_dep == 1
        for pid_dep3 = 1 : new_steps
            
            new_T_corridor_temp  = 0;  %initialization
            new_Tout_temp        = 0;
            new_Tground_temp     = 0;
            
            for pid_dep4 = 1 : same_iter %Make the average of the value in my gap
                new_T_corridor_temp  = new_T_corridor_temp + T_corridor   (pid_dep4 + (pid_dep3 -1)*same_iter);
                new_Tout_temp        = new_Tout_temp       + T0_out_all   (pid_dep4 + (pid_dep3 -1)*same_iter);
                new_Tground_temp     = new_Tground_temp    + Tground_temp (pid_dep4 + (pid_dep3 -1)*same_iter);
            end
            
            new_T_corridor(pid_dep3) = new_T_corridor_temp /same_iter;
            new_Tout(pid_dep3)       = new_Tout_temp       /same_iter;
            new_Tground(pid_dep3)    = new_Tground_temp    /same_iter;
        end
    end
    
    
end

clear pid_dep pid_dep2 pid_dep3 pid_dep4 room_order_temp new_q_sun new_T_corridor_temp new_Tground_temp new_Tout_temp



%% OLD STUFF

    
    
        
        

% %% HOTEL DRAWER
% 
% %To be finished (not a Priority)
% % run hotel_disp_floor
% 
% %% RECURSIVE WORK (1 OUT OF 365)
% 
% init_time_simulation = clock();
% day_iter = 365/days; %days is always '1'
% real_step_var = 0;
% for i = 1 : 3600*24/600 %howmany ten minutes are in one day
%     sample_array(i) = i*600/time_gap;
% end
% 
% %%
% 
% for day = 1 : day_iter
%     
%     
%     %% INITIAL DEFINITION OF THE VARIABLES
% 
%     %Text = 0 + C2K;
%     %Text_ground = 0 + C2K;
%     Tint_corr = 23 + C2K;
%     Tint_living = Tint_corr; 
%     Tint_badroom = 20 + C2K;
% 
%     %(used in the function below)
% 
%     run initial_definition_variables
%     
%     if day == 1
%         run room_temp_definition
%     end
%         
%     %% HOTEL SIMULATION
% 
%     fprintf('simulation is working\n');
%     for v = 1 : steps %cuz every time I have to look at the previous step
%         
%         if any(v==sample_array)  %steps among the year every 600 sec
%             real_step_var = real_step_var +1;
%             step_array_var(real_step_var) = real_step_var; %array of steps to make plots
%         end
%         
%         real_step = real_step +1; %steps among the year every 30 sec
%         
%         if real_step == 1
%             %parameter required definition
%             run var_usefull_definition
%         end
% 
%         step_array(real_step) = real_step; %array of steps to make plots
%         for f = 2 : n_floors %the ground has just a fixed temperature    
%             for i = 1 : cells
%                 for j = 1 : cells
%                     
%                     if hotel_matrix(i,j,f) >= 2
%                         if v == 1 
%                             run heat_transmission_room234_v1
%                         else
%                             run heat_transmission_room234
%                         end
%                         if any(v==sample_array)
%                             run saving_parameter_room234
%                         end
%                     end
%                     
%                     if hotel_matrix(i,j,f) > 0 && hotel_matrix(i,j,f) < 2
%                         if v == 1
%                             run heat_transmission_room1_v1
%                         else
%                             run heat_transmission_room1
%                         end
%                     end
%                     
%                     if hotel_matrix(i,j,f) == 0
%                         if room(i,j,f).num > 0
%                             if v == 1
%                                 run heat_transmission_room0_v1
%                             else
%                                 run heat_transmission_room0
%                             end
%                         end
%                     end    
%                 end
%             end
%         end
% 
%         if real_step >= steps - steps_day*(days-abc)
%             time_used = timeevaluator_sec(init_time_simulation)/60;
%             fprintf('Day done: %f\t out of 365 | time: %f\n',day,time_used);
%             save('EXPERIMENT_LAB2_some_day_activationBIS');
% 
% %             hold off %evolution temperatures day by day
% %             figure(abc+1)
% %             plot(step_array(1:real_step), room_var(3,5,3).temperature(1:real_step)-C2K);
% %             hold on
% %             plot(step_array(1:real_step), room_var(3,5,3).activation(1:real_step));
% 
%             abc = abc +1;
%         end
% 
%     end
%     run room_temp_definition % necessary to have the val of room(..)...(v-1) when v = 1
% 
% end
% %clear f v i j abc
% fprintf('simulation has finished\n');
% 
% %room_var(i,j,f).temperature(1) = room_var(i,j,f).temperature(2);
% %room_var(i,j,f).wall_HC_flux(1) = room_var(i,j,f).wall_HC_flux(2);
% %room_var(i,j,f).solar_flux(1) = room_var(i,j,f).solar_flux(2);
% 
% time_used = timeevaluator_sec(init_time_simulation)/60
% 
% save('EXPERIMENT_LAB2_some_day_activationBIS');

% for j = 1 : 4
%     for f = 1 : 3
%         %figure
%         %plot(step_array(:), room(2+j,5,1+f).temperature(:)-C2K);
%         figure
%         plot(step_array(:), room_var(2+j,5,1+f).activation(1:steps));
%     end
% end

%%
%Graph deawings
% for f = 2 : n_floors %the ground has just a fixed temperature    
%     for i = 1 : cells
%         for j = 1 : cells
%             if room(i,j,f).num > 0 || hotel_matrix(i,j,f) < 0
%                 figure((i+j)*f)
%                 plot(step_array(:), room(i,j,f).temperature(:)-C2K);
%             end
%         end
%     end
% end



%%


%end



