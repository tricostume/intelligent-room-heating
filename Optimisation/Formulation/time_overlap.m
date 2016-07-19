function [ overlap ] = time_overlap( ti0, tif, tj0, tjf )
%This function tells if two bookings have overlapping in time. Returns
%either 0 or 1 if there is not or there is overlapping, respectively.

P1 = ti0:1:tif;
P2 = tj0:1:tjf;
I = intersect(P1,P2);
if ti0 == tjf
    I = setdiff(I,ti0);
end
if tif == tj0
    I = setdiff(I,tif);
end

if isempty(I)
    overlap = 0;
else
    overlap = 1;
end

end

