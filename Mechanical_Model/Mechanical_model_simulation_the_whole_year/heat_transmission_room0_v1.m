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


global i j f density_wall heat_capacity_wall thermal_condu conv_coeff time_gap;
k = thermal_condu;
kw = thermal_cond_window;
h = conv_coeff;
t = time_gap;
corrector = 1.0000e-99; %required to avoid values going to INFINITY (NaN) a_window somotimes is equal to '0'

%conduction
%for a side of the wall there are two contributions:
%1) from the other side of the wall Conduction
%2) from the air of the room Convection

%wall1
if hotel_matrix(i,j-1,f) > 0 %room(i,j-1,f).num > 0 / would be the same 
    %k*Area+h*Area/s
    Area1 = room(i,j,f).wall1(1)*room(i,j,f).wall1(2) - room(i,j,f).wall1(6); s = room(i,j,f).wall1(3)/2; %Area to heat ; half thickness to heat (wall) | room(i,j,f).wall1(6) is the window area
    Tinit_wall1 = room_temp(i,j,f).temper_wall1(steps); Too_air = room_temp(i,j,f).temperature(steps); Too_wall3 = room_temp(i,j-1,f).temper_wall3(steps);
    q1_air = ((h*Area1)+(k*Area1/(s/2)))*(Tinit_wall1 - Too_air); %convection + coduction air->wall1
    q1_wall3 = (k*Area1/s)*(Tinit_wall1 - Too_wall3);  %conduction wall3->1
    
    %solar radiation
    if room(i,j,f).wall1(7) == 1
        q1_sun = solar_rad_norm(steps)*Area1*t;    
    elseif room(i,j,f).wall1(7) == 2
        q1_sun = solar_rad_normW(steps)*Area1*t;
    elseif room(i,j,f).wall1(7) == 4
        q1_sun = solar_rad_normE(steps)*Area1*t;
    else
        q1_sun = 0;
    end

    volume_wall = Area1*s; a_wall = volume_wall*density_wall*heat_capacity_wall;
    Tfin_wall1 = Tinit_wall1 - (q1_air + q1_wall3 - q1_sun)*t/a_wall;
    room(i,j,f).temper_wall1(v) = Tfin_wall1; %final temperature af the half wall
    
    %window1
    Area1w = room(i,j,f).wall1(6); s = Wthick/2; %Area to heat ; half thickness to heat (window)
    Tinit_window1 = room_temp(i,j,f).temper_window1(steps); Too_air = room_temp(i,j,f).temperature(steps); Too_window3 = room_temp(i,j-1,f).temper_window3(steps);
    q1w_air = ((h*Area1w)+(kw*Area1w/(s/2)))*(Tinit_window1 - Too_air); %convection + coduction air->window1
    q1w_window3 = (kw*Area1w/s)*(Tinit_window1 - Too_window3);  %conduction window3->1

    volume_window = Area1w*s; a_window = volume_window*density_glass*heat_capacity_window;
    Tfin_window1 = Tinit_window1 - (q1w_air + q1w_window3)*t/(a_window+corrector);
    room(i,j,f).temper_window1(v) = Tfin_window1; %final temperature of the half window    
end


%wall2
if hotel_matrix(i-1,j,f) > 0
    Area2 = room(i,j,f).wall2(1)*room(i,j,f).wall2(2) - room(i,j,f).wall2(6); s = room(i,j,f).wall2(3)/2; %Area to heat ; half thickness to heat (wall)
    Tinit_wall2 = room_temp(i,j,f).temper_wall2(steps); Too_air = room_temp(i,j,f).temperature(steps); Too_wall4 = room_temp(i-1,j,f).temper_wall4(steps);
    q2_air = ((h*Area2)+(k*Area2/(s/2)))*(Tinit_wall2 - Too_air); %convection + coduction air->wall2
    q2_wall4 = (k*Area2/s)*(Tinit_wall2 - Too_wall4);  %conduction wall4->2
    
    %solar radiation
    if room(i,j,f).wall2(7) == 1
        q2_sun = solar_rad_norm(steps)*Area2*t;    
    elseif room(i,j,f).wall2(7) == 2
        q2_sun = solar_rad_normW(steps)*Area2*t;
    elseif room(i,j,f).wall2(7) == 4
        q2_sun = solar_rad_normE(steps)*Area2*t;
    else
        q2_sun = 0;
    end

    volume_wall = Area2*s; a_wall = volume_wall*density_wall*heat_capacity_wall;
    Tfin_wall2 = Tinit_wall2 - (q2_air + q2_wall4 - q2_sun)*t/a_wall;
    room(i,j,f).temper_wall2(v) = Tfin_wall2; %final temperature af the half wall
    
    %window2
    Area2w = room(i,j,f).wall2(6); s = Wthick/2; %Area to heat ; half thickness to heat (window)
    Tinit_window2 = room_temp(i,j,f).temper_window2(steps); Too_air = room_temp(i,j,f).temperature(steps); Too_window4 = room_temp(i-1,j,f).temper_window4(steps);
    q2w_air = ((h*Area2w)+(kw*Area2w/(s/2)))*(Tinit_window2 - Too_air); %convection + coduction air->window2
    q2w_window4 = (kw*Area2w/s)*(Tinit_window2 - Too_window4);  %conduction window4->2

    volume_window = Area2w*s; a_window = volume_window*density_glass*heat_capacity_window;
    Tfin_window2 = Tinit_window2 - (q2w_air + q2w_window4)*t/(a_window+corrector);
    room(i,j,f).temper_window2(v) = Tfin_window2; %final temperature of the half window
    
    %to check the wall temperature
    %fprintf('%f\t %f\t %f\t %f\t %f\n',f,i,j,v,room(i,j,f).temper_wall2(v)-C2K);
