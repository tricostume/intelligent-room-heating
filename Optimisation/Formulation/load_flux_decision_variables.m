%--------------------Università degli Studi di Genova----------------------
%_________________________________EMARO+___________________________________
%Title: Further loading of flux decision variables
%Period of preparation: 
%Authors: Ernesto Denicia, Emmanuele Vestito, Rocco Caravelli
%Script: Once the adjacencies of the hotel were loaded, one can also load
%the decision variables corresponding to the EQUALITY CONSTRAINTS of the
%flux modelling given by a proportional error to adjacent rooms.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

for i=1:size(hotel.ext_adj.mat,1)
    for k=1:size(ris,2) % grid s
        if hotel.ext_adj.mat(i) == 1
            dec_vars = [dec_vars, ['q' num2str(i-1) '_e_' num2str(k)]];
        end
    end
end
dec_vars_ext_flux = dec_vars(n_xdr+n_zit+n_ris+n_Ti1+n_Tis+n_ei1+n_eis+...
    n_controls+1:end);
n_ext_flux = size(dec_vars,2)-n_xdr-n_zit-n_ris-n_Ti1-n_Tis-n_ei1-n_eis-...
    n_controls;

% Interior fluxes on grid s
for i=1:size(hotel.in_adj.mat,1) % max poss numb of adjacent rooms (all)
    for j=1:size(hotel.in_adj.mat,2)
        for k=1:size(ris,2) % grid s
            if hotel.in_adj.mat(i,j) == 1
                dec_vars = [dec_vars, ['q' num2str(i-1) '_' num2str(j-1) '_' num2str(k)]];
            end
        end
    end
end

dec_vars_in_flux = dec_vars(n_xdr+n_zit+n_ris+n_Ti1+n_Tis+n_ei1+n_eis+...
    n_controls+n_ext_flux+1:end);
n_in_flux = size(dec_vars,2)-n_xdr-n_zit-n_ris-n_Ti1-n_Tis-n_ei1-n_eis-...
    n_controls-n_ext_flux;