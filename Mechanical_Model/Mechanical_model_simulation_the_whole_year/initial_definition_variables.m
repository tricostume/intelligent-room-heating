% Text = -5 + C2K;
% Text_ground = 0 + C2K;
% Tint_corr = 25 + C2K;
% Tint_living = Tint_corr; 
% Tint_badroom = 5 + C2K;
%(Taken from outside)


%Solar radiation and ground temperature definition
run solar_radiation

%External temperature for the whole year
load Textern
pid3 = Textern; 
hours = 365*24;
step_h = 60*60/time_gap;
for f = 1 : hours
    for i = 1 : step_h
        T0_out_all(i + (f-1)*step_h) = pid3(f) + C2K;
    end
end

for i = 1 : steps_day
    T0_out(i) = T0_out_all(i + (day-1)*steps_day);
end

clear pid3;

%exterior temperature
for f = 1 : n_floors    %f is the compact version of 'floor'
    for i = 1 : cells
       for j = 1 : cells

           if hotel_matrix(i,j,f) == -1   %ground
                %room(i,j,f).temperature = room(i,j,f).temperature + Text_ground;    % useless???
                %room(i,j,f).temper_wall1 = room(i,j,f).temper_wall1 + Text_ground;  % useless
                %room(i,j,f).temper_wall2 = room(i,j,f).temper_wall2 + Text_ground;  % useless 
                %room(i,j,f).temper_wall3 = room(i,j,f).temper_wall3 + Text_ground;  % useless 
                %room(i,j,f).temper_wall4 = room(i,j,f).temper_wall4 + Text_ground;  % useless
                %room(i,j,f).temper_wall5 = room(i,j,f).temper_wall5 + Text_ground;  % useless 
                for v = 1 : steps
                    room(i,j,f).temper_wall6(v) = Tground_temp(v);
                end
                
           elseif hotel_matrix(i,j,f) == 0
             if room(i,j,f).num > 0    %external area
                for v = 1 : steps 
                    room(i,j,f).temperature(v) = T0_out(v); 
                end
                clear v;
                if day == 1
                    room(i,j,f).temper_wall1 = room(i,j,f).temperature;   room(i,j,f).temper_window1 = room(i,j,f).temperature;
                    room(i,j,f).temper_wall2 = room(i,j,f).temperature;   room(i,j,f).temper_window2 = room(i,j,f).temperature;
                    room(i,j,f).temper_wall3 = room(i,j,f).temperature;   room(i,j,f).temper_window3 = room(i,j,f).temperature;
                    room(i,j,f).temper_wall4 = room(i,j,f).temperature;   room(i,j,f).temper_window4 = room(i,j,f).temperature;
                    room(i,j,f).temper_wall5 = room(i,j,f).temperature;   %room(i,j,f).temper_window5 = room(i,j,f).temperature;
                    %room(i,j,f).temper_wall6 = room(i,j,f).temperature;  room(i,j,f).temper_window6 = room(i,j,f).temperature(1); % useless
                end
             end
          elseif hotel_matrix(i,j,f) == 1   %corridors
              if day == 1
                    room(i,j,f).temperature = room(i,j,f).temperature + Tint_corr;      %cuz the windows on the corridor and the living room do not afeect rooms I am not condering them
                    room(i,j,f).temper_wall1 = room(i,j,f).temper_wall1 + Tint_corr;    room(i,j,f).temper_window1 = room(i,j,f).temper_window1 + Tint_corr;
                    room(i,j,f).temper_wall2 = room(i,j,f).temper_wall2 + Tint_corr;    room(i,j,f).temper_window2 = room(i,j,f).temper_window2 + Tint_corr;
                    room(i,j,f).temper_wall3 = room(i,j,f).temper_wall3 + Tint_corr;    room(i,j,f).temper_window3 = room(i,j,f).temper_window3 + Tint_corr;
                    room(i,j,f).temper_wall4 = room(i,j,f).temper_wall4 + Tint_corr;    room(i,j,f).temper_window4 = room(i,j,f).temper_window4 + Tint_corr;
                    room(i,j,f).temper_wall5 = room(i,j,f).temper_wall5 + Tint_corr;    %room(i,j,f).temper_window5 = room(i,j,f).temper_window5 + Tint_corr;
                    room(i,j,f).temper_wall6 = room(i,j,f).temper_wall6 + Tint_corr;    %room(i,j,f).temper_window6 = room(i,j,f).temper_window6 + Tint_corr;
                end
                
           elseif hotel_matrix(i,j,f) > 1 && hotel_matrix(i,j,f) < 2   %living rooms
                if day == 1 
                    room(i,j,f).temperature = room(i,j,f).temperature + Tint_living;     %cuz the windows on the corridor and the living room do not afeect rooms I am not condering them
                    room(i,j,f).temper_wall1 = room(i,j,f).temper_wall1 + Tint_living;  room(i,j,f).temper_window1 = room(i,j,f).temper_window1 + Tint_living;
                    room(i,j,f).temper_wall2 = room(i,j,f).temper_wall2 + Tint_living;  room(i,j,f).temper_window2 = room(i,j,f).temper_window2 + Tint_living;
                    room(i,j,f).temper_wall3 = room(i,j,f).temper_wall3 + Tint_living;  room(i,j,f).temper_window3 = room(i,j,f).temper_window3 + Tint_living;
                    room(i,j,f).temper_wall4 = room(i,j,f).temper_wall4 + Tint_living;  room(i,j,f).temper_window4 = room(i,j,f).temper_window4 + Tint_living;
                    room(i,j,f).temper_wall5 = room(i,j,f).temper_wall5 + Tint_living;  %room(i,j,f).temper_window5 = room(i,j,f).temper_window5 + Tint_living;
                    room(i,j,f).temper_wall6 = room(i,j,f).temper_wall6 + Tint_living;  %room(i,j,f).temper_window6 = room(i,j,f).temper_window6 + Tint_living;
                end
                
          else   %bed rooms
                if day == 1
                    room(i,j,f).temperature = room(i,j,f).temperature + Tint_badroom; 
                    room(i,j,f).temper_wall1 = room(i,j,f).temper_wall1 + Tint_badroom;   room(i,j,f).temper_window1 = room(i,j,f).temper_window1 + Tint_badroom;
                    room(i,j,f).temper_wall2 = room(i,j,f).temper_wall2 + Tint_badroom;   room(i,j,f).temper_window2 = room(i,j,f).temper_window2 + Tint_badroom;
                    room(i,j,f).temper_wall3 = room(i,j,f).temper_wall3 + Tint_badroom;   room(i,j,f).temper_window3 = room(i,j,f).temper_window3 + Tint_badroom;
                    room(i,j,f).temper_wall4 = room(i,j,f).temper_wall4 + Tint_badroom;   room(i,j,f).temper_window4 = room(i,j,f).temper_window4 + Tint_badroom;
                    room(i,j,f).temper_wall5 = room(i,j,f).temper_wall5 + Tint_badroom;   %room(i,j,f).temper_window5 = room(i,j,f).temper_window5 + Tint_badroom;
                    room(i,j,f).temper_wall6 = room(i,j,f).temper_wall6 + Tint_badroom;   %room(i,j,f).temper_window6 = room(i,j,f).temper_window6 + Tint_badroom;
                    room(i,j,f).book = room(i,j,f).book + 1; %all the rooms are always occupied
                    %s = 24*60*60/time_gap; room(i,j,f).book(1:s) = 0; clear s; %first day off
              
                    book_temp = zeros(1,365); %book generation
                    book_temp(1) = 0; 
                    for s = 2 : 365
                        book_temp(s) = round(rand()-0.1);
                    end
                    
                    %uncomment to check the progress day-on to day-on
                    %book_temp(2) = 0;
                    
                    for pid5 = 1 : 365
                        for pid4 = 1 : step_h*24
                            room(i,j,f).activation(pid4 + (pid5-1)*step_h*24) = book_temp(pid5);
                        end
                    end
                    for pid_book = 1 : 365*24*60*60/600
                       room_var(i,j,f).activation(pid_book) = room(i,j,f).activation(pid_book*600/time_gap);
                    end
                    clear pid_book
                    
                end
                
                for s = 1 : steps
                    room(i,j,f).book(s) = room(i,j,f).activation(s + (day-1)*steps);
                end
                clear book_temp s
                
            end
        end
    end
end