function [ index ] = type2ix( type, cell_array )
%Returns the index of a certain room type expressed in numeric format
% i.e. [1,1,1] compared to the general room types matrix.
d = type;
d_str={};
for i=1:3
d_str{i} = num2str(d(i));
end
type = strjoin(strsplit(char(d_str)'));
index = fiix(cell_array,type);

end

