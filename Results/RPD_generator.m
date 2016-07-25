%--------------------Università degli Studi di Genova----------------------
%_________________________________EMARO+___________________________________
%Title: RPD Generator
% Hotel 1... Matrix Preparation ... Energy Formulation (after yield)
%Period of preparation: 
%Authors: Ernesto Denicia, Emmanuele Vestito, Rocco Caravelli
%Script: After simulation, one can calculate the RPD of the found cases for
%reporting.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
close all; clc
clearvars -except hotel_count instance_number modus solutions_number
folder = '..\Optimisation\Formulation\H1';
qty = numel(dir(folder))-2;
% EC1 = zeros(qty,1);
% EC2 = zeros(qty,1);
% EC3 = zeros(qty,1);
% EC4 = zeros(qty,1);
% EC5 = zeros(qty,1);
% E = zeros(qty,1);

log_matrix = zeros(6,qty);
for hotel=1:1
    for inst=1:30
        EC1_f = [folder '\instance' num2str(inst) '\H' num2str(hotel) '_OPT_EC' num2str(inst) '_Sol1.mat'];
        EC2_f = [folder '\instance' num2str(inst) '\H' num2str(hotel) '_OPT_EC' num2str(inst) '_Sol2.mat'];
        EC3_f = [folder '\instance' num2str(inst) '\H' num2str(hotel) '_OPT_EC' num2str(inst) '_Sol3.mat'];
        EC4_f = [folder '\instance' num2str(inst) '\H' num2str(hotel) '_OPT_EC' num2str(inst) '_Sol4.mat'];
        EC5_f = [folder '\instance' num2str(inst) '\H' num2str(hotel) '_OPT_EC' num2str(inst) '_Sol5.mat'];
        E_f = [folder '\instance' num2str(inst) '\H' num2str(hotel) '_OPT_E' num2str(inst) '_Sol5.mat'];
        load(EC1_f,'result');
        EC1=result.objval;
        load(EC2_f,'result');
        EC2=result.objval;
        load(EC3_f,'result');
        EC3=result.objval;
        load(EC4_f,'result');
        EC4=result.objval;
        load(EC5_f,'result');
        EC5=result.objval;
        load(E_f,'result');
        E=result.objval;
        log_matrix(:,inst)=[EC1;EC2;EC3;EC4;EC5;E];
    end
end

% Obtain average of each instance
av_per_inst = mean(log_matrix(1:5,:));
%%
% Obtain average for 30% occupacy
av_30 = mean(av_per_inst(1:10));
av_opt_30 = mean(log_matrix(6:1:10));
RPD(1) = (av_30-av_opt_30)/av_30;
% Obtain average for 50% occupacy
av_50 = mean(av_per_inst(11:20));
av_opt_50 = mean(log_matrix(6:11:20));
RPD(2) = (av_50-av_opt_50)/av_50;
% Obtain average for 65% occupacy
av_60 = mean(av_per_inst(21:30));
av_opt_60 = mean(log_matrix(6:21:30));
RPD(3) = (av_60-av_opt_60)/av_60;
