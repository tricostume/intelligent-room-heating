% Used in model constraints
load('Parameter_4Ernesto23.mat','hotel_big');
hotel = hotel_big;
hotel.parameters.K.names = hotel.parameters.K.names';
hotel.parameters.K.values = hotel.parameters.K.values';
for i=1:hotel.nt
    hotel.parameters.K.names = [hotel.parameters.K.names; ['Ku_' num2str(i-1) '_']];
    hotel.parameters.K.values = [hotel.parameters.K.values; 1442.22155883314];
end
hotel.parameters.c.names = hotel.parameters.c.names';
hotel.parameters.c.values = hotel.parameters.c.values';
hotel.in_adj.rooms = hotel.in_adj.rooms';
hotel.ext_adj.rooms = hotel.ext_adj.rooms';
hotel.ext_adj.mat = hotel.ext_adj.mat';
hotel.ext_adj.temp = hotel.ext_adj.temp';
hotel.ground_adj.rooms = hotel.ground_adj.rooms';
hotel.ground_adj.mat = hotel.ground_adj.mat';
hotel.ground_adj.temp = hotel.ground_adj.temp';
clearvars hotel_big;
% % Flux decision variables based on loaded adjacencies
% % Exterior fluxes on grid s
% load_flux_decision_variables