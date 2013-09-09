function L = diagonallmnn(x,y,k,varargin)
%
% TODO DOC
%

%%% preamble

% get input dimension and number of examples from data
[d, n] = size(x);
% trade-off between pull and push forces in the objective or loss function
mu = 0.5;
% regularization multiplying the 1-norm trace(L) term
lambda = 5;
% number of iterations between exact computation of impostors
correction = 15;
% learning rate used in gradient descent
stepsize = 1e-4;
% maximum number of iterations
maxiter = 500;
% objective
obj = zeros(1,maxiter);
% diagonal mode is forced
diagonal = true;

% optional arguments
for i = 1:length(varargin)
    if strcmp(varargin{i},'maxiter')
        maxiter = varargin{i+1};
    end
end

% the labels must be given in a vector
assert(any( size(y)==1 ))
% if they are not given in a row vector, transpose them
if size(y,1) ~= 1
    y = y';
end

% the number of feature vectors must be equal to the number of labels
assert(n == length(y))

%%% initializations

% linear transformation, identity matrix
L = eye(d);
Lp = L;
% iteration counter
iter = 0;
% previous active set of impostors, empty
Np = [];
% compute target or genuine neighbours
gen = getGenNN(x,y,k);
% (sub-)gradient initialization
sopgen = sumOuterProducts(x,gen(2,:),gen(1,:));
G = (1-mu)*2*L*sopgen + lambda*eye(d);
% stop criterion
stop = false;

%%% main loop

while ~stop && iter < maxiter
    
    % impostors computation
    N = getImp(x, L, gen, 'exact', y);
    fprintf('>>>>> total number of impostors is %d\n', size(N,2))

    % (sub-)gradient computation
    G = updateGradientL(x, L, Lp, G, sopgen, N, mu);
    % store linear transform at this point, required to update the gradient
    Lp = L;
    % take gradient step in the distance and get PSD matrix
    L = gradientStepL(L, G, stepsize, diagonal);
    
    % update iteration counter
    iter = iter+1;
    % compute objective
    obj(iter) = sum(sum((L'*L).*G')) + mu*size(N,2) + lambda*trace(L);

    % correct stepsize
    if iter > 1
        % difference between current and previous objective
        delta = obj(iter) - obj(iter-1);
        if delta > 0
            % the objective has increased in this iteration
            stepsize = stepsize*0.5;
        else
            % the objective has decreased
            stepsize = stepsize*1.01;
        end
    end

    fprintf('iteration=%-4d, #impostors=%d, objective=%.4f, stepsize=%.4E\n', ...
        iter, size(N,2), obj(iter), stepsize);
end
