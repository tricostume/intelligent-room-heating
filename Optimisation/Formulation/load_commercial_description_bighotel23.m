%--------------------Università degli Studi di Genova----------------------
%_________________________________EMARO+___________________________________
%Title: Topology loader
%Period of preparation: 
%Authors: Ernesto Denicia, Emmanuele Vestito, Rocco Caravelli
%Script: Loading the topology (number of rooms and commercial description
%of each room following a predefined code as explained next):
%   a               b               c
% Class     |  No. People   |  Type of Bed
% 1. Normal   1, 2, 3, 4      1. Single
% 2. Suite                    2. Double
%                             3. King size
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Number of client rooms, service rooms and dummy rooms
load('demand_big_hotel_23\demand_big23_30_1.mat');
input_rooms = room_description_matrix;
clearvars -except hotel_count instance_number input_requests D general_compatibility...
           general_room_number general_room_types nd R input_rooms solutions_number...
            folder;
nc = size(input_rooms,1);
ns = 3;
nn = 1;
% Total number of rooms
nt = nc+ns+nn;
% Define set of client rooms R
for i = 0:nc-1
    temp = ['r' num2str(i) '_'];
    R = [R,temp];
end
