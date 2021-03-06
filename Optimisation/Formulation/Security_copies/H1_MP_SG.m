%--------------------UniversitÓ degli Studi di Genova----------------------
%_________________________________EMARO+___________________________________
%Title: Matrix_preparation H1_MP_SG
% Hotel 1... Matrix Preparation ... Energy Formulation Solution Generation
%Period of preparation: 
%Authors: Ernesto Denicia, Emmanuele Vestito
%Script: Preparation of matrices and parameters for Gurobi to work. A
%generation of extra solutions with Yopt is ensured with constraints
%Y>=Yopt and Sum(xij)<=xij_dec_vars-1
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
clc;clear;
%% Read input file in and declare needed variables
load('input_requests_small_hotel.mat');
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
s = 24; % Refining factor of the simulation grid
M = 100;
Tsp = 20; % Temperature to be reached when a room is activated
Ts = 3600*24; % For parameter adequation, write sampling time in the form
             % 3600* num hours.
% LOAD OPTIMAL YIELD FROM LAST STEP
load('H1_OPT_Y1');
Yopt = result.objbound;
%% Generation of hotel topology and flux decision variables
% Used in model constraints
load_topology_small_hotel;
% % Flux decision variables based on loaded adjacencies
% % Exterior fluxes on grid s
% load_flux_decision_variables
%% Generation of decision variables
generate_dec_vars_Energy;

%% Generation of constraints 
generate_constraints_Energy_SG;

%% Set up objective function
% Determination of energy consumption
Energy_Consumption = [zeros(1,n_xdr+n_zit+n_Ti1+n_Tit),ones(1,n_controls)];
%Save it for future use in general Energy and Revenue computations
save('H1_Evector_1.mat','Energy_Consumption');
%% Gurobi specific requirements
% Prepare constraints sense string 
sense = [repmat('=',n_const1,1);...
         repmat('<',n_const2,1);...
         repmat('=',n_const3,1);...
         repmat('=',n_const4,1);...
         repmat('>',n_const5,1);...
         repmat('>',n_const6,1);...
         repmat('=',n_const7,1);
         '>';   % Revenue constraint
         '<'];   % Other solution enforcement
     
% Variable types
% Prepare constraints for variable types column vector
var_types = [repmat('B',n_xdr,1);...
             repmat('B',n_zit,1);...
             repmat('C',n_Ti1,1);...
             repmat('C',n_Tit,1);...
             repmat('C',n_controls,1)];

% Choose kind of problem
modelsense = 'min';

% Pass objective function
Objective = Energy_Consumption;

% Name result file
Result_file='Results.lp';

%% Run Gurobi
gurobi_solve;
     
     
     

     
     