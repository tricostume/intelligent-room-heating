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
M = 100;
%% Generation of decision variables
generate_dec_vars;

%% Generation of hotel topology and flux decision variables
% Used in model constraints
load_topology;
% Flux decision variables based on loaded adjacencies
% Exterior fluxes on grid s
load_flux_decision_variables
%% Generation of constraints 
% One room assigned to each request
A_row = zeros(1,size(dec_vars,2));
A=[];
for i=1:size(Rdn,1) % requests
    for j=1: size(Rdn,2) % rooms
        if Rdn(i,j) == 1      
            Ix1 = fiix(dec_vars,['x' num2str(i-1) '_' num2str(j-1) '_']);
            A_row(Ix1) = 1;
        end
    end
    A = [A; A_row];
    A_row = zeros(1,size(dec_vars,2));
end
n_const1 = size(A,1);

% Avoidance of ties
A_row = zeros(1,size(dec_vars,2));
for i=1:size(Dd,1) % actual request
    for j=1:size(Dd,2) % competing requests
        if Dd(i,j) == 1
            temp = Rdn(i,:).*Rdn(j,:);% Room Intersection of both requests
            for k=1:size(temp,2) % maximum compatible rooms
                if temp(k) == 1
                    if k ~= size(Rd,2)+ 1
                        Ix1 = fiix(dec_vars,['x' num2str(i-1) '_' num2str(k-1) '_']);
                        Ix2 = fiix(dec_vars,['x' num2str(j-1) '_' num2str(k-1) '_']);
                        A_row(Ix1) = 1;
                        A_row(Ix2) = 1;
                        A = [A; A_row];
                    end
                    A_row = zeros(1,size(dec_vars,2));
                end
            end
        end
    end   
end
n_const2 = size(A,1)-n_const1;

%Activation of rooms in time
A_row = zeros(1,size(dec_vars,2));
temp = [];
for i=1:size(Rd,2) % rooms
    for j=1:size(Rd,1) % requests
        if Rdn(j,i) == 1
            periods = t_union(input_requests(j,4:5));
            % Fill in with zeros for forming matrix in case needed
            temp = [temp;[periods, zeros(1,size(zit,2)-size(periods,2))]];
        end
    end
    % Continue by generating constraint
    for k=1:size(temp,2) % time (same size as zit)
        Ix1 = fiix(dec_vars,['z' num2str(i-1) '_' num2str(k) '_']);
        A_row(Ix1) = 1;
        for l=1:size(temp,1) % request (same size as Rdn)
            Ix2 = fiix(dec_vars,['x' num2str(l-1) '_' num2str(i-1) '_']);
            A_row(Ix2) = -1;
        end
        A = [A; A_row];
        A_row = zeros(1,size(dec_vars,2));
    end
end
n_const3 = size(A,1)-n_const1-n_cost2;

% Copying rooms assignments in time to control commands