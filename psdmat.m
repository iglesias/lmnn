function Q = psdmat(Q)
%
% TODO DOC
%

% compute eigenvectors V and eigenvalues Delta
[V, Delta] = eig(Q);
% ignore the imaginary parts
Delta = real(diag(Delta));
V = real(V);
% ignore negative (very small in practice) eigenvalues
Delta(Delta < 1e-10) = 0;
% eigenvalues positions in descending order
[~, idxs] = sort(-Delta);
% re-arrange eigenvectors and eigenvalues according to that order
V = V(:,idxs);
Delta = Delta(idxs);
% project onto the matrix Q onto the PSD cone
Q = V*diag(Delta)*V';
%%% L = (V*diag(sqrt(Delta)))';