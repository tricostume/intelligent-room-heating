function [ index ] = fiix( cell_array , string )
%This function finds the index of a specific decision variable inside
% the decision variable string array.
%FIND INDEX = fiix
mask = strfind(cell_array, string);
index = find(not(cellfun('isempty', mask)));
end

