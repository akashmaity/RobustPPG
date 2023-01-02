function ppg = ppg_test(PPG,P_motion,Fs,net)
%% Inputs:
% PPG    : distorted PPG signals 
% P_motion: surface normal directions
% Fs     : camera fps
% net    : trained model

%%Outputs:
% ppg      : filtered ppg signal 

t = size(PPG,3);
ds = designfilt('bandpassfir','FilterOrder',round(t/3-1), ...
         'CutoffFrequency1',0.5,'CutoffFrequency2',5, ...
         'SampleRate',Fs);
%% Extract PPG signal from each triangle     
for i = 1:size(P_motion,2)
    sig = squeeze(PPG(i,:,:));
    sigm = squeeze(P_motion(:,i,:));
    if(any(isnan(sig(:)))||any(isnan(sigm(:)))|all(sig(:)==0))
        ppg(i,:) = nan(1,size(PPG,3));
        continue;
    end

    ppg_lam = squeeze(P_motion(:,i,:));
    ppg_real = squeeze(PPG(i,:,:));
    
    %% Creating S matrix consisting of RGB pixel intensity fluctuations and generated motion signals
    S = [ppg_real;ppg_lam'];
    S_dc = diag(mean(S, 2))^-1*S-1;
    S_filt = filtfilt(ds,S_dc')';
    S_filt = S_filt./std(S_filt')';
    S_filt(isnan(S_filt)) = 0; 
    
    %% Extract PPG signal from each triangle using a trained model
    YPred = predict(net,{S_filt});
    ypred = cell2mat(YPred)';
    ppg(i,:) = (ypred)'.*hann(t)';
    
end

end