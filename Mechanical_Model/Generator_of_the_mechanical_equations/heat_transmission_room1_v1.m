%This function gives the temperature of a node in a 'exchange heat lumped'
%   The parameter you have to pass to the function are: 
%   lenght of the time step (time_gap)
%   Initial temperature
%   density of the fluid element you are considering
%   heat capacity of the fluid element you are considering
%   volume of the element you are considering
%   node transf caracteristics
%
%   The last parameter is dependent to what your analysis does.
%   For instance, if you are considering the heat transfert form a room (a) to
%   another (room b), where each of them is concentrated in a point 
%   ('exchange heat lumped') there are to main fenomena to keep under
%   consideration: Conductivity of the walls and Convection from the wall
%   to the inner room.
%   the formula of the heat variation appears is:
%   k*A*(Ta(t)-T(a-b)wall)=density*Cp*Vol(dTa/dt)
%   so, Ta(t)=T(a-b)wall+(Ta(0)-T(a-b)wall)exp[-(k*A/density*Cp*Vol)*t]

%   For the fact that v-1 is substituted by steps look in the comments of
%   'heat_transmission_room_234_v1' 

% No window included in the code. Not necessary and really eavy for the CPU


global i j f density_wall heat_capacity_wall thermal_condu conv_coeff time_gap;
h = thermal_condu;
k = conv_coeff;
t = time_gap;

%for more comments chech the file called 'heat_transmission_room234.m'

%half-wall
%for a side of the wall there are two contributions:
%1) from the other side of the wall Conduction
%2) from the air of the room Convection

%wall1
%k*Area+h*Area/s
Area1 = room(i,j,f).wall1(1)*room(i,j,f).wall1(2) - room(i,j,f).wall1(6); s = room(i,j,f).wall1(3)/2; %Area to heat ; half thickness to heat (wall) | room(i,j,f).wall1(6) is the window area
Tinit_wall1 = room_temp(i,j,f).temper_wall1(steps); Too_air = room_temp(i,j,f).temperature(steps); Too_wall3 = room_temp(i,j-1,f).temper_wall3(steps);
q1_air = ((h*Area1)+(k*Area1/(s/2)))*(Tinit_wall1 - Too_air); %convection + coduction air->wall1
q1_wall3 = (k*Area1/s)*(Tinit_wall1 - Too_wall3);  %conduction wall3->1

volume_wall = Area1*s; a_wall = volume_wall*density_wall*heat_capacity_wall;
Tfin_wall1 = Tinit_wall1 - (q1_air + q1_wall3)*t/a_wall;
room(i,j,f).temper_wall1(v) = Tfin_wall1; %final temperature af the half wall


%wall2
Area2 = room(i,j,f).wall2(1)*room(i,j,f).wall2(2) - room(i,j,f).wall2(6); s = room(i,j,f).wall2(3)/2; %Area to heat ; half thickness to heat (wall)
Tinit_wall2 = room_temp(i,j,f).temper_wall2(steps); Too_air = room_temp(i,j,f).temperature(steps); Too_wall4 = room_temp(i-1,j,f).temper_wall4(steps);
q2_air = ((h*Area2)+(k*Area2/(s/2)))*(Tinit_wall2 - Too_air); %convection + coduction air->wall2
q2_wall4 = (k*Area2/s)*(Tinit_wall2 - Too_wall4);  %conduction wall4->2

volume_wall = Area2*s; a_wall = volume_wall*density_wall*heat_capacity_wall;
Tfin_wall2 = Tinit_wall2 - (q2_air + q2_wall4)*t/a_wall;
room(i,j,f).temper_wall2(v) = Tfin_wall2; %final temperature af the half wall


%wall3
Area3 = room(i,j,f).wall3(1)*room(i,j,f).wall3(2) - room(i,j,f).wall3(6); s = room(i,j,f).wall3(3)/2; %Area to heat ; half thickness to heat (wall)
Tinit_wall3 = room_temp(i,j,f).temper_wall3(steps); Too_air = room_temp(i,j,f).temperature(steps); Too_wall1 = room_temp(i,j+1,f).temper_wall1(steps);
q3_air = ((h*Area3)+(k*Area3/(s/2)))*(Tinit_wall3 - Too_air); %convection + coduction air->wall3
q3_wall1 = (k*Area3/s)*(Tinit_wall3 - Too_wall1);  %conduction wall1->3

volume_wall = Area3*s; a_wall = volume_wall*density_wall*heat_capacity_wall;
Tfin_wall3 = Tinit_wall3 - (q3_air + q3_wall1)*t/a_wall;
room(i,j,f).temper_wall3(v) = Tfin_wall3; %final temperature af the half wall


%wall4
Area4 = room(i,j,f).wall4(1)*room(i,j,f).wall4(2) - room(i,j,f).wall4(6); s = room(i,j,f).wall4(3)/2; %Area to heat ; half thickness to heat (wall)
Tinit_wall4 = room_temp(i,j,f).temper_wall4(steps); Too_air = room_temp(i,j,f).temperature(steps); Too_wall2 = room_temp(i+1,j,f).temper_wall2(steps);
q4_air = ((h*Area4)+(k*Area4/(s/2)))*(Tinit_wall4 - Too_air); %convection + coduction air->wall4
q4_wall2 = (k*Area4/s)*(Tinit_wall4 - Too_wall2);  %conduction wall2->4

