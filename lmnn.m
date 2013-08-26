function L = lmnn(x,y,k,varargin)
%
% TODO DOC
%

%%% preamble

% get input dimension and number of examples from data
[d, n] = size(x);
% trade-off between pull and push forces in the objective or loss function
mu = 0.5;
% number of iterations between exact computation of impostors
correction = 15;
% learning rate used in gradient descent
stepsize = 1e-07;
% maximum number of iterations
maxiter = 1000;
% objective
obj = zeros(1,maxiter);
% whether the output transformation L should be diagonal
diagonal = false;

% optional arguments
for i = 1:length(varargin)
    if strcmp(varargin{i},'diagonal')
        diagonal = true;
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
% iteration counter
iter = 0;
% previous active set of impostors, empty
Np = [];
% compute target or genuine neighbours
gen = getGenNN(x,y,k);
% (sub-)gradient
G = (1-mu)*sumOuterProducts(x,gen(2,:),gen(1,:));
% stop criterion
stop = false;

%%% main loop

while ~stop && iter < maxiter
    
    % impostors computation
    if mod(iter,correction) == 0
        % compute exactly the set of impostors
        Ncex = getImp(x, L, gen, 'exact', y);
        Nc = Ncex;
    else
        % approximate the set of impostors, \hat{Nc}
        Nc = getImp(x, L, gen, 'approx', Ncex);
    end
% % %     fprintf('>>>>> total number of impostors neighbours is %d\n', size(Nc,2))

    % (sub-)gradient computation
    G = updateGradient(x, G, Nc, Np, mu);
    % take gradient step in the distance and get PSD matrix
    L = gradientStep(L, G, stepsize, diagonal);
    
    % update iteration counter
    iter = iter+1;
    % compute objective
    M = L'*L;
    obj(iter) = sum(sum(M.*G')) + mu*size(Nc,2);

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
    
    % update previous impostor set
    Np = Nc;

    fprintf('iteration=%-4d, #impostors=%d, objective=%.4f, stepsize=%.4E\n', ...
        iter, size(Nc,2), obj(iter), stepsize);
end
