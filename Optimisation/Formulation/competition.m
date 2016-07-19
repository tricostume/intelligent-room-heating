function [ Dd ] = competition( input_requests )
% Returns the competition matrix containing the competing requests to each
% of the requests contained in the booking input file. Notice that for this
% booking times are taken into consideration.
global general_compatibility general_room_types
Dd = zeros(size(input_requests,1),size(input_requests,1));
for i = 1:size(input_requests,1)
    for j = 1:size(input_requests,1)
        if i == j
        else
            if time_overlap(input_requests(i,4),...
                            input_requests(i,5),...
                            input_requests(j,4),...
                            input_requests(j,5)) == 1
                        
                        
                        input_requests(i,4)
                        input_requests(i,5)
                        input_requests(j,4)
                        input_requests(j,5)
                        
                        d1 = input_requests(i,1:3);
                        d2 = input_requests(j,1:3);
                        d1_ix = type2ix (d1, general_room_types);
                        % Get compatibles of d1
                        compatibles = eval(['general_compatibility.r' num2str(d1_ix)]);
                        if sum(cell2mat(compatibles)) == 0
                            compatibles = {type2str(d1)};
                        else
                            compatibles = [compatibles, type2str(d1)];
                        end
                        % Fill up Dd matrix
                        if fiex(compatibles,type2str(d2)) == 1
                            Dd(i,j) = 1;
                        end
    
            else
            Dd(i,j) = 0;
            end
        end
    end
end

end