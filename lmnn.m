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
correction = 15;
% learning rate used in gradient descent
stepsize = 1e-09;
% maximum number of iterations
maxiter = 1000;
% objective
obj = zeros(1,maxiter);

% the labels must be given in a vector
assert(any( size(y)==1 ))
% if they are given in a row vector, transpose them
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
% (sub-)gradient
G = (1-mu)*sumOuterProducts(x, gen(1,:), gen(2,:));
% stop criterion
stop = false;

%%% main loop

while ~stop && iter < maxiter
    
    % impostors computation
    if mod(iter,correction) == 0
        % compute exactly the set of impostors
        Ncex = getImp(x, M, 'exact', y, gen);
        Nc = Ncex;
    else
        % approximate the set of impostors, \hat{Nc}
        Nc = getImp(x, M, 'approx', Ncex);
    end
    
    % (sub-)gradient computation
    G = updateGradient(G, mu, x, Nc, Np);
    % take gradient step in the distance and get PSD matrix
    M = psdmat(M - stepsize*G);
    
    % update iteration counter
    iter = iter+1;
    % compute objective
    obj(iter) = lmnnObj(mu, x, gen, Nc);

    % correct stepsize
    if iter > 1
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