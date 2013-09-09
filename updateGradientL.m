function G = updateGradientL(x, L, Lp, sopgen, Gp, N, mu)
%
% TODO DOC
%

% initialize gradient to the last one computed
G = Gp;
% substract the previous target neighbours component
G = G - (1-mu)*2*Lp*sopgen;
% and add the current component
G = G + (1-mu)*2*L*sopgen;

sopij = sumOuterProducts(x,N(1,:),N(2,:));
sopil = sumOuterProducts(x,N(1,:),N(3,:));
G = G + mu*(1+2*L*(sopij-sopil));
