%--------------------Università degli Studi di Genova----------------------
%_________________________________EMARO+___________________________________
%Title: Decision variables generation for Revenue OPT problem
%Period of preparation: 
%Authors: Ernesto Denicia, Emmanuele Vestito, Rocco Caravelli
%Script: Decision variables are loaded according to planned formulation,
%considered decision variables are:
% x_dr -> request d assigned to room r
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

dec_vars = {};
%% xd,r
for i = 1:size(Rdn,1)
   for j = 1:size(Rdn,2)
       if Rdn(i,j) == 1
           if j == size(Rdn,2)
               dec_vars = [dec_vars, ['x' num2str(i-1) '_n_']];
           else
               dec_vars = [dec_vars, ['x' num2str(i-1) '_' num2str(j-1) '_']];
           end
       end
   end
end
dec_vars_x_dr = dec_vars;
n_xdr = size(dec_vars,2);