echo off;
clear all;
clc;
cd mLMNN2.3
setpaths
fprintf('Loading data ...\n');
load('data/digits.mat');
cd ..

n = 200;
xTr = xTr(:,1:n);
yTr = yTr(1:n);

k = 3;

myL = lmnn(xTr,yTr,k);
knnerrMyL=knnclassifytree(myL,xTr,yTr,xTe,yTe,k);
fprintf('%d-NN my LMNN training error: %2.2f\n', k, knnerrMyL(1)*100);
fprintf('%d-NN my LMNN testing error: %2.2f\n', k, knnerrMyL(2)*100);

[L,Det] = lmnn2(xTr,yTr,k,'maxiter',500,'checkup',0,'quiet',0,'correction',1);
knnerrL=knnclassifytree(L,xTr,yTr,xTe,yTe,k);
fprintf('%d-NN Mahalanobis training error: %2.2f\n', k, knnerrL(1)*100);
fprintf('%d-NN Mahalanobis testing error: %2.2f\n', k, knnerrL(2)*100);

knnerrI=knnclassifytree(eye(size(xTr,1)),xTr,yTr,xTe,yTe,k);
fprintf('%d-NN Euclidean training error: %2.2f\n', k, knnerrI(1)*100);
fprintf('%d-NN Euclidean testing error: %2.2f\n', k, knnerrI(2)*100);