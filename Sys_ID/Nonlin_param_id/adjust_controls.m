function [ u, uc ] = adjust_controls( u, uc, x )
for i=1:12
    if x(i)>20
        u(i)=0;
    end
    if x(i)<26
        uc(i)=0;
    end
end


end

