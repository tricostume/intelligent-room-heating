function [ indexes ] = find_first_continuous( series )
%Give a series of zeroes and ones and  and return indexes of the first
%series of continuous ones
a=1;
if sum(series) == 0
    indexes =[2,1];
    return 
end
while series(a)~=1 && a~=size(series,2)
    a=a+1;
end
ix1 = a;

while series(a)~=0 && a~=size(series,2)
    a=a+1;
end
ix2=a-1;
if series(a) == 1
    ix2=ix2+1;
end
 indexes=[ix1,ix2];   
end




