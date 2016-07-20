%--------------------Università degli Studi di Genova----------------------
%_________________________________EMARO+___________________________________
%Title: Gurobi solve function
% Called after having loaded a formulation and given generic input names
% so that this function works.
%Period of preparation: 
%Authors: Ernesto Denicia, Emmanuele Vestito
%Script: Run program
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

try
clear model;
model.A = sparse(A);
model.obj = Objective;
model.rhs = b;
model.sense = sense;
model.vtype = var_types;
model.modelsense = modelsense;
model.varnames = dec_vars;
clear params;
params.outputflag = 1;
params.resultfile = 'Results.lp';
%params.timelimit = inf;
result = gurobi(model, params);
disp(result)
for v=1:length(dec_vars)
fprintf('%s %d\n', dec_vars{v}, result.x(v));
end
fprintf('Obj: %e\n', result.objval);
catch gurobiError
fprintf('Error reported\n');
end