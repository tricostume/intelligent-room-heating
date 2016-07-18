%--------------------Università degli Studi di Genova----------------------
%_________________________________EMARO+___________________________________
%Title: Optimisation 
%Period of preparation: 
%Authors: Ernesto Denicia, Emmanuele Vestito
%Script: Optimisation using Gurobi
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
clc;clear;
%% Read input file in and declare needed variables
load('input_requests.mat');
nd = size(input_requests,1);
D = {};
R = {};
% Load marketing strategy of the hotel
load_marketing_strategy;
%% Commercial description of the hotel
% The rooms with which the hotel counts and their kind depending on class,
% number of people and type of bed.
% NOTICE: Inside of the function an input file is loaded!
load_commercial_description;

%% Generate sets
% Generate request set and numeration
for i = 0:nd-1
    temp = ['d' num2str(i) '_'];
    D = [D,temp];
end

% All compatible rooms with each request
Rd = compatibility ( input_requests, input_rooms );
% Add dummy node
Rdn = [Rd, ones(size(Rd,1),1)];
% Generate competing requests for each of the existing requests based on
% marketing analysis
Dd = competition (input_requests);
%% Definition of constant parameters
s = 4; % Refining factor of the simulation grid

%% Generation of decision variables
generate_dec_vars;

%% Generation of hotel topology
% Used in model constraints
load_topology;
%% Generation of constraints 
% One room per request

