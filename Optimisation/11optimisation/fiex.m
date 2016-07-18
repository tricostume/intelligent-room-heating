function [ existence ] = fiex( cell_array , string )
%This function finds the index of a specific decision variable inside
% the decision variable string array.
%FIND EXISTENCE = fiex
mask = strfind(cell_array, string);
index = find(not(cellfun('isempty', mask)));
existence = 0;
if ~isempty(index)
   existence = 1;
end
end