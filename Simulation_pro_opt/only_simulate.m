%--------------------Università degli Studi di Genova----------------------
%_________________________________EMARO+___________________________________
%Thesis: 
%Period of preparation: 
%Authors: Ernesto Denicia, Emmanuele Vestito
%Script: Simulation after parameter identification.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%% Load the data to be used in the routine
close all; clc
clearvars -except hotel_count instance_number
load(['..\Optimisation\Formulation\H' num2str(hotel_count) '\instance' ...
       num2str(instance_number) '\H' num2str(hotel_count) '_OPT_E' ...
       num2str(instance_number) '_Sol1.mat']);
%load('..\Optimisation\Formulation\H1\instance1\H1_OPT_R1.mat');
global i_states;
samples = size(zit,2)*24; % Note: measured in hours
M = csvread('MyDesign_EnergyUse_comp.csv',1,1);
T_sp = 20;
T_cool_sp = 26;
% Control normalisation (used below in control redefinition)
u_rooms = zeros(size(zit,2)*24,hotel.nt);
for i=1:hotel.nt % room
    for j=1:size(zit,2) % time
        Ix1 = fiix(dec_vars,['z' num2str(i-1) '_' num2str(j) '_']);
        if result.x(Ix1) == 1
            u_rooms(24*(j-1)+1:24*j,i) = 1;
        end
    end
end
u_rooms = u_rooms';
u_cooling = u_rooms;
Te = M(1:24*size(zit,2),1)';
% Solar radiation heat fluxes
qS = M(:,6:6:end)';
% Choose sampling time (write number of seconds corresponding to period)
% E.G. if we want to sample at every hour Ts = 3600
% E.G. at every n hourse Ts = 3600*n
% E.G. if we want to sample at every day Ts = 3600*24
Ts = 3600*1;
% Retrieve Gurobi temperatures
for  i=1:hotel.nt  % room
    for j=1:size(zit,2)+1 %time
        Ix1 = fiix(dec_vars,['T' num2str(i-1) '_' num2str(j) '_']);
        T_rooms(24*(j-1)+1:24*j,i) = result.x(Ix1);
    end 
end
T_rooms = T_rooms';
%% Define initial guesses and program lsqnonlin
% Initial guess from previous optimisation
%generate_P_init_guess;
load('P_init_overall');
[X,U_prop_heat, U_int_heat, U_prop_cool,time]=simulate_series_graph(T_rooms,u_rooms, u_cooling, Te, qS,Ts,samples,P0);