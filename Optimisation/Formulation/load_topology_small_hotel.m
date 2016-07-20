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
'K5_e_';'K6_e_';'K7_e_';'K8_e_';'K9_e_';'K10_e_';'K11_e_';'K0_2_';...
'K1_3_'; 'K2_4_'; 'K3_5_'; 'K4_6_'; 'K5_7_'; 'K6_9_'; 'K7_8_'; 'K8_11_';...
'K9_10_';'K10_11_';'K0_11_';'K1_11_';'K2_11_';'K3_11_';'K4_11_';'K5_11_';...
'K6_11_';'K7_11_';'K9_11_';'Ku_0_';'Ku_1_';'Ku_2_';'Ku_3_';'Ku_4_';...
'Ku_5_';'Ku_6_';'Ku_7_';'Ku_8_';'Ku_9_';'Ku_10_';'Ku_11_'};
load('P_init_overall.mat'); % Load numerical values of K
hotel.parameters.K.values = P0(1:size(hotel.parameters.K.names,1));

hotel.parameters.c.names = {'c_0_';'c_1_';'c_2_';'c_3_';'c_4_';'c_5_';'c_6_';...
'c_7_';'c_8_';'c_9_';'c_10_';'c_11_'};
hotel.parameters.c.values = P0(57:68)/Ts;

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