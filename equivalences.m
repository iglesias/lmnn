% The aim of this script is to show experimentally that the computation of
% the (square) distance between two vectors is equivalent in the three ways
% shown in the LMNN JMLR paper.

% The first method applies a linear transformation to the vectors and
% computes the Euclidean distance in the transformed space.

% The second method computes a Mahalanobis distance.

% The third method computes the trace of the product of the Mahalanobis
% matrix and the outer product of the vector difference.

% dimension of the vectors
d = 100;
x1 = rand(d,1);
x2 = rand(d,1);
assert(all(size(x1)==size(x2)))
L = rand(d,d);

% distance_transform
dL = sum((L*(x1-x2)).^2);

% distance_mahalanobis
M = L'*L;
diff = x1-x2;
dM = diff'*M*diff;

% distance_trace
C = diff*diff';
dT = sum(sum(M.*C'));

% display the computed distances
disp(dL)
disp(dM)
disp(dT)
