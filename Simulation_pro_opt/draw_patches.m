function [ ] = draw_patches( vector,color )
% Draw the patches passed in a vector onto a figure,
% a hold on dependency must be stablished outside of
% the function.
vertices = [vector(1) vector(2); vector(3) vector(4); vector(5) vector(6); vector(7) vector(8)];
            hold on
            h = patch(vertices(:,1), vertices(:,2), color);
            drawnow
            hold on

end

