function [Xn] = arcsinVST(Xtot)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
n = size(Xtot,2);
Tcnt = sum(Xtot, 2);
%normalization across rows
Xtot = Xtot./repmat(Tcnt,1, n);

Xn = asin(sqrt(Xtot));

end