end

%wall3
if hotel_matrix(i,j+1,f) > 0
    Area3 = room(i,j,f).wall3(1)*room(i,j,f).wall3(2) - room(i,j,f).wall3(6); s = room(i,j,f).wall3(3)/2; %Area to heat ; half thickness to heat (wall)
    Tinit_wall3 = room_temp(i,j,f).temper_wall3(steps); Too_air = room_temp(i,j,f).temperature(steps); Too_wall1 = room_temp(i,j+1,f).temper_wall1(steps);
    q3_air = ((h*Area3)+(k*Area3/(s/2)))*(Tinit_wall3 - Too_air); %convection + coduction air->wall3
    q3_wall1 = (k*Area3/s)*(Tinit_wall3 - Too_wall1);  %conduction wall1->3
    
    %solar radiation
    if room(i,j,f).wall3(7) == 1
        q3_sun = solar_rad_norm(steps)*Area3*t;    
    elseif room(i,j,f).wall3(7) == 2
        q3_sun = solar_rad_normW(steps)*Area3*t;
    elseif room(i,j,f).wall3(7) == 4
        q3_sun = solar_rad_normE(steps)*Area3*t;
    else
        q3_sun = 0;
    end

    volume_wall = Area3*s; a_wall = volume_wall*density_wall*heat_capacity_wall;
    Tfin_wall3 = Tinit_wall3 - (q3_air + q3_wall1 - q3_sun)*t/a_wall;
    room(i,j,f).temper_wall3(v) = Tfin_wall3; %final temperature af the half wall
    
    %window3
    Area3w = room(i,j,f).wall3(6); s = Wthick/2; %Area to heat ; half thickness to heat (window)
    Tinit_window3 = room_temp(i,j,f).temper_window3(steps); Too_air = room_temp(i,j,f).temperature(steps); Too_window1 = room_temp(i,j+1,f).temper_window1(steps);
    q3w_air = ((h*Area3w)+(kw*Area3w/(s/2)))*(Tinit_window3 - Too_air); %convection + coduction air->window3
    q3w_window1 = (kw*Area3w/s)*(Tinit_window3 - Too_window1);  %conduction window1->3

    volume_window = Area3w*s; a_window = volume_window*density_glass*heat_capacity_window;
    Tfin_window3 = Tinit_window3 - (q3w_air + q3w_window1)*t/(a_window+corrector);
    room(i,j,f).temper_window3(v) = Tfin_window3; %final temperature of the half window        
end

