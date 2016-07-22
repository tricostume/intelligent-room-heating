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
                Ix1 = fiix(dec_vars,['x' num2str(i-1) '_n_']);
                A_row(Ix1) = 1;
            else
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

%% Yield at least optimal yield found before
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


% Constraint form
A = [A; Revenue];
b= [b; Yopt];
n_const3 = size(A,1)-n_const1-n_const2;
%% Enforcing generation of other solutions
  
for j=1:solutions_number-1
    if j == 1
        extracted_xdr = result.x;
    else
        load([folder 'H' num2str(hotel_count) '_OPT_SG_Y' num2str(instance_number) '_Sol' num2str(j) '.mat']);
        extracted_xdr = result.x;
    end
    A_row = zeros(1,size(dec_vars,2));
    for i= 1: n_xdr
        if extracted_xdr(i) == 1
            A_row(i) = 1;
        end
    end
    A= [A; A_row];
    b= [b;sum(extracted_xdr)-1]; % Enforcement to generate other solutions
end

n_const4 = size(A,1)-n_const1-n_const2-n_const3; 