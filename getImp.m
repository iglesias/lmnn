function N = getImp(x, M, mode, varargin)
%
% TODO DOC
%

N = [];

if strcmp(mode, 'exact')
    
    fprintf('>>>>> getImp: exact mode selected\n')
    % ensure that the correct number of arguments is given
    assert(length(varargin) == 2)
    % extract arguments
    y = varargin{1};    
    gen = varargin{2};
    
    % get the number of data examples
    n = size(x,2);
    % ensure that gen's second dimension is a multiple of n
    assert(mod( size(gen,2), n ) == 0)
    % get the number of target neighbours used
    k = size(gen,2)/n;
    
    % compute the linear transformation from the Mahal. matrix
    L = sqrtm(M);
    % transform the data
    Lx = L*x;
    % compute square distances to target neighbours plus margin
    Ni = zeros(k,n);
    for i = 1:k
        Ni(i,:) = sum( (Lx - Lx(:, gen(1, (i-1)*n+1:i*n) )).^2 ) +1;
    end
    
    %FIXME this is way too slow!!
    % compute impostors
    for i = 1:n % for each training example
        for j = 1:k % for each target neighbour
            % get training examples labelled differently
            idxs = find(y~=y(i));
            for idx = idxs % for each possible impostor
                % compute square distance to current training example
                % and compare with the distance plus margin to the
                % current target neighbour
                if sum( (Lx(:,i)-Lx(:,idx)).^2 ) <= Ni(j,i)
                    N = [N [i; gen(1, (j-1)*n+i); idx]];
                end
            end
        end
    end
    
    
    
elseif strcmp(mode, 'approx')
    fprintf('>>>>> getImp: approx mode selected\n')
    % ensure that the correct number of arguments is given
    assert(length(varargin) == 1)
    % extract arguments
%     Ncex = varargin{1};
    
    %%%TODO
else
    error('%s mode not available, use either exact or approx', mode)
end
    