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
%% Activation of rooms in time
A_row = zeros(1,size(dec_vars,2));
temp = [];
for i=1:size(Rd,2) % rooms
    temp = [];
    for j=1:size(Rd,1) % requests
        if Rdn(j,i) == 1
            periods = t_union(input_requests(j,4:5));
            % Fill in with zeros for forming matrix in case needed
            temp = [temp;[periods, zeros(1,size(zit,2)-size(periods,2))]];
        else temp = [temp; zeros(1,size(zit,2))];
        end
    end
    % Continue by generating constraint (analysisng temp)
    for k=1:size(temp,2) % time (same size as zit)
        Ix1 = fiix(dec_vars,['z' num2str(i-1) '_' num2str(k) '_']);
        A_row(Ix1) = 1;
        for l=1:size(temp,1) % request (same size as Rdn)
            if temp(l,k) == 1
                Ix2 = fiix(dec_vars,['x' num2str(l-1) '_' num2str(i-1) '_']);
                A_row(Ix2) = -1;
                disp(l);
            end
        end
        A = [A; A_row];
        A_row = zeros(1,size(dec_vars,2));
    end
end
n_const3 = size(A,1)-n_const1-n_const2;

% Fill in respective b vector
b = [b;zeros(n_const3,1)];
%% % Copying rooms assignments in time to control commands
% A_temp = [];
% A_row = zeros(1,size(dec_vars,2));
% for i=1:size(zit,1) % rooms
%    for j=1:size(zit,2) % time
%        if zit(i,j) == 1 % 
%            for k = (j-1)*24/s +1 : 1 : j*24/s % simulation grid
%                 Ix1 = fiix(dec_vars,['r' num2str(i-1) '_' num2str(k) '_']);
%                 Ix2 = fiix(dec_vars,['z' num2str(i-1) '_' num2str(j) '_']);
%                 A_row(Ix1) = 1;
%                 A_row(Ix2) = -1;
%                 A_temp = [A_temp; A_row];
%                 A_row = zeros(1,size(dec_vars,2));
%            end
%        end
%    end
% end
% dec_vars_r_is = dec_vars(n_xdr+n_zit+1:end);
% n_ris = size(dec_vars,2)-n_xdr-n_zit;

%% Physical model constraints
A_temp = zeros(hotel.nt,size(A,2));
A_temp2 = [];
% Fill in respective b vector parallely
read_in_data = csvread('MyDesign_EnergyUse_comp.csv',1,1);
step = ceil(Ts/3600);
qS = read_in_data(1:step:size(zit,2)*step,6:6:end)';
Te = read_in_data(1:step:size(zit,2)*step,1);
T_rooms_0 = read_in_data(1,2:6:end)';

for i=1:size(zit,2) % time
    for j=1:size(hotel.parameters.K.names,1) %transmitances
        temp = hotel.parameters.K.names(j);
        [token, remain] = strtok(temp,'_');
        Ix1 = strtok(token,'K'); % from room r1
        Ix2 = strtok(remain,'_'); % to room r2
        if strcmp(Ix2,'e') % if exterior
            Ix1 = str2double(Ix1);
            Ix3 = fiix(dec_vars,['T' num2str(Ix1) '_' num2str(i) '_']);
            Ix4 = fiix(hotel.parameters.c.names,['c_' num2str(Ix1) '_']); 
            A_temp(Ix1+1,Ix3) = hotel.parameters.K.values(j)/hotel.parameters.c.values(Ix4);
            b = [b;(hotel.parameters.K.values(j)*Te(i)+qS(i))/hotel.parameters.c.values(Ix4)];
        end
        if strcmp(Ix1,'u')
            Ix2 = str2double(Ix2);
            Ix3 = fiix(dec_vars,['u' num2str(Ix2) '_' num2str(i) '_']);
            Ix4 = fiix(hotel.parameters.c.names,['c_' num2str(Ix2) '_']); 
            A_temp(Ix2+1,Ix3) = -hotel.parameters.K.values(j)/hotel.parameters.c.values(Ix4);
        end
        if ~strcmp(Ix2,'e') && ~strcmp(Ix1,'u')
            Ix1 = str2double(Ix1);
            Ix2 = str2double(Ix2);           
            % look for Tr1,t
            Ix3 = fiix(dec_vars,['T' num2str(Ix1) '_' num2str(i) '_']);
            % look for Tr2,t
            Ix4 = fiix(dec_vars,['T' num2str(Ix2) '_' num2str(i) '_']);
            % look for corresponding r1 capacitance parameter
            Ix5 = fiix(hotel.parameters.c.names,['c_' num2str(Ix1) '_']); 
            % look for corresponding r2 capacitance parameter
            Ix6 = fiix(hotel.parameters.c.names,['c_' num2str(Ix2) '_']);           
            % "From" equation
                % From temperature
            A_temp(Ix1+1,Ix3) = A_temp(Ix1+1,Ix3)+(hotel.parameters.K.values(j))/hotel.parameters.c.values(Ix5);
                % To temperature
            A_temp(Ix1+1,Ix4) = A_temp(Ix1+1,Ix4)-(hotel.parameters.K.values(j))/hotel.parameters.c.values(Ix5);
            % "To" equation
                % From temperature
            A_temp(Ix2+1,Ix4) = A_temp(Ix2+1,Ix4)-(hotel.parameters.K.values(j))/hotel.parameters.c.values(Ix6);
                % To temperature
            A_temp(Ix2+1,Ix3) = A_temp(Ix2+1,Ix3)+(hotel.parameters.K.values(j))/hotel.parameters.c.values(Ix6);
        end
    end
    A_temp2 = [A_temp2; A_temp];
    A_temp = zeros(hotel.nt,size(A,2));
    % Equations of propagation in time (differential approach)
    for k=0:hotel.nt-1
        l = fiix(dec_vars,['T' num2str(k) '_' num2str(i+1) '_']);
        A_temp2(end-(hotel.nt-1)+k,l) = 1;
    end
