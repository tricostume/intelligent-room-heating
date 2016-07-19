global i j f

%Saving parameter useful for the identification
room_var(i,j,f).temperature(real_step_var) = Tfin_air -C2K;

%if it is positive increases the temperature, otherwise decreases it
room_var(i,j,f).wall_HC_flux(real_step_var) = -(qTOT_wall_air + qTOT_window_air + qTOT_vent -(qH + qC)); 

%flux of sun through windows
room_var(i,j,f).solar_flux(real_step_var) = qTOT_sun; 

%'0' nothing; 1 costumer in; 2 custumer in + heating; 3 customer in + cooling
if qH ~= 0
    room_var(i,j,f).activation(real_step_var) = 2;
elseif qC ~= 0
    room_var(i,j,f).activation(real_step_var) = 3;
else
    room_var(i,j,f).activation(real_step_var) = room_var(i,j,f).activation(real_step_var) +0;
end


if i == 3 && j == 3 && f == 2  %ground 2
fprintf('grou %f\t %f\t %f\t %f\t %f\t %f\n',real_step,real_step_var,room_var(i,j,f).activation(real_step_var),room_var(i,j,f).temperature(real_step_var),room_var(i,j,f).wall_HC_flux(real_step_var),room_var(i,j,f).solar_flux(real_step_var));
end

if i == 9 && j == 10 && f == 3  %mid 3
fprintf('midd %f\t %f\t %f\t %f\t %f\t %f\n',real_step,real_step_var,room_var(i,j,f).activation(real_step_var),room_var(i,j,f).temperature(real_step_var),room_var(i,j,f).wall_HC_flux(real_step_var),room_var(i,j,f).solar_flux(real_step_var));
end

if i == 7 && j == 3 && f == 4  %roof 4
fprintf('roof %f\t %f\t %f\t %f\t %f\t %f\n',real_step,real_step_var,room_var(i,j,f).activation(real_step_var),room_var(i,j,f).temperature(real_step_var),room_var(i,j,f).wall_HC_flux(real_step_var),room_var(i,j,f).solar_flux(real_step_var));
end





