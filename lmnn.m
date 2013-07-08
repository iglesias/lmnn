function M = lmnn(x,y,k)
%
% TODO DOC
%

%%% preamble

% get input dimension and number of examples from data
[d, n] = size(x);
% trade-off between pull and push forces in the objective or loss function
mu = 0.5;
% number of iterations between exact computation of impostors
correction = 1;
% learning rate used in gradient descent
stepsize = 1e-07;
% maximum number of iterations
maxiter = 500;
% objective
obj = zeros(1,maxiter);

% the labels must be given in a vector
assert(any( size(y)==1 ))
% if they are not given in a row vector, transpose them
if size(y,1) ~= 1
    y = y';
end

% the number of feature vectors must be equal to the number of labels
assert(n == length(y))

%%% initializations

% distance, identity matrix
M = eye(d);
% iteration counter counter
iter = 0;
% previous active set of impostors, empty
Np = [];
% compute target or genuine neighbours
gen = getGenNN(x,y,k);
% compute all outer products
C = computeOuterProducts(x);
% (sub-)gradient
G = (1-mu)*sumOuterProducts(C, gen(2,:), gen(1,:));
% stop criterion
stop = false;

%%% main loop

while ~stop && iter < maxiter
    
    fprintf('Starting iteration %d...\n', iter)
    % impostors computation
    if mod(iter,correction) == 0
        % compute exactly the set of impostors
        Ncex = getImp(x, M, 'exact', y, gen);
        Nc = Ncex;
    else
        % approximate the set of impostors, \hat{Nc}
        Nc = getImp(x, M, 'approx', Ncex);
    end
    fprintf('>>>>> total number of impostors neighbours is %d\n', size(Nc,2))
    
    % (sub-)gradient computation
    G = updateGradient(G, C, Nc, Np, mu);
    % take gradient step in the distance and get PSD matrix
    M = psdmat(M - stepsize*G);
    
    % update iteration counter
    iter = iter+1;
    % compute objective
    obj(iter) = lmnnObj(x, M, C, gen, Nc, mu);
    fprintf('finished! The objective is %f\n', obj(iter))

    % correct stepsize
    if iter > 1
        fprintf('>>>>> stepsize used is %e\n', stepsize)
        % difference between current and previous objective
        delta = obj(iter) - obj(max(iter-1,1));
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
end