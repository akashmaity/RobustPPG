
function [x,msig] = compute_ppg_net(PPG,F,t,overlap,Fs,W_area,net)

%% Inputs:
% PPG    : distorted PPG signals 
% F      : surface normal directions
% t      : window length (in samples)
% overlap: overlap length (in samples)
% Fs     : camera fps
% W_area : traingle area (in pixels)
% net    : trained model

%%Outputs:
% x      : filtered ppg signal 
% msig   : generated motion signals
%% Algorithm--
% 1. Estimate lighting/calibration matrix by least square for every 't' frame
% 2. Use the synthetic lmotion signal to extract PPG signal

i = 1;

ppg=nan(1,size(PPG,3));
ind1 = (i-1)*overlap+1;
ind2 = ind1 + t-1;
while ind2 <=size(PPG,3)
    ppg(i,:) = nan(1,size(PPG,3));

    %% Step 1: Inverse rendering to simulate motion signals
    % V: lighting and albedo matrix
    % rho: skin albedo
    % lam: synthetic motion signals from each triangle
    [V,rho,lam] = light_dir_lam(squeeze(PPG(:,:,ind1:ind2)),squeeze(F(:,:,ind1:ind2)),W_area(:,ind1:ind2));

    e = estimate_strength(rho);
    e = [0.2257    0.9248    0.3063]; % for best results
    msig(ind1:ind2,:,:) = lam;

    %% Step 2: Extract PPG signals by using motion signals and distorted PPG
    pf = ppg_test(PPG(:,:,ind1:ind2),lam,Fs,net);
    pf_n = pf.*W_area(:,ind1:ind2)./nansum(W_area(:,ind1:ind2));
    
    %% Rejecting bad triangles 
    [r,c] = find(isnan(pf_n));
    pf_n(r,:) = [];
    lam(:,r,:) = [];
    ppg(i,ind1:ind2) = nanmean(pf_n);
    
    %%
    i = i+1;
    ind1 = (i-1)*overlap+1;
    ind2 = ind1 + t-1;
end

%% Extracted PPG is sum of PPG from all the triangles
if(size(ppg,1)==1)
    x = ppg;
else    
    x = nanmean(ppg);
end
end