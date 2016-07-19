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


global i j f density_wall heat_capacity_wall thermal_condu density_air heat_capacity_air conv_coeff time_gap;
h = thermal_condu;
k = conv_coeff;
t = time_gap;


%conduction
%for a side of the wall there are two contributions:
%1) from the other side of the wall Conduction
%2) from the air of the room Convection

%wall1 (useless)
% if hotel_matrix(i,j-1,f) > 0 %room(i,j-1,f).num > 0 / would be the same 
%     %k*A+h*s
%     Area1 = room(i,j,f).wall1(1)*room(i,j,f).wall1(2); s = room(i,j,f).wall1(3); %Area to heat ; thickness to heat
%     sum_weights = k*Area1+h*s; %the sum of the weights according to heat transmission we consider
%     Text_gen = (k*Area1*room(i,j,f).temperature(v-1) + h*s*room(i,j-1,f).temper_wall3(v-1))/sum_weights; %temperature of the sourse/sink we consider
%     volume_wall = Area1*s; %volume to heat
%     room(i,j,f).temper_wall1(v) = Text_gen + (room(i,j,f).temper_wall1(v-1) - Text_gen)*exp((-t*sum_weights)/(density_wall*heat_capacity_wall*volume_wall)); %final temperature
% end

%wall2 (useless)
% if hotel_matrix(i-1,j,f) > 0
%     Area2 = room(i,j,f).wall2(1)*room(i,j,f).wall2(2); s = room(i,j,f).wall2(3); 
%     sum_weights = k*Area2+h*s;
%     Text_gen = (k*Area2*room(i,j,f).temperature(v-1) + h*s*room(i-1,j,f).temper_wall4(v-1))/sum_weights;
%     volume_wall = Area2*s;
%     room(i,j,f).temper_wall2(v) = Text_gen + (room(i,j,f).temper_wall2(v-1) - Text_gen)*exp((-t*sum_weights)/(density_wall*heat_capacity_wall*volume_wall));
% end

%wall3 (useless)
% if hotel_matrix(i,j+1,f) > 0
%     Area3 = room(i,j,f).wall3(1)*room(i,j,f).wall3(2); s = room(i,j,f).wall3(3); 
%     sum_weights = k*Area3+h*s;
%     Text_gen = (k*Area3*room(i,j,f).temperature(v-1) + h*s*room(i,j+1,f).temper_wall1(v-1))/sum_weights;
%     volume_wall = Area3*s;
%     room(i,j,f).temper_wall3(v) = Text_gen + (room(i,j,f).temper_wall3(v-1) - Text_gen)*exp((-t*sum_weights)/(density_wall*heat_capacity_wall*volume_wall));
% end

%wall4 (useless)
% if hotel_matrix(i+1,j,f) > 0
%     Area4 = room(i,j,f).wall4(1)*room(i,j,f).wall4(2); s = room(i,j,f).wall4(3); 
%     sum_weights = k*Area4+h*s;
%     Text_gen = (k*Area4*room(i,j,f).temperature(v-1) + h*s*room(i+1,j,f).temper_wall2(v-1))/sum_weights;
%     volume_wall = Area4*s;
%     room(i,j,f).temper_wall4(v) = Text_gen + (room(i,j,f).temper_wall4(v-1) - Text_gen)*exp((-t*sum_weights)/(density_wall*heat_capacity_wall*volume_wall));
% end

%wall5 (udeless)
% if hotel_matrix(i+1,j,f-1) > 0
%     Area5 = room(i,j,f).wall5(1)*room(i,j,f).wall5(2); s = room(i,j,f).wall5(3); 
%     sum_weights = k*Area5+h*s;
%     Text_gen = (k*Area5*room(i,j,f).temperature(v-1) + h*s*room(i,j,f-1).temper_wall2(v-1))/sum_weights;
%     volume_wall = Area5*s;
%     room(i,j,f).temper_wall5(v) = Text_gen + (room(i,j,f).temper_wall5(v-1) - Text_gen)*exp((-t*sum_weights)/(density_wall*heat_capacity_wall*volume_wall));
% end

%wall6 ???
 if hotel_matrix(i,j,f+1) > 0
     Area6 = room(i,j,f).wall6(1)*room(i,j,f).wall6(2); s = room(i,j,f).wall6(3); 
     sum_weights = k*Area6+h*s;
     Text_gen = (k*Area6*room(i,j,f).temperature(v-1) + h*s*room(i,j,f+1).temper_wall2(v-1))/sum_weights;
     volume_wall = Area6*s;
     room(i,j,f).temper_wall6(v) = Text_gen + (room(i,j,f).temper_wall6(v-1) - Text_gen)*exp((-t*sum_weights)/(density_wall*heat_capacity_wall*volume_wall));
 end

%convection
%for the air of the room the are 6 contributes coming from the 6 walls.
%sum of the round ares
%sum_areas = Area1 + Area2 + Area3 + Area4 + Area5 + Area6;
%weightted outside temperature
%Text_gen_sides = (room(i,j,f).temper_wall1(v-1)*Area1 + room(i,j,f).temper_wall2(v-1)*Area2 + room(i,j,f).temper_wall3(v-1)*Area3 + room(i,j,f).temper_wall4(v-1)*Area4)/sum_areas;
%Text_gen_floorroof = (room(i,j,f).temper_wall5(v-1)*Area5 + room(i,j,f).temper_wall6(v-1)*Area6)/sum_areas;
%Text_gen = Text_gen_sides + Text_gen_floorroof;

%volume_room = room(i,j,f).wall1(1)*room(i,j,f).wall1(2)*room(i,j,f).wall2(1);

%final value of the room temperature
%room(i,j,f).temperature(v) = Text_gen + (room(i,j,f).temperature(v-1) - Text_gen)*exp((-t*sum_areas*k)/(density_air*heat_capacity_air*volume_room));

%to check the inner room temperature
%fprintf('%f\t %f\t %f\t %f\t %f\n',f,i,j,v,room(i,j,f).temperature(v)-C2K);





