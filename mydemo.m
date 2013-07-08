echo off;
clear all;
clc;
rand('seed',1);
setpaths
fprintf('Loading data ...\n');
load('mLMNN2.3/data/digits.mat');

xTr = xTr(:,1:100);
yTr = yTr(:,1:100);

k = 1;

M = lmnn(xTr,yTr,k); myL = sqrtm(M);
[L,Det] = lmnn2(xTr,yTr,k,'maxiter',500,'checkup',0,'quiet',0);

knnerrMyL=knnclassifytree(myL,xTr,yTr,xTe,yTe,k);
knnerrL=knnclassifytree(L,xTr,yTr,xTe,yTe,k);
knnerrI=knnclassifytree(eye(size(xTr,1)),xTr,yTr,xTe,yTe,k);

fprintf('1-NN Euclidean training error: %2.2f\n',knnerrI(1)*100);
fprintf('1-NN Euclidean testing error: %2.2f\n',knnerrI(2)*100);

fprintf('1-NN Mahalanobis training error: %2.2f\n',knnerrL(1)*100);
fprintf('1-NN Mahalanobis testing error: %2.2f\n',knnerrL(2)*100);

fprintf('1-NN my LMNN training error: %2.2f\n',knnerrMyL(1)*100);
fprintf('1-NN my LMNN testing error: %2.2f\n',knnerrMyL(2)*100);