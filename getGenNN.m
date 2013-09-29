function gen = getGenNN(x,y,k)
%
% TODO DOC
%
% Extracted from LMNN Version 2.3 by Kilian Q. Weinbergerr (2005)

%%% check input

% get number of examples from data
[~, n] = size(x);

%%%

% possible label values
un = unique(y);
% target neighbours memory pre-allocation
Gnn = zeros(k,n);

% target neighbours computation
for c = un  % for every label value c
    fprintf('%i nearest genuine neighbors for class %i:',k,c);
    % get the indices of the examples with the same label c
    i = find(y==c);
    % kNN using examples labelled as c
    nn = kNN(x(:,i), x(:,i), 2:k+1);
    % fill in the solution
    Gnn(:,i) = i(nn);
    fprintf('\r');
end;

fprintf('\n');
% re-arrange solution
gen1 = vec(Gnn(1:k,:)')';
gen2 = vec(repmat(1:n,k,1)')';
gen = [gen1;gen2];

function NN = kNN(x1,x2,ks)
%
% TODO DOC
%
% Extracted from LMNN Version 2.3 by Kilian Q. Weinberger (2005)

% size of the batch used for the batch computation
B = 750;
% get number of examples in x2
[~, n] = size(x2);
% nearest neighbours memory pre-allocation
NN = zeros(length(ks),n);

% nearest neighbours computation
for i = 1:B:n
    % adjust the numbers of examples to use in this iteration, required for
    % the last batch
    BB = min(B,n-i);
    fprintf('.');
    % compute pairwise squared distances between x1 and the batch in x2
    Dist = distance(x1, x2(:,i:i+BB));
    fprintf('.');
    % get the indices of the max(ks) nearest neighbours for each example in
    % the batch
    [~, nn] = sort(Dist);
    nn = nn(1:max(ks),:);
    clear('Dist');
    fprintf('.');
    % fill in the solution
    NN(:,i:i+BB) = nn(ks,:);
    clear('nn','dist');
    fprintf('(%i%%) ', round((i+BB)/n*100)); 
end;