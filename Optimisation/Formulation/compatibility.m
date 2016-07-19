function [ Rd ] = compatibility( input_requests, input_rooms )
% Check for compatibility of each request with all rooms and return
% the respective binary matrix Rd (to be codified with R matrix)
global general_room_types general_compatibility
Rd = zeros(size(input_requests,1),size(input_rooms,1));
for i = 1:size(input_requests,1)
    d = input_requests(i,1:3);
    %Extract index and use it to find compatibles
    %d_ix = type2ix (d, general_room_types);  
    for j=1:size(input_rooms,1);
        r = input_rooms(j,1:3);
        r_ix = type2ix (r, general_room_types);  
        % Append themselves
        compatibles = eval(['general_compatibility.r' num2str(r_ix)]);
        if sum(cell2mat(compatibles)) == 0
            compatibles = {type2str(r)};
        else
            compatibles = [compatibles, type2str(r)];
        end
        % Fill up Rd matrix
        if fiex(compatibles,type2str(d)) == 1
            Rd(i,j) = 1;
        end
    end
    
%     compatibles = eval(['general_compatibility.r' num2str(d_ix)]);
%     % Start filling up Rd matrix
%     if sum(cell2mat(compatibles(1))) == 0
%     else
%         for j=1:size(input_rooms,1);
%             if fiex(compatibles,R(j)) == 1
%                 Rd(i,j) = 1;
%             end
%         end
%     end   
end
end

