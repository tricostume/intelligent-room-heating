function [ Revenue_res ] = Revenue_comp( dec_vars )
%This function computes the revenue of a feasible soution in vector form
load('H1_Rvector_1.mat');

if ~iscolumn(dec_vars)
    dec_vars = dec_vars';
end

if size(dec_vars,1)>size(Revenue,2)
    Revenue = [Revenue,zeros(1,size(dec_vars,1)-size(Revenue,2))];
    Revenue_res = Revenue*dec_vars;
else
    Revenue_res = Revenue*dec_vars;
end


end

