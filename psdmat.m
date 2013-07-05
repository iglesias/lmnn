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
Delta = diag(Delta(idxs));
% re-arrange eigenvectors according to that order
V = V(:,idxs);
% project onto the matrix Q onto the PSD cone
Q = V*Delta*D';