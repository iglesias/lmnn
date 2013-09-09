function L = gradientStepL(L, G, stepsize, diagonal)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if diagonal
   L = L - stepsize*G;
   L = diag(diag(L));
else
   error('gradientStepL only supports diagonal mode')
end

end
