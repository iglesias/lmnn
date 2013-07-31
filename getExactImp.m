function N = getExactImp(Lx, Ni, y, gen, k)

% initialize impostors set
N = [];
% get a vector with unique label values
un = unique(y);
% shorthand for the number of examples
n = size(Lx,2);

for i = un(1:end-1) % for each label value except from the largest one
    % get the indices of the examples labelled as i
    iIdxs = find(y==i);
    % get the indices of the examples that have a larger label value, only
    % larger ones to compute every pair of distances only once
    oIdxs = find(y>i);

    % pairwise squares distance
    Dist = distance(Lx(:,iIdxs), Lx(:,oIdxs));

    for j = 1:k % for every target neighbor
        % elements in the matrix that are less than the distance plus margin
        % to target neighbors
        imp1 = find(bsxfun(@le, Dist, Ni(j,iIdxs)'))';
        % from linear matrix index, to (i,j) indexing
        [a,b] = ind2sub(size(Dist), imp1);
        % update impostors set
        N = [N [iIdxs(a); gen(1, (j-1)*n+iIdxs(a)); oIdxs(b)]];

        % same as above but being examples in Idxs possible impostors
        imp2 = find(bsxfun(@le, Dist, Ni(j,oIdxs)))';
        [a,b] = ind2sub(size(Dist), imp2);
        N = [N [oIdxs(b); gen(1, (j-1)*n+oIdxs(b)); iIdxs(a)]];
    end
end
