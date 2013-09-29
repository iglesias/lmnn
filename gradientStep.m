function L = gradientStep(L, G, stepsize, diagonal)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if diagonal
   % diagonal update, L is forced to be a diagonal matrix
   M = L'*L;
   M = M - stepsize*G;
   M = diag(M);
   L = diag(sqrt(max(M,0)));
else
    % take gradient step in L direction
    L = L - stepsize*2*L*G;
end

end

