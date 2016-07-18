function [ union ] = t_union( array )
%This function calculates the union of the activation periods passed ot it
%in an N x 2 array specifying the initial and ending times of each of N
%bookings.

temp = [];
for i=1:size(array,1)
    for j=array(i,1):array(i,2)-1
    temp(j) = 1;
    end
end
union = temp;
end

