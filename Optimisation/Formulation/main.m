%--------------------Università degli Studi di Genova----------------------
%_________________________________EMARO+___________________________________
%Title: Main file to run for complete analysis
% Hotel 1... Matrix Preparation ... Energy Formulation (after yield)
%Period of preparation: 
%Authors: Ernesto Denicia, Emmanuele Vestito
%Script: Preparation of matrices and parameters for Gurobi to work
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
num_solutions=0;
for hotel_count = 1:1
    for instance_number=11:30
        % Run Revenue Formulation
        eval(['H' num2str(hotel_count) '_MP_R']);
        solutions_number = 2;
        % Run Solution Generator
        for solutions_number = 2:5
            eval(['H' num2str(hotel_count) '_MP_SG']);
        end
        % Find the energy consumption of the found cases
        for solutions_number = 2:6
            eval(['H' num2str(hotel_count) '_MP_EC']);
        end
        % Run Energy Formulation
        eval(['H' num2str(hotel_count) '_MP_E']);
    end
end