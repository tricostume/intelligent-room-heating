%The first two whiles are not relevant for the structure, they are just
%used to cover some vacances of the code. Cuz of this I decided to not
%'tab' the code in the middle of the cycle.

%flag_sun = 0 means there is no importance for the solar flux
%flag_sun = 1 South; flag_sun = 2 West; %flag_sun = 3 North; %flag_sun = 4East; 
%For the floor the exposition is equal to the North, while for the roof it is equal to the South

global i j floor f;

Lcorrid = (roomONlivingroom-1)*A2; %corridor room size based on A2

pid = 0;
while pid <= 1
k = 1;
while k <= 2
counter_other = 0;
counter2 = 0;
counter3 = 0;
counter4 = 0;

% I scan each layer of room from the lower to the upper one

%Hotel drawing
f = floor;
for i = 1 : cells
    for j = 1 : cells
        
        %corridors and living room
        if hotel_matrix(i,j,f) > 0 && hotel_matrix(i,j,f) < 2
            counter_other = counter_other + 1;
            flag_sun = 0; %there are no important windows
            
            room(i,j,f).id = hotel_matrix (i,j,f); %room_temp(i,j,f).id = room(i,j,f).id;
            %room(i,j,f).num 23005 = room: floor 2; type 3; number 005. If the code is negative it means it represents the ground
            room(i,j,f).num = counter_other + selector/10 + (f*selector); %room_temp(i,j,f).num = room(i,j,f).num;
            room(i,j,f).temperature = zeros(1,steps);       %room_temp(i,j,f).temperature = 0;  %inside room
            room(i,j,f).temper_wall1 = zeros(1,steps);  room(i,j,f).temper_window1 = zeros(1,steps);        %room_temp(i,j,f).temper_wall1 = 0;  %room_temp(i,j,f).temper_window1 = 0; %wall at 9 %corridor has a stable temperature!
            room(i,j,f).temper_wall2 = zeros(1,steps);  room(i,j,f).temper_window2 = zeros(1,steps);        %room_temp(i,j,f).temper_wall2 = 0;  %room_temp(i,j,f).temper_window2 = 0;  %wall at 12 %required by the calculations (not usefull)
            room(i,j,f).temper_wall3 = zeros(1,steps);  room(i,j,f).temper_window3 = zeros(1,steps);        %room_temp(i,j,f).temper_wall3 = 0;  %room_temp(i,j,f).temper_window3 = 0;  %wall at 3
            room(i,j,f).temper_wall4 = zeros(1,steps);  room(i,j,f).temper_window4 = zeros(1,steps);        %room_temp(i,j,f).temper_wall4 = 0;  %room_temp(i,j,f).temper_window4 = 0;  %wall at 6
            room(i,j,f).temper_wall5 = zeros(1,steps);                                                      %room_temp(i,j,f).temper_wall5 = 0;  %wall at floor
            room(i,j,f).temper_wall6 = zeros(1,steps);                                                      %room_temp(i,j,f).temper_wall6 = 0;  %wall at roof
            
            
            %wall1
            if hotel_matrix (i,j-1,f) ~= 0
                lenght = room(i,j-1,f).wall3(1); thickness = S1; room_wall = room(i,j-1,f).num; area_window = 0; 
                room(i,j,f).wall1 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall1 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            else
                lenght = Lcorrid ; thickness = S2; room_wall = 0+room(i,j-1,f).num; area_window = lenght*height*(window_proportion^2);
                room(i,j,f).wall1 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall1 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall2
            if hotel_matrix (i-1,j,f) ~= 0
                lenght = room(i-1,j,f).wall4(1); thickness = S1; room_wall = room(i-1,j,f).num; area_window = 0;
                room(i,j,f).wall2 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall2 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            else
                lenght = Lcorrid ; thickness = S2; room_wall = 0+room(i-1,j,f).num; area_window = lenght*height*(window_proportion^2);
                room(i,j,f).wall2 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall2 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall3
            if hotel_matrix (i,j+1,f) ~= 0
                lenght = room(i,j,f).wall1(1); thickness = S1; room_wall = room(i,j+1,f).num; area_window = 0;
                room(i,j,f).wall3 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall3 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            else
                lenght = Lcorrid ; thickness = S2; room_wall = 0+room(i,j+1,f).num; area_window = lenght*height*(window_proportion^2);
                room(i,j,f).wall3 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall3 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall4
            if hotel_matrix (i+1,j,f) ~= 0
                lenght = room(i,j,f).wall2(1); thickness = S1; room_wall = room(i+1,j,f).num; area_window = 0;
                room(i,j,f).wall4 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall4 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            else
                lenght = Lcorrid ; thickness = S2; room_wall = 0+room(i+1,j,f).num; area_window = lenght*height*(window_proportion^2);
                room(i,j,f).wall4 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall4 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall5
            if f > 1 
                if hotel_matrix (i,j,f-1) ~= -1
                    thickness = S1;
                else
                    thickness = S2;
                end
                lenght1 = room(i,j,f).wall1(1); lenght2 = room(i,j,f).wall2(1); room_wall = 0 + room(i,j,f-1).num; area_window = 0;
                room(i,j,f).wall5 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall5 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall6
            if f < n_floors 
                if hotel_matrix (i,j,f+1) ~= 0
                    thickness = S1;
                else
                    thickness = S2;
                end
                lenght1 = room(i,j,f).wall1(1); lenght2 = room(i,j,f).wall2(1); room_wall = 0 + room(i,j,f+1).num; area_window = 0;
                room(i,j,f).wall6 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall6 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
        end
        
        
        %first_type
        if hotel_matrix (i,j,f) == 2
            counter2 = counter2 + 1;
            
            room(i,j,f).id = hotel_matrix (i,j,f); %room_temp(i,j,f).id = room(i,j,f).id;
            %room(i,j,f).num 23005 = room: floor 2; type 3; number 005.
            room(i,j,f).num = counter2 + 2*selector/10 + (f*selector); %room_temp(i,j,f).num = room(i,j,f).num;
            room(i,j,f).temperature = zeros(1,steps);       %room_temp(i,j,f).temperature = 0;  %inside room
            room(i,j,f).temper_wall1 = zeros(1,steps);  room(i,j,f).temper_window1 = zeros(1,steps);        %room_temp(i,j,f).temper_wall1 = 0;  %room_temp(i,j,f).temper_window1 = 0; %wall at 9 %corridor has a stable temperature!
            room(i,j,f).temper_wall2 = zeros(1,steps);  room(i,j,f).temper_window2 = zeros(1,steps);        %room_temp(i,j,f).temper_wall2 = 0;  %room_temp(i,j,f).temper_window2 = 0;  %wall at 12 %required by the calculations (not usefull)
            room(i,j,f).temper_wall3 = zeros(1,steps);  room(i,j,f).temper_window3 = zeros(1,steps);        %room_temp(i,j,f).temper_wall3 = 0;  %room_temp(i,j,f).temper_window3 = 0;  %wall at 3
            room(i,j,f).temper_wall4 = zeros(1,steps);  room(i,j,f).temper_window4 = zeros(1,steps);        %room_temp(i,j,f).temper_wall4 = 0;  %room_temp(i,j,f).temper_window4 = 0;  %wall at 6
            room(i,j,f).temper_wall5 = zeros(1,steps);                                                      %room_temp(i,j,f).temper_wall5 = 0;  %wall at floor
            room(i,j,f).temper_wall6 = zeros(1,steps);                                                      %room_temp(i,j,f).temper_wall6 = 0;  %wall at roof
            room(i,j,f).book = zeros(1,steps);  %room_temp(i,j,f).book = 0;   %if someone is inthe room the flag is equal to 1, otherwise 0       
            room(i,j,f).extremeT = [0 0];  %room_temp(i,j,f).extremeT = room(i,j,f).extremeT;
            
            %wall1
            if hotel_matrix (i,j-1,f) ~= 0
                lenght = room(i,j-1,f).wall3(1); thickness = S1; room_wall = room(i,j-1,f).num; area_window = 0; flag_sun = 0;
                room(i,j,f).wall1 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall1 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            else
                lenght = A2 ; thickness = S2; room_wall = 0+room(i,j-1,f).num; area_window = lenght*height*(window_proportion^2);  flag_sun = 1;
                room(i,j,f).wall1 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall1 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall2
            if hotel_matrix (i-1,j,f) ~= 0
                lenght = room(i-1,j,f).wall4(1); thickness = S1; room_wall = room(i-1,j,f).num; area_window = 0; flag_sun = 0;
                room(i,j,f).wall2 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall2 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            else
                lenght = A2 ; thickness = S2; room_wall = 0+room(i-1,j,f).num; area_window = lenght*height*(window_proportion^2); flag_sun = 2;
                room(i,j,f).wall2 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall2 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall3
            if hotel_matrix (i,j+1,f) ~= 0
                lenght = room(i,j,f).wall1(1); thickness = S1; room_wall = room(i,j+1,f).num; area_window = 0; flag_sun = 0;
                room(i,j,f).wall3 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall3 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            else
                lenght = A2 ; thickness = S2; room_wall = 0+room(i,j+1,f).num; area_window = lenght*height*(window_proportion^2); flag_sun = 3;
                room(i,j,f).wall3 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall3 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall4
            if hotel_matrix (i+1,j,f) ~= 0
                lenght = room(i,j,f).wall2(1); thickness = S1; room_wall = room(i+1,j,f).num; area_window = 0; flag_sun = 0;
                room(i,j,f).wall4 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall4 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            else
                lenght = A2 ; thickness = S2; room_wall = 0+room(i+1,j,f).num; area_window = lenght*height*(window_proportion^2);  flag_sun = 4;
                room(i,j,f).wall4 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall4 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall5
            if f > 1 
                if hotel_matrix (i,j,f-1) ~= -1
                    thickness = S1;
                else
                    thickness = S2;
                end
                lenght1 = room(i,j,f).wall1(1); lenght2 = room(i,j,f).wall2(1); room_wall = 0 + room(i,j,f-1).num; area_window = 0;  flag_sun = 0;
                room(i,j,f).wall5 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall5 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall6
            if f < n_floors 
                if hotel_matrix (i,j,f+1) ~= 0
                    thickness = S1;
                else
                    thickness = S2;
                end
                lenght1 = room(i,j,f).wall1(1); lenght2 = room(i,j,f).wall2(1); room_wall = 0 + room(i,j,f+1).num; area_window = 0;  flag_sun = 1;
                room(i,j,f).wall6 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall6 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
        end
        
        
        %second_type
        if hotel_matrix (i,j,f) == 3
            counter3 = counter3 + 1;
            
            room(i,j,f).id = hotel_matrix (i,j,f); %room_temp(i,j,f).id = room(i,j,f).id;
            %room(i,j,f).num 23005 = room: floor 2; type 3; number 005.
            room(i,j,f).num = counter3 + 3*selector/10 + (f*selector); %room_temp(i,j,f).num = room(i,j,f).num;
            room(i,j,f).temperature = zeros(1,steps);       %room_temp(i,j,f).temperature = 0;  %inside room
            room(i,j,f).temper_wall1 = zeros(1,steps);  room(i,j,f).temper_window1 = zeros(1,steps);        %room_temp(i,j,f).temper_wall1 = 0;  %room_temp(i,j,f).temper_window1 = 0; %wall at 9 %corridor has a stable temperature!
            room(i,j,f).temper_wall2 = zeros(1,steps);  room(i,j,f).temper_window2 = zeros(1,steps);        %room_temp(i,j,f).temper_wall2 = 0;  %room_temp(i,j,f).temper_window2 = 0;  %wall at 12 %required by the calculations (not usefull)
            room(i,j,f).temper_wall3 = zeros(1,steps);  room(i,j,f).temper_window3 = zeros(1,steps);        %room_temp(i,j,f).temper_wall3 = 0;  %room_temp(i,j,f).temper_window3 = 0;  %wall at 3
            room(i,j,f).temper_wall4 = zeros(1,steps);  room(i,j,f).temper_window4 = zeros(1,steps);        %room_temp(i,j,f).temper_wall4 = 0;  %room_temp(i,j,f).temper_window4 = 0;  %wall at 6
            room(i,j,f).temper_wall5 = zeros(1,steps);                                                      %room_temp(i,j,f).temper_wall5 = 0;  %wall at floor
            room(i,j,f).temper_wall6 = zeros(1,steps);                                                      %room_temp(i,j,f).temper_wall6 = 0;  %wall at roof
            room(i,j,f).book = zeros(1,steps);  %room_temp(i,j,f).book = 0;   %if someone is inthe room the flag is equal to 1, otherwise 0       
            room(i,j,f).extremeT = [0 0];  %room_temp(i,j,f).extremeT = room(i,j,f).extremeT;
            
            %wall1
            if hotel_matrix (i,j-1,f) ~= 0
                lenght = room(i,j-1,f).wall3(1); thickness = S1; room_wall = room(i,j-1,f).num; area_window = 0; flag_sun = 0;
                room(i,j,f).wall1 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall1 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            else
                lenght = A3 ; thickness = S2; room_wall = 0+room(i,j-1,f).num; area_window = lenght*height*(window_proportion^2);  flag_sun = 1;
                room(i,j,f).wall1 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall1 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall2
            if hotel_matrix (i-1,j,f) ~= 0
                lenght = room(i-1,j,f).wall4(1); thickness = S1; room_wall = room(i-1,j,f).num; area_window = 0; flag_sun = 0;
                room(i,j,f).wall2 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall2 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            else
                lenght = A2 ; thickness = S2; room_wall = 0+room(i-1,j,f).num; area_window = lenght*height*(window_proportion^2); flag_sun = 2;
                room(i,j,f).wall2 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall2 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall3
            if hotel_matrix (i,j+1,f) ~= 0
                lenght = room(i,j,f).wall1(1); thickness = S1; room_wall = room(i,j+1,f).num; area_window = 0; flag_sun = 0;
                room(i,j,f).wall3 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall3 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            else
                lenght = A3 ; thickness = S2; room_wall = 0+room(i,j+1,f).num; area_window = lenght*height*(window_proportion^2); flag_sun = 3;
                room(i,j,f).wall3 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall3 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall4
            if hotel_matrix (i+1,j,f) ~= 0
                lenght = room(i,j,f).wall2(1); thickness = S1; room_wall = room(i+1,j,f).num; area_window = 0; flag_sun = 0;
                room(i,j,f).wall4 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall4 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            else
                lenght = A2 ; thickness = S2; room_wall = 0+room(i+1,j,f).num; area_window = lenght*height*(window_proportion^2);  flag_sun = 4;
                room(i,j,f).wall4 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall4 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall5
            if f > 1 
                if hotel_matrix (i,j,f-1) ~= -1
                    thickness = S1;
                else
                    thickness = S2;
                end
                lenght1 = room(i,j,f).wall1(1); lenght2 = room(i,j,f).wall2(1); room_wall = 0 + room(i,j,f-1).num; area_window = 0;  flag_sun = 0;
                room(i,j,f).wall5 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall5 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall6
            if f < n_floors 
                if hotel_matrix (i,j,f+1) ~= 0
                    thickness = S1;
                else
                    thickness = S2;
                end
                lenght1 = room(i,j,f).wall1(1); lenght2 = room(i,j,f).wall2(1); room_wall = 0 + room(i,j,f+1).num; area_window = 0;  flag_sun = 1;
                room(i,j,f).wall6 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall6 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
        end
                
        
        %third_type
        if hotel_matrix (i,j,f) == 4
            counter4 = counter4 + 1;
            
            room(i,j,f).id = hotel_matrix (i,j,f); %room_temp(i,j,f).id = room(i,j,f).id;
            %room(i,j,f).num 23005 = room: floor 2; type 3; number 005.
            room(i,j,f).num = counter4 + 4*selector/10 + (f*selector); %room_temp(i,j,f).num = room(i,j,f).num;
            room(i,j,f).temperature = zeros(1,steps);       %room_temp(i,j,f).temperature = 0;  %inside room
            room(i,j,f).temper_wall1 = zeros(1,steps);  room(i,j,f).temper_window1 = zeros(1,steps);        %room_temp(i,j,f).temper_wall1 = 0;  %room_temp(i,j,f).temper_window1 = 0; %wall at 9 %corridor has a stable temperature!
            room(i,j,f).temper_wall2 = zeros(1,steps);  room(i,j,f).temper_window2 = zeros(1,steps);        %room_temp(i,j,f).temper_wall2 = 0;  %room_temp(i,j,f).temper_window2 = 0;  %wall at 12 %required by the calculations (not usefull)
            room(i,j,f).temper_wall3 = zeros(1,steps);  room(i,j,f).temper_window3 = zeros(1,steps);        %room_temp(i,j,f).temper_wall3 = 0;  %room_temp(i,j,f).temper_window3 = 0;  %wall at 3
            room(i,j,f).temper_wall4 = zeros(1,steps);  room(i,j,f).temper_window4 = zeros(1,steps);        %room_temp(i,j,f).temper_wall4 = 0;  %room_temp(i,j,f).temper_window4 = 0;  %wall at 6
            room(i,j,f).temper_wall5 = zeros(1,steps);                                                      %room_temp(i,j,f).temper_wall5 = 0;  %wall at floor
            room(i,j,f).temper_wall6 = zeros(1,steps);                                                      %room_temp(i,j,f).temper_wall6 = 0;  %wall at roof
            room(i,j,f).book = zeros(1,steps);  %room_temp(i,j,f).book = 0;   %if someone is inthe room the flag is equal to 1, otherwise 0       
            room(i,j,f).extremeT = [0 0];  %room_temp(i,j,f).extremeT = room(i,j,f).extremeT;
            
            %wall1
            if hotel_matrix (i,j-1,f) ~= 0
                lenght = room(i,j-1,f).wall3(1); thickness = S1; room_wall = room(i,j-1,f).num; area_window = 0; flag_sun = 0;
                room(i,j,f).wall1 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall1 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            else
                lenght = A4 ; thickness = S2; room_wall = 0+room(i,j-1,f).num; area_window = lenght*height*(window_proportion^2);  flag_sun = 1;
                room(i,j,f).wall1 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall1 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall2
            if hotel_matrix (i-1,j,f) ~= 0
                lenght = room(i-1,j,f).wall4(1); thickness = S1; room_wall = room(i-1,j,f).num; area_window = 0; flag_sun = 0;
                room(i,j,f).wall2 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall2 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            else
                lenght = A2 ; thickness = S2; room_wall = 0+room(i-1,j,f).num; area_window = lenght*height*(window_proportion^2); flag_sun = 2;
                room(i,j,f).wall2 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall2 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall3
            if hotel_matrix (i,j+1,f) ~= 0
                lenght = room(i,j,f).wall1(1); thickness = S1; room_wall = room(i,j+1,f).num; area_window = 0; flag_sun = 0;
                room(i,j,f).wall3 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall3 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            else
                lenght = A4 ; thickness = S2; room_wall = 0+room(i,j+1,f).num; area_window = lenght*height*(window_proportion^2); flag_sun = 3;
                room(i,j,f).wall3 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall3 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall4
            if hotel_matrix (i+1,j,f) ~= 0
                lenght = room(i,j,f).wall2(1); thickness = S1; room_wall = room(i+1,j,f).num; area_window = 0; flag_sun = 0;
                room(i,j,f).wall4 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall4 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            else
                lenght = A2 ; thickness = S2; room_wall = 0+room(i+1,j,f).num; area_window = lenght*height*(window_proportion^2);  flag_sun = 4;
                room(i,j,f).wall4 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall4 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall5
            if f > 1 
                if hotel_matrix (i,j,f-1) ~= -1
                    thickness = S1;
                else
                    thickness = S2;
                end
                lenght1 = room(i,j,f).wall1(1); lenght2 = room(i,j,f).wall2(1); room_wall = 0 + room(i,j,f-1).num; area_window = 0;  flag_sun = 0;
                room(i,j,f).wall5 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall5 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall6
            if f < n_floors 
                if hotel_matrix (i,j,f+1) ~= 0
                    thickness = S1;
                else
                    thickness = S2;
                end
                lenght1 = room(i,j,f).wall1(1); lenght2 = room(i,j,f).wall2(1); room_wall = 0 + room(i,j,f+1).num; area_window = 0;  flag_sun = 1;
                room(i,j,f).wall6 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,f).wall6 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
        end
                
    end
