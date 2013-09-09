load data/digits;

% knn will be performed with values of k \in K
K = [1 3 5 7];
% memory pre-allocation of the classification error (in train and test sets)
KNNERRI = zeros(length(K),2);
LMNNERRI = zeros(length(K),2);
LMNNERRPCA = zeros(length(K),2);
MYLMNNERRI = zeros(length(K),2);

myLmnnTotalTime = 0;
lmnnITotalTime = 0;
lmnnPCATotalTime = 0;

% apply knn and LMNN for several values of k
for i = 1:length(K)
    knnerrI = knnclassifytree(eye(size(xTr,1)),xTr,yTr,xTe,yTe,K(i));
    KNNERRI(i,:) = knnerrI;

    tic
% %         myL = lmnn(xTr,yTr,K(i));
    myL = eye(size(xTr,1));
    myLmnnTotalTime = myLmnnTotalTime + toc;
    mylmnnerrI = knnclassifytree(myL,xTr,yTr,xTe,yTe,K(i));
    MYLMNNERRI(i,:) = mylmnnerrI;

    tic
    LI = lmnn2(xTr,yTr,K(i),eye(size(xTr,1)),'quiet',1);
    lmnnITotalTime = lmnnITotalTime + toc;
    lmnnerrI = knnclassifytree(LI,xTr,yTr,xTe,yTe,K(i));
    LMNNERRI(i,:) = lmnnerrI;
        
    tic
    LPCA = lmnn2(xTr,yTr,K(i),pca(xTr)','quiet',1);
    lmnnPCATotalTime = lmnnPCATotalTime + toc;
    lmnnerrPCA = knnclassifytree(LPCA,xTr,yTr,xTe,yTe,K(i));
    LMNNERRPCA(i,:) = lmnnerrPCA;
end

for i = 1:length(K)
    fprintf('%d-NN Euclidean training error: %2.2f\n', K(i), KNNERRI(i,1)*100);
    fprintf('%d-NN Eclidean test error: %2.2f\n\n', K(i), KNNERRI(i,2)*100);
    
    fprintf('%d-LMNN training error: %2.2f\n', K(i), LMNNERRI(i,1)*100);
    fprintf('%d-LMNN test error: %2.2f\n\n', K(i), LMNNERRI(i,2)*100);
           
    fprintf('%d-LMNN PCA training error: %2.2f\n', K(i), LMNNERRPCA(i,1)*100);
    fprintf('%d-LMNN PCA test error: %2.2f\n\n', K(i), LMNNERRPCA(i,2)*100);
    
    fprintf('My %d-LMNN training error: %2.2f\n', K(i), MYLMNNERRI(i,1)*100);
    fprintf('My %d-LMNN test error: %2.2f\n\n', K(i), MYLMNNERRI(i,2)*100);
end
