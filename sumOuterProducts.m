function sop = sumOuterProducts(x,a,b)
%
% TODO DOC
%

sop = zeros(size(x,1));
for i = 1:n
  sop = sop + x(:, a(i))*x(:, b(i))';
end;