load data/wine.data;

% separate labels and features from the data
% the labels appear in the first column
y = wine(:,1);
fprintf('There are %d different classes.\n', length(unique(y)))
x = wine(:,2:end);

% feature normalization
x = (x - repmat(min(x), size(x,1), 1)) ./ ...
    (repmat(max(x), size(x,1), 1) - repmat(min(x), size(x,1), 1));

assert(all(max(x) <= 1) && all(min(x) >= 0))

% transpose both features and labels since the LMNN and KNN expect the
% features as (#featuress x #examples) and the labels (1 x #examples)
x = x';
y = y';

% repeat n times the process of data separation and testing
n = 5;
% knn will be performed with values of k \in K
K = [3];
% memory pre-allocation of the classification error (in train and test sets)
KNNERRI = zeros(length(K),n,2);
LMNNERRI = zeros(length(K),n,2);
LMNNERRPCA = zeros(length(K),n,2);
MYLMNNERRI = zeros(length(K),n,2);

myLmnnTotalTime = 0;
lmnnITotalTime = 0;
lmnnPCATotalTime = 0;

for i = 1:n
    % separate data into test and training sets
    % (approximate) ratio of examples that belong to the training set
    ratio = 0.7;
    % pick the examples that will be in each set randomly
    rp = randperm(size(x,2));
    trainIdxs = rp(1:floor(ratio*length(rp)));
    testIdxs = rp(floor(ratio*length(rp))+1:end);

    xTr = x(:, trainIdxs);
    xTe = x(:, testIdxs);
    assert(size(x,2) == size(xTr,2)+size(xTe,2))

    yTr = y(trainIdxs);
    yTe = y(testIdxs);

    % apply knn and LMNN for several values of k
    for j = 1:length(K)
        knnerrI = knnclassifytree(eye(size(xTr,1)),xTr,yTr,xTe,yTe,K(j));
        KNNERRI(j,i,:) = knnerrI;
        
        tic
        myL = lmnn(xTr,yTr,K(j));
% %         myL = eye(size(xTr,1));
        myLmnnTotalTime = myLmnnTotalTime + toc;
        
        mylmnnerrI = knnclassifytree(myL,xTr,yTr,xTe,yTe,K(j));
        MYLMNNERRI(j,i,:) = mylmnnerrI;
        
        tic
        L = lmnn2(xTr,yTr,K(j),eye(size(xTr,1)),1000,'quiet',1);
        lmnnITotalTime = lmnnITotalTime + toc;
        lmnnerrI = knnclassifytree(L,xTr,yTr,xTe,yTe,K(j));
        LMNNERRI(j,i,:) = lmnnerrI;
        
        tic
        L = lmnn2(xTr,yTr,K(j),pca(x)',1000,'quiet',1);
        lmnnPCATotalTime = lmnnPCATotalTime + toc;
        lmnnerrPCA = knnclassifytree(L,xTr,yTr,xTe,yTe,K(j));
        LMNNERRPCA(j,i,:) = lmnnerrPCA;
    end
    
end

for j = 1:length(K)
    avgKnnErr = mean(KNNERRI(j,:,:), 2);
    fprintf('%d-NN Euclidean training error: %2.2f\n', K(j), avgKnnErr(1)*100);
    fprintf('%d-NN Eclidean test error: %2.2f\n\n', K(j), avgKnnErr(2)*100);
    
    avgLmnnIErr = mean(LMNNERRI(j,:,:), 2);
    fprintf('%d-LMNN training error: %2.2f\n', K(j), avgLmnnIErr(1)*100);
    fprintf('%d-LMNN test error: %2.2f\n\n', K(j), avgLmnnIErr(2)*100);
           
    avgLmnnPCAErr = mean(LMNNERRPCA(j,:,:), 2);
    fprintf('%d-LMNN PCA training error: %2.2f\n', K(j), avgLmnnPCAErr(1)*100);
    fprintf('%d-LMNN PCA test error: %2.2f\n\n', K(j), avgLmnnPCAErr(2)*100);
    
    avgMyLmnnErr = mean(MYLMNNERRI(j,:,:), 2);
    fprintf('My %d-LMNN training error: %2.2f\n', K(j), avgMyLmnnErr(1)*100);
    fprintf('My %d-LMNN test error: %2.2f\n\n', K(j), avgMyLmnnErr(2)*100);
end