end
A = [A;A_temp2];
n_const4 = size(A,1)-n_const1-n_const2-n_const3;


%% Control constraints (proportional) <<<<<<--- CHANGE FOR BIG HOTEL
% Positivity
A_row = zeros(1,size(dec_vars,2));

  for i=1:size(zit,2)%time
     for j=1:hotel.nt %room
         Ix1 = fiix(dec_vars,['u' num2str(j-1) '_' num2str(i) '_']);
         A_row(Ix1) = 1;
         A = [A; A_row];
         A_row = zeros(1,size(dec_vars,2));
     end
  end
n_const5 = size(A,1)-n_const1-n_const2-n_const3-n_const4; 
% Fill in respective b vector
b = [b;zeros(n_const5,1)];

  % Control definition
A_row = zeros(1,size(dec_vars,2));
A_temp = [];
  for i=1:size(zit,2)%time
     for j=1:hotel.nt %room
         Ix1 = fiix(dec_vars,['u' num2str(j-1) '_' num2str(i) '_']);
         Ix2 = fiix(dec_vars,['T' num2str(j-1) '_' num2str(i) '_']);
         Ix3 = fiix(dec_vars,['z' num2str(j-1) '_' num2str(i) '_']);
         A_row(Ix1) = 1;
         A_row(Ix2) = 1;
         A_row(Ix3) = -M;
         A_temp = [A_temp; A_row];
         A_row = zeros(1,size(dec_vars,2));
     end
  end
  A= [A; A_temp];
n_const6 = size(A,1)-n_const1-n_const2-n_const3-n_const4-n_const5; 

% Fill in respective b vector
b = [b;(Tsp-M)*ones(n_const6,1)];

% Control of corridors and common areas (lounges)
A_row = zeros(1,size(dec_vars,2));

for k=10:11 % service rooms
    for i=1:size(zit,2) % time
        for j=1:size(zit,1)% room
        % Corridor small hotel   
            Ix1 = fiix(dec_vars,['z' num2str(k) '_' num2str(i) '_']);
             Ix2 = fiix(dec_vars,['z' num2str(j-1) '_' num2str(i) '_']);
             A_row(Ix1) = 1;
             A_row(Ix2) = -M;
             A = [A; A_row];
             A_row = zeros(1,size(dec_vars,2));
        end
    end
end
n_const7 = size(A,1)-n_const1-n_const2-n_const3-n_const4-n_const5-n_const6;
% Fill in respective b vector
b = [b;(1-M)*ones(n_const7,1)];

%% Initial temperature states Ti0
A_row = zeros(1,size(dec_vars,2));
for i=1:hotel.nt
    Ix1 = fiix(dec_vars,['T' num2str(i-1) '_1_']);
    A_row(Ix1) = 1;
    A = [A; A_row];
    b = [b;T_rooms_0(i)];
    A_row = zeros(1,size(dec_vars,2));
end
n_const8 = size(A,1)-n_const1-n_const2-n_const3-n_const4-n_const5-n_const6-n_const7; 

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
