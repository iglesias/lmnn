function sop = sumOuterProducts(x,a,b)
%
% TODO DOC
%

assert(length(a) == length(b))
sop = zeros(size(x,1));

for i = 1:length(a)
  dx = x(:,a(i))-x(:,b(i));
  sop = sop + dx*dx';
end;

