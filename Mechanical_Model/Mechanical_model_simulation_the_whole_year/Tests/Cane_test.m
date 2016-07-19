% Copyright 2016, Gurobi Optimization, Inc.
%
% This example formulates and solves the following simple LP model:
% maximize
%       x + 2 y + 3 z
% subject to
%       x +   y        <= 1
%             y +   z  <= 1
%
clear model;
model.A = sparse([1 1 0; 0 1 1]);
model.obj = [1 2 3];
model.modelsense = 'Max';
model.rhs = [1 1];
model.sense = [ '<' '<'];

result = gurobi(model)

disp(result.objval);
disp(result.x);

% Alterantive representation of A - as sparse triplet matrix
i = [1; 1; 2; 2];
j = [1; 2; 2; 3];
x = [1; 1; 1; 1];
model.A = sparse(i, j, x, 2, 3);

clear params;
params.method = 2;
params.timelimit = 100;

result = gurobi(model, params);

disp(result.objval);
disp(result.x)


%%

% Copyright 2016, Gurobi Optimization, Inc.

% This example formulates and solves the following simple MIP model:
%  maximize
%        x +   y + 2 z
%  subject to
%        x + 2 y + 3 z <= 4
%        x +   y       >= 1
%  x, y, z binary

names = {'x'; 'y'; 'z'};

try
    clear model;
    model.A = sparse([1 2 3; 1 1 0]);
    model.obj = [1 1 2];
    model.rhs = [4; 1];
    model.sense = '<>';
    model.vtype = 'B';
    model.modelsense = 'max';
    model.varnames = names;

    gurobi_write(model, 'mip1.lp');

    clear params;
    params.outputflag = 0;

    result = gurobi(model, params);

    disp(result)

    for v=1:length(names)
        fprintf('%s %d\n', names{v}, result.x(v));
    end

    fprintf('Obj: %e\n', result.objval);

catch gurobiError
    fprintf('Error reported\n');
end
