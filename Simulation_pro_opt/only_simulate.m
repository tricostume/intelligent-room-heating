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
clearvars -except hotel_count instance_number modus solutions_number
if strcmp(modus, 'SG') == 1
    load(['..\Formulation\H' num2str(hotel_count) '\instance' ...
    num2str(instance_number) '\H' num2str(hotel_count) '_OPT_E' ...
    num2str(instance_number) '_Sol' num2str(solutions_number) '.mat']);
else
    load(['..\Optimisation\Formulation\H' num2str(hotel_count) '\instance' ...
    num2str(instance_number) '\H' num2str(hotel_count) '_OPT_' modus ...
    num2str(instance_number) '_Sol' num2str(solutions_number-1) '.mat']);
end
%load('..\Optimisation\Formulation\H1\instance1\H1_OPT_E1_Sol1.mat');
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

% Graph occupancy graph
% Remember pathces work Left Bottom- Right Bottom - Right Top - Left Top 
% Retrieve occupancy
occupancy = zeros(hotel.nt,size(zit,2));
for  i=1:hotel.nt  % room
    for j=1:size(zit,2)+1 %time   
        Ix1 = fiix(dec_vars,['z' num2str(i-1) '_' num2str(j) '_']);
        if result.x(Ix1) == 1
            occupancy(i,j) = 1;
        end
    end 
end% Graph occupancy graph

% Graphing results
figure
hold on
a=1;
for i=1:10
    subplot(10,1,i);
    cont = continuities(occupancy(i,:));
    if ~isempty(cont)
        for j=1:size(cont,1)
            color = 'b';
            if i==7
                color = 'k';
            elseif i>=8
                color = 'r';
            end
            vertices = [cont(j,1) 0; cont(j,2)+1 0; cont(j,2)+1 1; cont(j,1) 1];
            h = patch(vertices(:,1), vertices(:,2), color);
            hold on
            axis([0 size(zit,2) 0 1])
        end
    else
        axis([0 size(zit,2) 0 1])
    end
end

% Define HOTEL in patches
% hotel_patches.r0 = [0,11;2,11;2,14;0,14];
% hotel_patches.r1 = [3,11;5,11;5,14;3,14];
% hotel_patches.r2 = [0,8;2,8;2,11;0,11];
% hotel_patches.r3 = [3,8;5,8;5,11;3,11];
% hotel_patches.r4 = [0,5;2,5;2,8;0,8];
% hotel_patches.r5 = [3,5;5,5;5,8;3,8];
% hotel_patches.r6 = [0,2;2,2;2,5;0,5];
% hotel_patches.r7 = [3,3;6,3;6,5;3,5];
% hotel_patches.r8 = [6,3;9,3;9,5;6,5];
% hotel_patches.r9 = [0,0;3,0;3,2;0,2];
% hotel_patches.r10 = [3,0;9,0;9,2;3,2];
% hotel_patches.r11=[2,2;9,2;9,3;2,3];
% hotel_patches.r12=[2,3;3,3;3,14;2,14];
hotel_patches(1,:) = [0,11,2,11,2,14,0,14];
hotel_patches(2,:) = [3,11,5,11,5,14,3,14];
hotel_patches(3,:) = [0,8,2,8,2,11,0,11];
hotel_patches(4,:) = [3,8,5,8,5,11,3,11];
hotel_patches(5,:) = [0,5,2,5,2,8,0,8];
hotel_patches(6,:) = [3,5,5,5,5,8,3,8];
hotel_patches(7,:) = [0,2,2,2,2,5,0,5];
hotel_patches(8,:) = [3,3,6,3,6,5,3,5];
hotel_patches(9,:) = [6,3,9,3,9,5,6,5];
hotel_patches(10,:) = [0,0,3,0,3,2,0,2];
hotel_patches(11,:) = [3,0,9,0,9,2,3,2];
hotel_patches(12,:)=[2,2,9,2,9,3,2,3];
hotel_patches(13,:)=[2,3,3,3,3,14,2,14];

draw_hotel
clf
% Animation

for i=1:size(occupancy,2) % time
    figure(1)
    hold on
    for j=1:10 % rooms
        %draw_hotel;
        if occupancy(j,i) == 1
            draw_patches(hotel_patches(j,:),'g');
        else
            draw_patches(hotel_patches(j,:),'b');
        end       
    end
    %txt1 = num2str(i);
    %text(6,10,txt1)
    pause(1);
end


