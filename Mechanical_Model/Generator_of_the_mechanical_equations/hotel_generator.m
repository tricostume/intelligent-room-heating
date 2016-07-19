clear all
n_floors = 3;
cells = 14;
hotel_matrix = zeros(cells);
%change values from 1 t 4 by hand
% 1 corresponds to corridors and other facility room

%%
save('hotel_line_2','hotel_matrix', 'cells', 'n_floors');