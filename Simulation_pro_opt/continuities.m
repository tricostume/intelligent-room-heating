function [ IX ] = continuities( series )
%This function receives a binary series and returns the initial and
% final indexes of continuous ones in the series.
if ~isrow(series)
    series=series';
end

indexes=[0,1];
IX=[0,0];
a=1;
while 1 
    indexes=find_first_continuous(series(indexes(2):end));
    IX = [IX;indexes+[IX(a,2),IX(a,2)]];
    if indexes(2)+IX(a,2) == size(series,2) || indexes(2)<indexes(1)
        break
    end
    
    indexes(2)=indexes(2)+IX(a,2)+1;
    a=a+1;
end
if IX(end,2)<IX(end,1)
    IX=IX(1:end-1,:);
end
IX=IX(2:end,:);
end

