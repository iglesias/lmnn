function G = updateGradient(x, Gp, Nc, Np, mu)
%
% TODO DOC
%

% compute the set differences
[Np_Nc, Nc_Np] = diffimp(Np,Nc);

% gradient update
if isempty(Np_Nc) && isempty(Nc_Np)
% %     fprintf('>>>>> in gradient update both are empty\n')
    G = Gp;
elseif isempty(Np_Nc)
% %     fprintf('>>>>> in gradient update Np_Nc is empty\n')
    
    G = Gp + mu*(sumOuterProducts(x, Nc_Np(1,:), Nc_Np(2,:)) - ...
                 sumOuterProducts(x, Nc_Np(1,:), Nc_Np(3,:)));
elseif isempty(Nc_Np)
% %     fprintf('>>>>> in gradient update Nc_Np is empty\n')
    
    G = Gp - mu*(sumOuterProducts(x, Np_Nc(1,:), Np_Nc(2,:)) - ...
                 sumOuterProducts(x, Np_Nc(1,:), Np_Nc(3,:)));
else % none is empty
% %     fprintf('>>>>> in gradient update none are empty\n')
    
    G = Gp - mu*(sumOuterProducts(x, Np_Nc(1,:), Np_Nc(2,:)) - ...
                 sumOuterProducts(x, Np_Nc(1,:), Np_Nc(3,:))) ...
           + mu*(sumOuterProducts(x, Nc_Np(1,:), Nc_Np(2,:)) - ...
                 sumOuterProducts(x, Nc_Np(1,:), Nc_Np(3,:)));
end