%wall4
if hotel_matrix(i+1,j,f) > 0
    Area4 = room(i,j,f).wall4(1)*room(i,j,f).wall4(2) - room(i,j,f).wall4(6); s = room(i,j,f).wall4(3)/2; %Area to heat ; half thickness to heat (wall)
    Tinit_wall4 = room_temp(i,j,f).temper_wall4(steps); Too_air = room_temp(i,j,f).temperature(steps); Too_wall2 = room_temp(i+1,j,f).temper_wall2(steps);
    q4_air = ((h*Area4)+(k*Area4/(s/2)))*(Tinit_wall4 - Too_air); %convection + coduction air->wall4
    q4_wall2 = (k*Area4/s)*(Tinit_wall4 - Too_wall2);  %conduction wall2->4
    
    %solar radiation
    if room(i,j,f).wall4(7) == 1
        q4_sun = solar_rad_norm(steps)*Area4*t;    
    elseif room(i,j,f).wall4(7) == 2
        q4_sun = solar_rad_normW(steps)*Area4*t;
    elseif room(i,j,f).wall4(7) == 4
        q4_sun = solar_rad_normE(steps)*Area4*t;
    else
        q4_sun = 0;
    end
    
    volume_wall = Area4*s; a_wall = volume_wall*density_wall*heat_capacity_wall;
    Tfin_wall4 = Tinit_wall4 - (q4_air + q4_wall2 - q4_sun)*t/a_wall;
    room(i,j,f).temper_wall4(v) = Tfin_wall4; %final temperature af the half wall
    
    %window4
    Area4w = room(i,j,f).wall4(6); s = Wthick/2; %Area to heat ; half thickness to heat (window)
    Tinit_window4 = room_temp(i,j,f).temper_window4(steps); Too_air = room_temp(i,j,f).temperature(steps); Too_window2 = room_temp(i+1,j,f).temper_window2(steps);
    q4w_air = ((h*Area4w)+(kw*Area4w/(s/2)))*(Tinit_window4 - Too_air); %convection + coduction air->window4
    q4w_window2 = (kw*Area4w/s)*(Tinit_window4 - Too_window2);  %conduction window1->3

    volume_window = Area4w*s; a_window = volume_window*density_glass*heat_capacity_window;
    Tfin_window4 = Tinit_window4 - (q4w_air + q4w_window2)*t/(a_window+corrector);
    room(i,j,f).temper_window4(v) = Tfin_window4; %final temperature of the half window    
end

%wall5
if hotel_matrix(i,j,f-1) > 0
    Area5 = room(i,j,f).wall5(1)*room(i,j,f).wall5(2) - room(i,j,f).wall5(6); s = room(i,j,f).wall5(3)/2; %Area to heat ; half thickness to heat (wall)
    Tinit_wall5 = room_temp(i,j,f).temper_wall5(steps); Too_air = room_temp(i,j,f).temperature(steps); Too_wall6 = room_temp(i,j,f-1).temper_wall6(steps);
    q5_air = ((h*Area5)+(k*Area5/(s/2)))*(Tinit_wall5 - Too_air); %convection + coduction air->wall5
    q5_wall6 = (k*Area5/s)*(Tinit_wall5 - Too_wall6);  %conduction wall6->5
    
    %solar radiation
    if room(i,j,f).wall5(7) == 1
        q5_sun = solar_rad_norm(steps)*Area5*t;    
    elseif room(i,j,f).wall5(7) == 2
        q5_sun = solar_rad_normW(steps)*Area5*t;
    elseif room(i,j,f).wall5(7) == 4
        q5_sun = solar_rad_normE(steps)*Area5*t;
    else
        q5_sun = 0;
    end

    volume_wall = Area5*s; a_wall = volume_wall*density_wall*heat_capacity_wall;
    Tfin_wall5 = Tinit_wall5 - (q5_air + q5_wall6 - q5_sun)*t/a_wall;
    room(i,j,f).temper_wall5(v) = Tfin_wall5; %final temperature af the half wall
end

%wall6 (useless)
% if hotel_matrix(i,j,f+1) > 0
%     Area6 = room(i,j,f).wall6(1)*room(i,j,f).wall6(2) - room(i,j,f).wall6(6); s = room(i,j,f).wall6(3)/2; %Area to heat ; half thickness to heat (wall)
%     Tinit_wall6 = room(i,j,f).temper_wall6(v-1); Too_air = room(i,j,f).temperature(v-1); Too_wall5 = room(i,j,f+1).temper_wall5(v-1);
%     q6_air = ((h*Area6)+(k*Area6/(s/2)))*(Tinit_wall6 - Too_air); %convection + coduction air->wall6
%     q6_wall5 = (k*Area6/s)*(Tinit_wall6 - Too_wall5);  %conduction wall5->6
% 
%     volume_wall = Area6*s; a_wall = volume_wall*density_wall*heat_capacity_wall;
%     Tfin_wall6 = Tinit_wall6 - (q6_air + q6_wall5)*t/a_wall;
%     room(i,j,f).temper_wall6(v) = Tfin_wall6; %final temperature af the half wall
% end


%Cuz the exterior air temperature is fixed I do not hve to modify it step by step

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


%to check the inner room temperature
%if i == 3 && j == 5 && f == 3
%fprintf('%f\t %f\t %f\t %f\t %f\n',f,i,j,v,room(i,j,f).temperature(v)-C2K);
%pause(0.1);
%end





