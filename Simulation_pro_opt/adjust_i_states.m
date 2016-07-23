function [ x ] = adjust_i_states( previous, x, flag_aux_i )

for i=13:24
    if previous(i-12) > 20  || flag_aux_i==0
        x(i) = previous(i);
    end
end
end

