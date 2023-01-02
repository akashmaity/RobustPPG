clear
addpath('utils/');

% load FaceMesh output file
load('dat\IMG_2940_after20minsPhysicalTraining_processeddata.mat')

tri_area = ones(size(PPG,1),size(PPG,3)); % triangle area from FaceMesh. For phone videos, the triangles are assumed to have equal areas
W_area = tri_area;
normals = F; % surface noraml directions at each triangle and time
rPPG = PPG*256; % motion distorted PPG signals
xy = points_4d; % xy coordinates of each tracked triangle in the Facemesh
    

%% define parameters for processing
window = 120; % time window length
overlap = window/2;
len = 10;
Fs = 30; % sampling frequencey = camera fps
ds = designfilt('bandpassfir','FilterOrder',100, ...
'CutoffFrequency1',0.5,'CutoffFrequency2',5, ...
'SampleRate',Fs); % bandpass filter

%% extract PPG
net = load('models/LSTM_combine_30_2.mat'); % load trained model
net = net.net_c;
[mPPG,msig] = compute_ppg_net(rPPG,normals,window,window/2,Fs,W_area,net); % FaceMesh

%% post process extracted PPG
mPPG(isnan(mPPG)) = [];
mPPG = filtfilt(ds,mPPG);

HR = estimate_HR(mPPG,len,1,Fs);

plot(HR);
figure
[s,f,t]=spectrogram(mPPG,256,240,[0:1/256:5],30,'yaxis');
imagesc(abs(s))
colormap(jet)
set(gca,'Ydir','normal');
