function sop = sumOuterProducts(x,a,b)
%
% TODO DOC
%

assert(length(a) == length(b))
sop = zeros(size(x,1));

for i = 1:length(a)
  sop = sop + x(:, a(i))*x(:, b(i))';
end;