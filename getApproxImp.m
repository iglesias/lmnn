function N = getApproxImp(Lx, Ni, imp)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% here I am just using Kilian's original nomenclature (no real idea what it
% stands for)
g0 = cdist(Lx,imp(1,:),imp(3,:));
g1 = Ni(:,imp(1,:));  

active = g0<g1;
N = imp(:,active);
    
end
