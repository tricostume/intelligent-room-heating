clear all;

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
conv_coeff = 20/1000; %[kJ/s*m2*K]
time_gap = 1; %[sec]         %!!!!!!!!!!!! to tune
days = 1/24;                        %!!!!!!!!!!!! to tune
year_sec = 60*60*24*days;  %seconds in a year
steps = year_sec / time_gap;
steps_day = steps / days;
C2K = 273;
Tinit_walla = 25 + C2K; 
Tinit_wallb = 0 + C2K;

k = thermal_condu;
kw = thermal_cond_window;
h = conv_coeff;
t = time_gap;

room.temperature = zeros(1,steps);

Too_air = 15 + C2K;
Tinit_air = Too_air;
room.temperature(1) = Tinit_air;

%wall1
Area1 = 5*5;  sa = 0.4/2;
Tinit_wall1 = Tinit_walla; 
%wall2
Area2 = 5*5*3;  sb = 0.1/2;
Tinit_wall2 = Tinit_wallb;


for v = 2 : steps
Tinit_air = room.temperature(v-1);
%for the air of the room the are 6 contributes coming from the 6 walls.
q1_wall_air = ((h*Area1)+(k*Area1/(sa/2)))*(Tinit_air - Tinit_wall1); %convection + coduction wall1->air || Tinit_wall1 = Too_wall1
q2_wall_air = ((h*Area2)+(k*Area2/(sb/2)))*(Tinit_air - Tinit_wall2);

volume_room = 5*5*5;
a_air = volume_room*density_air*heat_capacity_air;
Tfin_air = Tinit_air - (q1_wall_air + q2_wall_air)*t/a_air;
room.temperature(v) = Tfin_air; %final temperature of the air



%to check the inner room temperature
fprintf('%f\t %f\n',v,room.temperature(v)-C2K);
pause(0.1);

end