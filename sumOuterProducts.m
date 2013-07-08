function sop = sumOuterProducts(C,a,b)
%
% TODO DOC
%

assert(length(a) == length(b))
sop = zeros(size(C{1,1}));

for i = 1:length(a)
  sop = sop + C{a(i),b(i)};
end;