volume_wall = Area4*s; a_wall = volume_wall*density_wall*heat_capacity_wall;
Tfin_wall4 = Tinit_wall4 - (q4_air + q4_wall2)*t/a_wall;
room(i,j,f).temper_wall4(v) = Tfin_wall4; %final temperature af the half wall


%wall5
Area5 = room(i,j,f).wall5(1)*room(i,j,f).wall5(2) - room(i,j,f).wall5(6); s = room(i,j,f).wall5(3)/2; %Area to heat ; half thickness to heat (wall)
Tinit_wall5 = room_temp(i,j,f).temper_wall5(steps); Too_air = room_temp(i,j,f).temperature(steps); Too_wall6 = room_temp(i,j,f-1).temper_wall6(steps);
q5_air = ((h*Area5)+(k*Area5/(s/2)))*(Tinit_wall5 - Too_air); %convection + coduction air->wall5
q5_wall6 = (k*Area5/s)*(Tinit_wall5 - Too_wall6);  %conduction wall6->5

volume_wall = Area5*s; a_wall = volume_wall*density_wall*heat_capacity_wall;
Tfin_wall5 = Tinit_wall5 - (q5_air + q5_wall6)*t/a_wall;
room(i,j,f).temper_wall5(v) = Tfin_wall5; %final temperature af the half wall


%wall6
Area6 = room(i,j,f).wall6(1)*room(i,j,f).wall6(2) - room(i,j,f).wall6(6); s = room(i,j,f).wall6(3)/2; %Area to heat ; half thickness to heat (wall)
Tinit_wall6 = room_temp(i,j,f).temper_wall6(steps); Too_air = room_temp(i,j,f).temperature(steps); Too_wall5 = room_temp(i,j,f+1).temper_wall5(steps);
q6_air = ((h*Area6)+(k*Area6/(s/2)))*(Tinit_wall6 - Too_air); %convection + coduction air->wall6
q6_wall5 = (k*Area6/s)*(Tinit_wall6 - Too_wall5);  %conduction wall5->6

volume_wall = Area6*s; a_wall = volume_wall*density_wall*heat_capacity_wall;
Tfin_wall6 = Tinit_wall6 - (q6_air + q6_wall5)*t/a_wall;
room(i,j,f).temper_wall6(v) = Tfin_wall6; %final temperature af the half wall



%Cuz the air temperature is fixed on the timeI do not to change it step by step

%for the air of the room the are 6 contributes coming from the 6 walls.
% Tinit_air = room(i,j,f).temperature(v-1);
% q1_wall_air = ((h*Area1)+(k*Area1/(s/2)))*(Tinit_air - Tinit_wall1); %convection + coduction wall1->air || Tinit_wall1 = Too_wall1
% q2_wall_air = ((h*Area2)+(k*Area2/(s/2)))*(Tinit_air - Tinit_wall2);
% q3_wall_air = ((h*Area3)+(k*Area3/(s/2)))*(Tinit_air - Tinit_wall3);
% q4_wall_air = ((h*Area4)+(k*Area4/(s/2)))*(Tinit_air - Tinit_wall4);
% q5_wall_air = ((h*Area5)+(k*Area5/(s/2)))*(Tinit_air - Tinit_wall5);
% q6_wall_air = ((h*Area6)+(k*Area6/(s/2)))*(Tinit_air - Tinit_wall6);
% 
% volume_room = room(i,j,f).wall1(1)*room(i,j,f).wall1(2)*room(i,j,f).wall2(1);
% a_air = volume_room*density_air*heat_capacity_air;
% Tfin_air = Tinit_air - (q1_wall_air + q2_wall_air + q3_wall_air + q4_wall_air + q5_wall_air + q6_wall_air)*t/a_air;
% room(i,j,f).temperature(v) = Tfin_air; %final temperature of the air



% %sum of the round ares
% sum_areas = Area1 + Area2 + Area3 + Area4 + Area5 + Area6;
% %weightted outside temperature
% Text_gen_sides = (room(i,j,f).temper_wall1(v-1)*Area1 + room(i,j,f).temper_wall2(v-1)*Area2 + room(i,j,f).temper_wall3(v-1)*Area3 + room(i,j,f).temper_wall4(v-1)*Area4)/sum_areas;
% Text_gen_floorroof = (room(i,j,f).temper_wall5(v-1)*Area5 + room(i,j,f).temper_wall6(v-1)*Area6)/sum_areas;
% Text_gen = Text_gen_sides + Text_gen_floorroof;
% 
% volume_room = room(i,j,f).wall1(1)*room(i,j,f).wall1(2)*room(i,j,f).wall2(1);
% 
% %final value of the room temperature
% room(i,j,f).temperature(v) = Text_gen + (room(i,j,f).temperature(v-1) - Text_gen)*exp((-t*sum_areas*k)/(density_air*heat_capacity_air*volume_room));

%to check the inner room temperature
%if i == 3 && j == 5 && f == 3
%fprintf('%f\t %f\t %f\t %f\t %f\n',f,i,j,v,room(i,j,f).temperature(v)-C2K);
%pause(0.1);
%end




