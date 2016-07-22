%--------------------Università degli Studi di Genova----------------------
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
clc;
clearvars -except hotel_count instance_number solutions_number folder;
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
% LOAD OPTIMAL YIELD FROM REVENUE STEP
load('H1_OPT_Y1');
Yopt = result.objbound;

%% Generation of decision variables
generate_dec_vars_Revenue;

%% Set up objective function
% Profit assigning request d to room r
Income=[10 25 80]; %Number of available commercial rooms4 16 80
Outcome=[1 3 8]; % Maintenance of those rooms 
Profit =zeros(size(Income,2),size(Income,2));
for i=1:size(Income,2)
    for j = 1:size(Income,2)
        if i<=j
            Profit(i,j)=Income(i)-Outcome(j);
        end       
    end
end

% Generating Gurobi objective multiplying vector
Revenue = zeros(1,size(dec_vars,2));
for i = 1:size(Rdn,1) % request
   for j = 1:size(Rdn,2) % room
       if Rdn(i,j) == 1
           if j == size(Rdn,2)
           else
               if str2num(type2str(input_requests(i,1:3))) == 111
                   if str2num(type2str(input_rooms(j,:))) == 111
                        Ix1 = fiix(dec_vars,['x' num2str(i-1) '_' num2str(j-1)]);
                        Revenue(Ix1) = Profit(1,1)*(input_requests(i,5)-input_requests(i,4)); 
                   elseif str2num(type2str(input_rooms(j,:))) == 233
                        Ix1 = fiix(dec_vars,['x' num2str(i-1) '_' num2str(j-1)]);
                        Revenue(Ix1) = Profit(1,3)*(input_requests(i,5)-input_requests(i,4));
                   elseif str2num(type2str(input_rooms(j,:))) == 123
                        Ix1 = fiix(dec_vars,['x' num2str(i-1) '_' num2str(j-1)]);
                        Revenue(Ix1) = Profit(1,2)*(input_requests(i,5)-input_requests(i,4));                       
                   end
               elseif str2num(type2str(input_requests(i,1:3))) == 233
                   if str2num(type2str(input_rooms(j,:))) == 111
                       disp('There is a bug in the code! Check Profit');
                        Ix1 = fiix(dec_vars,['x' num2str(i-1) '_' num2str(j-1)]);
                        Revenue(Ix1) = Profit(2,1)*(input_requests(i,5)-input_requests(i,4));
                   elseif str2num(type2str(input_rooms(j,:))) == 233
                        Ix1 = fiix(dec_vars,['x' num2str(i-1) '_' num2str(j-1)]);
                        Revenue(Ix1) = Profit(2,3)*(input_requests(i,5)-input_requests(i,4));
                   elseif str2num(type2str(input_rooms(j,:))) == 123
                        Ix1 = fiix(dec_vars,['x' num2str(i-1) '_' num2str(j-1)]);
                        Revenue(Ix1) = Profit(2,2)*(input_requests(i,5)-input_requests(i,4));
                   end
               elseif str2num(type2str(input_requests(i,1:3))) == 123    
                   if str2num(type2str(input_rooms(j,:))) == 111
                       disp('There is a bug in the code! Check Profit');
                        Ix1 = fiix(dec_vars,['x' num2str(i-1) '_' num2str(j-1)]);
                        Revenue(Ix1) = Profit(3,1)*(input_requests(i,5)-input_requests(i,4));
                   elseif str2num(type2str(input_rooms(j,:))) == 233
                        Ix1 = fiix(dec_vars,['x' num2str(i-1) '_' num2str(j-1)]);
                        Revenue(Ix1) = Profit(3,3)*(input_requests(i,5)-input_requests(i,4));
                   elseif str2num(type2str(input_rooms(j,:))) == 123
                       disp('There is a bug in the code! Check Profit'); 
                       Ix1 = fiix(dec_vars,['x' num2str(i-1) '_' num2str(j-1)]);
                       Revenue(Ix1) = Profit(3,2)*(input_requests(i,5)-input_requests(i,4)); 
                   end
               end
           end
       end
   end
end

%Save it for future use in general Energy and Revenue computations
save('H1_Rvector_1.mat','Revenue');
%% Generation of constraints 
generate_constraints_Revenue_SG;

%% Set up objective function
% Prepare constraints sense string 
sense = [repmat('=',n_const1,1);...
         repmat('<',n_const2,1);
         '>';
         repmat('<',solutions_number-1,1)]; % Revenue constraint
     
% Variable types
% Prepare constraints for variable types column vector
var_types = repmat('B',n_xdr,1);

% Choose kind of problem
modelsense = 'max';

% Pass objective function
Objective = Revenue;

% Name result file
Result_file=[folder '\Results' num2str(instance_number) 'SG_Sol' num2str(solutions_number) '.lp'];
Log_file =[folder '\Log_H' num2str(hotel_count) 'SG' num2str(instance_number) 'Sol' num2str(solutions_number) '.txt'];

%% Run Gurobi
gurobi_solve;
save([folder 'H' num2str(hotel_count) '_OPT_SG' num2str(instance_number) '_Sol' num2str(solutions_number)]); % Save workspace
save([folder 'H' num2str(hotel_count) '_OPT_SG_Y' num2str(instance_number) '_Sol' num2str(solutions_number)],'result'); % Result matrix

     
     