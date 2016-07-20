%--------------------Università degli Studi di Genova----------------------
%_________________________________EMARO+___________________________________
%Title: Generate constraints
%Period of preparation: 
%Authors: Ernesto Denicia, Emmanuele Vestito, Rocco Caravelli
%Script: Constraints are generated for linear optimisation following
% structure A x < b, where < can be either that or >, <=, >=
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%% One room assigned to each request
A_row = zeros(1,size(dec_vars,2));
A=[];
b=[];
for i=1:size(Rdn,1) % requests
    for j=1: size(Rdn,2) % rooms
        if Rdn(i,j) == 1
            if j == size(Rdn,2)
                Ix1 = fiix(dec_vars,['x' num2str(i-1) '_' num2str(j-1) '_']);
                A_row(Ix1) = 1;
            end
        end
    end
    A = [A; A_row];
    A_row = zeros(1,size(dec_vars,2));
end
n_const1 = size(A,1);
% Fill in respective b vector
b = ones(n_const1,1);

%% Avoidance of ties
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

% Fill in respective b vector
b = [b;ones(n_const2,1)];
