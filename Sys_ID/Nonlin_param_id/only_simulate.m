%--------------------Università degli Studi di Genova----------------------
%_________________________________EMARO+___________________________________
%Thesis: 
%Period of preparation: 
%Authors: Ernesto Denicia, Emmanuele Vestito
%Script: Simulation after parameter identification.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%% Load the data to be used in the routine
clear all; close all; clc
global i_states;
samples = 500; % Note: measured in hours
M = csvread('MyDesign_EnergyUse_comp.csv',1,1);
T_rooms = M(:,2:6:end)';
T_sp = 20;
T_cool_sp = 26;
% Control normalisation (used below in control redefinition)
u_rooms = M(:,4:6:end)'/T_sp;
u_cooling = M(:,5:6:end)'/T_cool_sp;
%u_rooms = u_rooms .* (T_sp*u_rooms-T_rooms);
Te = M(:,1)';
% Solar radiation heat fluxes
qS = M(:,6:6:end)';
% Choose sampling time (write number of seconds corresponding to period)
% E.G. if we want to sample at every hour Ts = 3600
% E.G. at every n hourse Ts = 3600*n
% E.G. if we want to sample at every day Ts = 3600*24
Ts = 3600*24;

%% Define initial guesses and program lsqnonlin
% Initial guess from previous optimisation
%generate_P_init_guess;
load('P_init_overall');
[X,U_prop_heat, U_int_heat, U_prop_cool,time]=simulate_series_graph(T_rooms,u_rooms, u_cooling, Te, qS,Ts,samples,P0);