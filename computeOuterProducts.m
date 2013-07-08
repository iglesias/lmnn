function C = computeOuterProducts(x)
%
% TODO DOC
%

% get the number of examples from data
n = size(x,2);
% cell matrix allocation
% each element will be a matrix result of an outer product
C = cell(n);

for i = 1:n
    for j = 1:n
        dx = x(:,i)-x(:,j);
        C{i,j} = dx*dx';
    end
end
