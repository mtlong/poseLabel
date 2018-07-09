function C = cart2cos(x)
% turn image coordinator to Cosine Matrix 
% input x = 2xN
x_bar = [x;ones(1,length(x))];
C = pdist(x_bar','cosine');

end