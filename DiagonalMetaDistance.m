% load one of the synthetic data sets from MetaDistance
load data/NBData20;

%% perform the same pre-processing and data preparation done in their code
%  in (file simdriv)
Y = Y20;
X = X20;
Xn = arcsinVST(X);

J1 = find(Y==1);
J2 = find(Y==2);
J3 = find(Y==3);
J4 = find(Y==4);
J5 = find(Y==5);

Xn1 = Xn(J1,:);
Xn2 = Xn(J2,:);
Xn3 = Xn(J3,:);
Xn4 = Xn(J4,:);
Xn5 = Xn(J5,:);

n = size(Xn1,1);

%for i =1:100,
Xn1 = Xn1(randperm(n), :);
Xn2 = Xn2(randperm(n), :);
Xn3 = Xn3(randperm(n),:);
Xn4 = Xn4(randperm(n),:);
Xn5 = Xn5(randperm(n),:);

xTr = [Xn1(1:ceil(n/2),:); Xn2(1:ceil(n/2),:); Xn3(1:ceil(n/2),:); Xn4(1:ceil(n/2),:); Xn5(1:ceil(n/2),:) ];
yTr = [ones(ceil(n/2),1); 2*ones(ceil(n/2),1); 3*ones(ceil(n/2), 1); 4*ones(ceil(n/2), 1); 5*ones(ceil(n/2), 1)];

xTe = [ Xn1(ceil(n/2)+1:n, :); Xn2(ceil(n/2)+1:n, :); Xn3(ceil(n/2)+1:n, :); Xn4(ceil(n/2)+1:n, :); Xn5(ceil(n/2)+1:n,:)];
yTe = [ones(n-ceil(n/2), 1); 2*ones(n-ceil(n/2), 1); 3*ones(n-ceil(n/2),1); 4*ones(n-ceil(n/2), 1); 5*ones(n-ceil(n/2), 1)];


%% apply LMNN

% transpose the data (different convention in MetaDistance and LMNN)
xTr = xTr';
yTr = yTr';
xTe = xTe';
yTe = yTe';

xTr = xTr(1:100,:);
xTe = xTe(1:100,:);

k = 1;
L = diagonallmnn(xTr,yTr,k,'diagonal',true,'maxiter',1000);
knnclassifytree(L,xTr,yTr,xTe,yTe,k)
