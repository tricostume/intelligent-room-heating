% Function which copy the variable room to save the last value of the day k
% so that we can use it as the previous value of the first step of the day
% k + 1. Moreover, we can use it also for first absolute step. 

for i = 1 : cells
    for j = 1 : cells
        for f = 1 : n_floors
            if room(i,j,f).num ~= 0
                room_temp(i,j,f) = room(i,j,f);
            end
        end
    end
end