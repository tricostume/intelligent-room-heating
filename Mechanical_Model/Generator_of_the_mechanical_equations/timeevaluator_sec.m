function [ difference ] = timeevaluator_sec( init_time )
%This function returns the value of the enlapse time between an initial
%point and the current time. 
%WARNING: It can return also a negative value!!!
%The initial and current time must be taken in the main function so:
%init_time = clock %in the initial moment

current_time = clock;
difference = (current_time(6)-init_time(6)) + (current_time(5)-init_time(5))*60 + (current_time(4)-init_time(4))*60*60 + (current_time(3)-init_time(3))*60*60*24;
%According to the position in the previous equation there are:
%sec; min; hours; days. 
%!!!Check you are not using this clock on changing month midnight!!!!  
end

