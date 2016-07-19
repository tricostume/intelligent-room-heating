global i j f
count_vert = 1;
count_horiz = 1;
gap_point = 0.001;
vertical_size_room = 5;

for f = 1 : n_floors
    if f > 1 && f < n_floors
        hold off;
        figure(f)
        hold on;
        for i = 1 : cells
            pid3 = 0;
            for j = 1 : cells
                if hotel_matrix(i,j,f) >= 1
                    pid3 = pid3 +1;
                    if pid3 == 1
                        temp_vert = room(i,j,f).wall1(1);
                        
%                     if hotel_matrix(i-1,j,f) == 0
%                         thicknessH2 = S2;
%                     else
%                         thicknessH2 = S1/2;
%                     end
%                     if hotel_matrix(i+1,j,f) == 0
%                         thicknessH4 = S2;
%                     else
%                         thicknessH4 = S1/2;
%                     end
                                        
                    %scatter(X,Y,S,C) X-Y (array) S (area_point) C (color)
                    for l = 1 : gap_point : thicknessH2
                        for h = 1 : gap_point : room(i,j,f).wall2(1)
                            scatter(count_vert+l, count_horiz+h)
                        end
                    end
                    count_vert = count_vert + vertical_size_room;
                    
                    




                end
            end
        end    
    end
end

clear count_vert count_horiz i j f h pid3