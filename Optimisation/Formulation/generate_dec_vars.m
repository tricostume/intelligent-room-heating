%--------------------Università degli Studi di Genova----------------------
%_________________________________EMARO+___________________________________
%Title: Decision variables generation
%Period of preparation: 
%Authors: Ernesto Denicia, Emmanuele Vestito, Rocco Caravelli
%Script: Decision variables are loaded according to planned formulation,
%considered decision variables are:
% x_dr -> request d assigned to room r
% z_it -> room i assigned on day t
% r_is -> room i assigned on refined period s ([hours]) (remember a day can
% cointan several simulation chunks of lenght s hours.
% Ti,1 -> Initial temperature state of room i
% Ti,s -> Temperature state at refined period s
% u_r,s , uc_r,s , ui_r,s -> Proportional heating and cooling control as
% integral heating control at refined period s.
% q_i,j_s -> Flux from room i to j (including exterior) at refined period
% s.
% ei_1 -> Initial integral errors
% ei_s -> Integral errors at refined period s
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

dec_vars = {};
% xd,r
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

% zi,t
periods = [];
zit = [];
for j = 1:size(Rd,2) %room
   for i = 1:size(Rd,1) %request
       if Rd(i,j) == 1
       periods = [periods; input_requests(i,4:5)];
       end
   end
   periods = t_union(periods);
   for k=1:size(periods,2)
       if periods(k) == 1
            dec_vars = [dec_vars, ['z' num2str(j-1) '_' num2str(k) '_']];
            zit(j,k) = 1;
       end
   end
   periods = [];
end
dec_vars_z_it = dec_vars(n_xdr+1:end);
n_zit = size(dec_vars,2)-n_xdr;

% Generate simulating binary control commands in finer grid ris
for i=1:size(zit,1) % rooms
   for j=1:size(zit,2) % time
       if zit(i,j) == 1 % 
           for k = (j-1)*24/s +1 : 1 : j*24/s % simulation grid
                dec_vars = [dec_vars, ['r' num2str(i-1) '_' num2str(k) '_']];
                ris(i,k) = 1;
           end
       end
   end
end
dec_vars_r_is = dec_vars(n_xdr+n_zit+1:end);
n_ris = size(dec_vars,2)-n_xdr-n_zit;

% Initial temperature states
for i=1:size(input_rooms,1)
    dec_vars = [dec_vars, ['T' num2str(i-1) '_1_']];
end
dec_vars_Ti1 = dec_vars(n_xdr+n_zit+n_ris+1:end);
n_Ti1 = size(dec_vars,2)-n_xdr-n_zit-n_ris;

% Furthter temperature states in refined simulation grid s
for i= 1:size(ris,1) % rooms
   for j=1:size(ris,2) % grid s
       dec_vars = [dec_vars, ['T' num2str(i-1) '_' num2str(j) '_']];
   end
end
dec_vars_Tis = dec_vars(n_xdr+n_zit+n_ris+n_Ti1+1:end);
n_Tis = size(dec_vars,2)-n_xdr-n_zit-n_ris-n_Ti1;

% Initial integral states
for i=1:size(input_rooms,1)
    dec_vars = [dec_vars, ['e' num2str(i-1) '_1_']];
end
dec_vars_ei1 = dec_vars(n_xdr+n_zit+n_ris+n_Ti1+n_Tis+1:end);
n_ei1 = size(dec_vars,2)-n_xdr-n_zit-n_ris-n_Ti1-n_Tis;

% Further integral states along the simulation grid s
for i= 1:size(ris,1) % rooms
   for j=1:size(ris,2) % grid s
       dec_vars = [dec_vars, ['e' num2str(i-1) '_' num2str(j) '_']];
   end
end
dec_vars_eis = dec_vars(n_xdr+n_zit+n_ris+n_Ti1+n_Tis+n_ei1+1:end);
n_eis = size(dec_vars,2)-n_xdr-n_zit-n_ris-n_Ti1-n_Tis-n_ei1;

% Control decision variables
for i= 1:size(ris,1) % rooms
   for j=1:size(ris,2) % grid s
       dec_vars = [dec_vars, ['u' num2str(i-1) '_' num2str(j) '_'],...
                             ['uc' num2str(i-1) '_' num2str(j) '_'],...
                             ['ui' num2str(i-1) '_' num2str(j) '_']];
   end
end
dec_vars_controls = dec_vars(n_xdr+n_zit+n_ris+n_Ti1+n_Tis+n_ei1+n_eis+1:end);
n_controls = size(dec_vars,2)-n_xdr-n_zit-n_ris-n_Ti1-n_Tis-n_ei1-n_eis;

