function obj = lmnnObj(x, M, C, gen, Nc, mu)
%
% TODO DOC
%

% get the number of data examples
n = size(x,2);
% initialize the objective
obj = 0;

%%% pull contributions
for i = 1:n % for each training example
    % get the indices of its target neighbours
    genIdxs = gen(1, gen(2,:)==i);
    for j = genIdxs % for each target neighbour
        % add the pull contribution to the objective
        obj = obj + (1-mu)*sum( sum(M.*C{i,j}') ); % recall this is the trace
    end
end

%%% push contributions
for idx = 1:size(Nc,2)
    % recall these are two traces computations here
    hinge = 1 + sum(sum(M.*C{Nc(1,idx),Nc(2,idx)}')) ...
        - sum(sum(M.*C{Nc(1,idx),Nc(3,idx)}'));

    if hinge > 0
       obj = obj + mu*hinge;
    end
end
