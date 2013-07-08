function obj = lmnnObj(x, M, C, gen, Nc, mu)
%
% TODO DOC
%

% get the number of data examples
n = size(x,2);
% initialize the objective
obj = 0;

for i = 1:n % for each training example
    % get the indices of its target neighbours
    genIdxs = gen(1, gen(2,:)==i);
    for j = genIdxs % for each target neighbour
        % add the pull contribution to the objective
        obj = obj + (1-mu)*trace(M*C{i,j});
        
        % find possible impostors for this training example and target
        % neighbour
        impIdxs = intersect( find(Nc(1,:)==i), find(Nc(2,:)==j) );
        for l = Nc(3,impIdxs) % for each possible impostor
            tmp = 1 + trace(M*C{i,j}) - trace(M*C{i,l});
            if tmp > 0
                obj = obj + mu*tmp;
                
                % runtime checks
                if ~isempty(l)
                    d2_i_j = (x(:,i)-x(:,j))'*M*(x(:,i)-x(:,j));
                    d2_i_l = (x(:,i)-x(:,l))'*M*(x(:,i)-x(:,l));
                    assert(d2_i_l <= d2_i_j+1 )
                end
            end
        end
    end
end

