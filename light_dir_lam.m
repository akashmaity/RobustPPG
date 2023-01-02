function [V,rho,lam] = light_dir_lam(PPG, normals, W_area)
order = 9;

%% preprocessing to reject bad triangles for lighting estimation
ppg = PPG;
ppg = permute(ppg,[3 1 2]);
ppg = reshape(ppg, size(ppg,1)*size(ppg,2),size(ppg,3));

W_area = permute(W_area,[2 1]);
W_area = W_area./nansum(W_area,2);
W_area = reshape(W_area, size(W_area,1)*size(W_area,2),size(W_area,3));

% W = weights.*W_area;
W = W_area;
normals = permute(normals,[3 1 2]);
normals = reshape(normals, size(normals,1)*size(normals,2),size(normals,3));
N_init = normals;

R = 1:length(ppg);
[r,c] = find(isnan(ppg));
% c = setdiff(R, r);
ppg(r,:) = [];
normals(r,:) = [];
W(r,:) = [];

% exclude bad signals
[r,c] = find(ppg<2);
c = setdiff(R, r);
ppg(r,:) = [];
normals(r,:) = [];
W(r,:) = [];

[r,c] = find(isnan(normals));
ppg(r,:) = [];
normals(r,:) = [];
W(r,:) = [];

[r,c] = find(isnan(W));
ppg(r,:) = [];
normals(r,:) = [];
W(r,:) = [];
%% creating basis vectors for spherical harmonics
B = createB(normals);
B_init = createB(N_init);

%% Estimate lighting and skin lighting matrix
V = (W.*B')\(W.*ppg); % weighted regresion
%% Rendsering
lam = B_init(1:order,:)'*V(1:order,:);
lam = reshape(lam,size(PPG,3),size(PPG,1),size(PPG,2)); % rendered face pixel intensity

rho = vecnorm(V);
rho = rho./sqrt(dot(rho,rho));
rho = rho';

end