end
k = k+1;
end
clear k;

if pid == 0
counter0ext = 0;
counterGround = 0;
for i = 2 : cells-1
    for j = 2 : cells-1

        %exterior
        if hotel_matrix (i,j,f) == 0 && f > 1
            
            if hotel_matrix(i,j-1,f) + hotel_matrix(i-1,j,f) + hotel_matrix(i,j+1,f) + hotel_matrix(i+1,j,f) + hotel_matrix(i,j,f-1) > 0
                counter0ext = counter0ext + 1;

                room(i,j,f).id = hotel_matrix (i,j,f);   %room_temp(i,j,f).id = room(i,j,f).id;
                room(i,j,f).num = counter0ext + (f*selector);   %room_temp(i,j,f).num = room(i,j,f).num;
                room(i,j,f).temperature = zeros(1,steps);   %room_temp(i,j,f).temperature = 0;
                room(i,j,f).temper_wall1 = zeros(1,steps);  room(i,j,f).temper_window1 = zeros(1,steps);        %room_temp(i,j,f).temper_wall1 = 0;  %room_temp(i,j,f).temper_window1 = 0; %wall at 9 %corridor has a stable temperature!
                room(i,j,f).temper_wall2 = zeros(1,steps);  room(i,j,f).temper_window2 = zeros(1,steps);        %room_temp(i,j,f).temper_wall2 = 0;  %room_temp(i,j,f).temper_window2 = 0;  %wall at 12 %required by the calculations (not usefull)
                room(i,j,f).temper_wall3 = zeros(1,steps);  room(i,j,f).temper_window3 = zeros(1,steps);        %room_temp(i,j,f).temper_wall3 = 0;  %room_temp(i,j,f).temper_window3 = 0;  %wall at 3
                room(i,j,f).temper_wall4 = zeros(1,steps);  room(i,j,f).temper_window4 = zeros(1,steps);        %room_temp(i,j,f).temper_wall4 = 0;  %room_temp(i,j,f).temper_window4 = 0;  %wall at 6
                room(i,j,f).temper_wall5 = zeros(1,steps);                                                      %room_temp(i,j,f).temper_wall5 = 0;  %wall at floor
                %room(i,j,f).temper_wall6 = zeros(1,steps);                                                      %room_temp(i,j,f).temper_wall6 = 0;  %wall at roof

                %wall1
                if hotel_matrix (i,j-1,f) ~= 0
                    lenght = room(i,j-1,f).wall3(1); thickness = S2; room_wall = room(i,j-1,f).num; area_window = lenght*height*(window_proportion^2); flag_sun = 3;
                    room(i,j,f).wall1 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                    %room_temp(i,j,f).wall1 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                end

                %wall2
                if hotel_matrix (i-1,j,f) ~= 0
                    lenght = room(i-1,j,f).wall4(1); thickness = S2; room_wall = room(i-1,j,f).num; area_window = lenght*height*(window_proportion^2); flag_sun = 4;
                    room(i,j,f).wall2 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                    %room_temp(i,j,f).wall2 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                end

                %wall3
                if hotel_matrix (i,j+1,f) ~= 0
                    lenght = room(i,j+1,f).wall1(1); thickness = S2; room_wall = room(i,j+1,f).num; area_window = lenght*height*(window_proportion^2); flag_sun = 1;
                    room(i,j,f).wall3 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                    %room_temp(i,j,f).wall3 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                end

                %wall4
                if hotel_matrix (i+1,j,f) ~= 0
                    lenght = room(i+1,j,f).wall2(1); thickness = S2; room_wall = room(i+1,j,f).num; area_window = lenght*height*(window_proportion^2); flag_sun = 2;
                    room(i,j,f).wall4 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                    %room_temp(i,j,f).wall4 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
                end
            
                %wall5
                if f > 1 && hotel_matrix (i,j,f-1) > 0
                    lenght1 = room(i,j,f-1).wall1(1); lenght2 = room(i,j,f-1).wall2(1); thickness = S2; room_wall = 0 + room(i,j,f-1).num; area_window = 0; flag_sun = 0;
                    room(i,j,f).wall5 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
                    %room_temp(i,j,f).wall5 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
                end

                %wall6 (useless)
                if f < n_floors && hotel_matrix (i,j,f+1) > 0
                    lenght1 = room(i,j,f+1).wall1(1); lenght2 = room(i,j,f+1).wall2(1); thickness = S2; room_wall = 0 + room(i,j,f+1).num; area_window = 0; flag_sun = 1;
                    room(i,j,f).wall6 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
                    %room_temp(i,j,f).wall6 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
                end
            end
            
        end
        
        %ground layer //In order to make it work I scan the layers of rooms from the upper floor to the lower one
        temp = n_floors+1 - f;
        if hotel_matrix (i,j,temp) == -1
            
            counterGround = counterGround + 1;
            n_ground_cell = counterGround; %test 
            
            room(i,j,temp).id = hotel_matrix (i,j,temp);    %room_temp(i,j,temp).id = room(i,j,temp).id;
            room(i,j,temp).num = -(counterGround + (temp*selector));    %room_temp(i,j,temp).num = room(i,j,temp).num;
            %room(i,j,temp).temperature = zeros(1,steps);
            %room(i,j,temp).temper_wall1 = zeros(1,steps);   %room(i,j,temp).temper_window1 = zeros(1,steps); %wall at 9
            %room(i,j,temp).temper_wall2 = zeros(1,steps);   %room(i,j,temp).temper_window2 = zeros(1,steps); %wall at 12
            %room(i,j,temp).temper_wall3 = zeros(1,steps);   %room(i,j,temp).temper_window3 = zeros(1,steps); %wall at 3
            %room(i,j,temp).temper_wall4 = zeros(1,steps);   %room(i,j,temp).temper_window4 = zeros(1,steps); %wall at 6
            %room(i,j,temp).temper_wall5 = zeros(1,steps);   %room(i,j,temp).temper_window5 = zeros(1,steps); %wall at floor
            room(i,j,temp).temper_wall6 = zeros(1,steps);    %room_temp(i,j,temp).temper_wall6 = 0;  %room(i,j,temp).temper_window6 = zeros(1,steps); %wall at roof
             
             %wall1 (useless)
             if hotel_matrix (i,j-1,temp) ~= 0 && hotel_matrix (i,j-1,temp) ~= -1
                 lenght = room(i,j-1,temp).wall3(1); thickness = S2; room_wall = room(i,j-1,temp).num; area_window = 0; flag_sun = 0; 
                 room(i,j,temp).wall1 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
             end
 
             %wall2 (useless)
             if hotel_matrix (i-1,j,temp) ~= 0 && hotel_matrix (i-1,j,temp) ~= -1
                 lenght = room(i-1,j,temp).wall4(1); thickness = S2; room_wall = room(i-1,j,temp).num; area_window = 0; flag_sun = 0;
                 room(i,j,temp).wall2 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
             end
 
             %wall3 (useless)
             if hotel_matrix (i,j+1,temp) ~= 0 && hotel_matrix (i,j+1,temp) ~= -1
                 lenght = room(i,j+1,temp).wall1(1); thickness = S2; room_wall = room(i,j+1,temp).num; area_window = 0; flag_sun = 0;
                 room(i,j,temp).wall3 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
             end
 
             %wall4 (useless)
             if hotel_matrix (i+1,j,temp) ~= 0 && hotel_matrix (i+1,j,temp) ~= -1
                 lenght = room(i+1,j,temp).wall2(1); thickness = S2; room_wall = room(i+1,j,temp).num; area_window = 0; flag_sun = 0;
                 room(i,j,temp).wall4 = [lenght; height; thickness; room_wall; init_temperature; area_window; flag_sun];
             end
          
            %wall5 (useless)
             if temp > 1 && hotel_matrix (i,j,temp-1) ~= 0
                lenght1 = room(i,j,temp-1).wall1(1); lenght2 = room(i,j,temp-1).wall2(1); thickness = S2; room_wall = 0 + room(i,j,temp-1).num; area_window = 0; flag_sun = 0;
                room(i,j,temp).wall5 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
            
            %wall6
            if temp < n_floors && hotel_matrix (i,j,temp+1) ~= 0
                lenght1 = room(i,j,temp+1).wall1(1); lenght2 = room(i,j,temp+1).wall2(1); thickness = S2; room_wall = 0 + room(i,j,temp+1).num; area_window = 0; flag_sun = 0;
                room(i,j,temp).wall6 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
                %room_temp(i,j,temp).wall6 = [lenght1; lenght2; thickness; room_wall; init_temperature; area_window; flag_sun];
            end
        end
    end
end
end
pid = pid + 1;
end
clear pid;

% n_room2 = n_room2 + counter2;
% n_room3 = n_room3 + counter3;
% n_room4 = n_room4 + counter4;
