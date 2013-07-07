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
    Np_Nc = setdiff(Np', Nc', 'rows')';
    Nc_Np = setdiff(Nc', Np', 'rows')';
end


