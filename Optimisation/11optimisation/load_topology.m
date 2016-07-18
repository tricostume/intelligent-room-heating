%--------------------Università degli Studi di Genova----------------------
%_________________________________EMARO+___________________________________
%Title: Hotel topology
%Period of preparation: 
%Authors: Ernesto Denicia, Emmanuele Vestito, Rocco Caravelli
%Script: Loading the hotel topology, this including the next information:
% Parameters: Capacitances and transmittance coefficients of each wall.
% Exogenous inputs: Solar radiation
% Room adjacencies: E.g. Room 1 is adjacent to rooms 2,3,4.
% Controls for the room
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

hotel.nt = 12; %Total number of rooms
hotel.ns = 2; % Number of service rooms (not client rooms)
hotel.nc = 10; % Number of client rooms

%% Parameterisation of the hotel
hotel.parameters.K.names = {'K0_e_';'K1_e_';'K2_e_';'K3_e_';'K4_e_';...
'K5_e_';'K6_e_';'K7_e_';'K8_e_';'K9_e_';'K10_e_';'K11_e_';'K_0_2';...
'K_1_3'; 'K_2_4'; 'K_3_5'; 'K_4_6'; 'K_5_7'; 'K_6_9'; 'K_7_8'; 'K_8_11';...
'K_9_10';'K_10_11';'K_0_11';'K_1_11';'K_2_11';'K_3_11';'K_4_11';'K_5_11';...
'K_6_11';'K_7_11';'K_9_11';'K_u_0';'K_u_1';'K_u_2';'K_u_3';'K_u_4';...
'K_u_5';'K_u_6';'K_u_7';'K_u_8';'K_u_9';'K_u_10';'K_u_11';'K_uc_0';...
'K_uc_1';'K_uc_2';'K_uc_3';'K_uc_4';'K_uc_5';'K_uc_6';'K_uc_7';'K_uc_8';...
'K_uc_9';'K_uc_10';'K_uc_11'};
load('P_init_overall.mat'); % Load numerical values of K
hotel.parameters.K.values = P0(1:56);

hotel.parameters.c.names = {'c_0';'c_1';'c_2';'c_3';'c_4';'c_5';'c_6';...
'c_7';'c_8';'c_9';'c_10';'c_11'};
hotel.parameters.c.values = P0(57:68);

hotel.parameters.Ki.names = {'K_i'};
hotel.parameters.Ki.values = P0(69);
hotel.parameters.G.names = {'G'};
hotel.parameters.G.values = P0(70);

%% Interior adjacencies of the hotel
hotel.in_adj.rooms = (0:1:11)';
hotel.in_adj.values = ['2','11',cell(1,10);'3','11',cell(1,10); '0','4','11', cell(1,9); '1','5','11', cell(1,9) ; ...
    '2','6','11', cell(1,9);  '3','7','11', cell(1,9);  '4','9','11', cell(1,9);   '5','8','11' cell(1,9);...
    '7','11', cell(1,10); '6','10','11', cell(1,9); '9','11', cell(1,10); '0','1','2','3','4','5','6','7',...
    '8','9','10',cell(1,1)];
hotel.in_adj.mat = zeros(size(hotel.in_adj.values,1),size(hotel.in_adj.values,2));
for i=1:size(hotel.in_adj.values,1)
    for j = 1:size(hotel.in_adj.values,2)
        if ~isempty(hotel.in_adj.values{i,j})
            temp = str2double(char(hotel.in_adj.values(i,j)));
            hotel.in_adj.mat(i,temp+1) = 1;
        end
    end
end
%% Exterior adjacencies (having walls or windows to the exterior)
hotel.ext_adj.rooms = (0:1:11)';
hotel.ext_adj.mat = ones(12,1);