%% getGenNN

fprintf('testing getGenNN...\n\n')

%%% preamble

% number of examples
n = 1000;
% input dimension
d = 10;
% number of different labels values, they will be taken from the interal
% [1,l]
l = 10;
% number of neighbours
k = 5;

%%% test

% generate feature vectors randomly
x = rand(d, n);
% genrate labels randomly
y = randi(l, [n,1]);

% result using the function to test
gen = getGenNN(x,y,k);

% result computed manually

% result memory pre-allocation
NN = zeros(n, k);

for c = 1:l % for each possible label value
    ic = find(y==c);
    xc = x(:, ic);
    % number of examples labelled as c
    nc = size(xc,2);
    % compute pairwise distances in xc
    Dist = pdist2(xc',xc');
    % ensure that the matrix is symmetric
    assert(all(vec(Dist) == vec(Dist')))

    %FIXME this look could be avoided somehow
    for i = 1:nc % for every example labelled as c
        % get the closest examples
        [~,nn] = sort(Dist(i,:));
        nn = nn(2:k+1);
        nn = ic(nn);
        NN(ic(i), :) = nn;
    end
end

% check the results
for i = 1:n
    assert(all(NN(i,:) == gen(1,gen(2,:)==i)));
end

fprintf('\t[OK]\n')

%% psdProject

%%%TODO
