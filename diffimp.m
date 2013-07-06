function [Np_Nc, Nc_Np] = diffimp(Np, Nc)
%
% TODO DOC
%

if isempty(Np)
    Np_Nc = [];
    Nc_Np = Nc;
elseif isempty(Nc)
    Np_Nc = Np;
    Nc_Np = [];
else
    %FIXME for the time being, let us use a dirty trick to transform the
    % triplets of impostors. Nc and Np are matrices with three rows and
    % number of columns equal to the number of impostors they contain.
    % Exploiting the fact that the labels are in [1,9], transform
    % these triplets into integers by doing [1;2;3] -> 123; i.e., first
    % row times 100 plus second row times 10 plus third row
    Nc = 100*Nc(1,:) + 10*Nc(2,:) + Nc(3,:);
    Np = 100*Np(1,:) + 10*Np(2,:) + Np(3,:);

    % compute set differences
    Np_Nc = setdiff(Np, Nc);
    Nc_Np = setdiff(Nc, Np);

    % undo the change in the first step
    Np_Nc1 = floor(Np_Nc/100);
    Np_Nc2 = floor(rem(Np_Nc,100)/10);
    Np_Nc3 = rem(Np_Nc, 10);

    Np_Nc = [Np_Nc1; Np_Nc2; Np_Nc3];

    Nc_Np1 = floor(Nc_Np/100);
    Nc_Np2 = floor(rem(Nc_Np,100)/10);
    Nc_Np3 = rem(Nc_Np, 10);

    Nc_Np = [Nc_Np1; Nc_Np2; Nc_Np3];
end


