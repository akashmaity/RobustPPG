%% load data
clear all;


% Load video and landmark information from FaceMesh or any other tracker
video = 'dat\videos\IMG_2940.mov';
filename = 'dat\landmarks\IMG_2940_landmarks.mat';

fileout = 'dat\IMG_2940_processed.mat';

load(filename);

%% (Debug) visualize if the frames and tracker are properly aligned
visualize = 1; % = 0 if saving data and compute PPG
%% define camera parameters used in FaceMesh
N = size(landmarks,1);
vid = VideoReader(video);

images = read(vid,1);
 
w = size(images,2);
h = size(images,1);

focalLength = max(w, h) / tan(60.0 * pi / 180 / 2) / 2;
% focalLength = min(w, h) / tan(40.0 * pi / 180 / 2) / 2;

principle_points = [w / 2; h / 2];

TM = [squeeze(tm(1,:,:,:)); [0 0 0 1]];
npoints = size(landmarks,2);



%% Preprocess triangles from FaceMesh, remove traingles in boundary, eye, removal %%
frame0 = images;
l = horzcat(squeeze(landmarks(1,:,:)), ones(npoints,1));
points = TM*l';

factor = 1 ./ points(3,:);
p = ([-points(1,:) * focalLength; points(2,:) * focalLength]) .* factor + principle_points;
T_init = delaunayTriangulation(p(1,:)',p(2,:)');

C = convexHull(T_init);
T_init.Points(C,:) = [];
points(:,C) = [];

left_eye = squeeze(features(1,37:42,:));
BW_l = poly2mask(left_eye(:,1),left_eye(:,2),h,w);

right_eye = squeeze(features(1,43:48,:));
BW_r = poly2mask(right_eye(:,1),right_eye(:,2),h,w);

lips = squeeze(features(1,49:60,:));
BW_lp = poly2mask(lips(:,1),lips(:,2),h,w);

BW_mask = BW_r+BW_l+BW_lp;
[r,c] = find(BW_mask);

% pixels = hair_removal(T_init, frame);

ID = unique(pointLocation(T_init,c,r));
dt = T_init.ConnectivityList;
dt(ID,:) = [];

% remove hair

T_ref = triangulation(dt,T_init.Points);
[init_PPG] = process(T_ref,frame0,length(T_ref.ConnectivityList));
[~, index] = sort(init_PPG);
id_hair = index(1:ceil(0.15*length(init_PPG)));
dt = T_ref.ConnectivityList;
dt(id_hair,:) = [];

T_ref = triangulation(dt,T_init.Points);
triplot(T_ref);

%% Process frames
   
for i = 1:N
    i
    frame = read(vid,i);

    TM = [squeeze(tm(i,:,:,:)); [0 0 0 1]];
    
    l = horzcat(squeeze(landmarks(i,:,:)), ones(npoints,1));
    points = TM*l';
    factor = 1 ./ points(3,:);
    p = ([-points(1,:) * focalLength; points(2,:) * focalLength]) .* factor + principle_points;
    p = p';
    
    % Remove boundary triangles
    p(C,:) = [];
    points(:,C) = [];
    
    % Create triangulation with init Connectivity List
    TR = triangulation(T_ref.ConnectivityList,p(:,1),p(:,2));
    Ts{i} = TR;
    ctr(:,:,i) = incenter(TR);
    
    % Create triangulation for surface normals
    T_normal = triangulation(T_ref.ConnectivityList,points(1,:)',points(2,:)',points(3,:)');
    points_4d(:,:,i) = incenter(T_normal);
    
    F(:,:,i) = -faceNormal(T_normal);
    V(:,:,i) = -points_4d(:,:,i);
    T_n{i} = T_normal;
%     trisurf(T_normal);
%     pause(0.033);
        
    % Process data 
    if(~visualize)
        [PPG(:,:,i),PPG_mean(i),N_px(:,i)] = process(TR,frame,length(T_ref.ConnectivityList));
    end
    
%% Display
      if(visualize)
        im = imshow(frame);
        set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

        hold on
        triplot(TR);
        pause(0.033); 
%         fr = getframe(gcf);
%         writeVideo(outputVideo, fr);
      end
end
% close(outputVideo);

filename
fileout
save(fileout,'Ts','PPG','PPG_mean','ctr','frame0','V','F','points_4d','T_normal','fnames','tri_area');


%% utilities
function [ppg,ppg_mean,n_px] = process(TR, frame,ntri)
    coordmin = floor([min(TR.Points(:,1)) min(TR.Points(:,2))]);
    coordmax = floor([max(TR.Points(:,1)) max(TR.Points(:,2))]);
    w = size(frame,2);
    h = size(frame,1);
    x = max(1,coordmin(1)):min(coordmax(1),w);
    y = max(1,coordmin(2)):min(coordmax(2),h);
%     x = 1:w;
%     y = 1:h;
    [Y,X] = meshgrid(y,x);
    c=cat(2,X',Y');
    d=reshape(c,[],2);
    
%     ID = pointLocation(TR,d(:,1),d(:,2));
%     tic
    ID = pointLocation(TR,d(:,1),d(:,2));
%     toc

    triID = unique(ID(~isnan(ID)));
    frame_cropped = imcrop(frame,[coordmin(1), coordmin(2), coordmax(1)-coordmin(1),coordmax(2)-coordmin(2)]); 

    r = frame_cropped(:,:,1);
    g = frame_cropped(:,:,2);
    b = frame_cropped(:,:,3);
    ppg = nan(ntri,3);
    n_px = nan(ntri,1);
    
    t = ones(size(r(:)));
    n_px(triID,:) = grpstats(t,ID(:),'sum');
    
    pmeanr = grpstats(r(:),ID(:),'mean');
    pmeang = grpstats(g(:),ID(:),'mean');
    pmeanb = grpstats(b(:),ID(:),'mean');
    ppg(triID,:) = [pmeanr pmeang pmeanb];
    
    ind = find(~isnan(ID));
    xd = d(ind,1);
    yd = d(ind,2);
    ch = frame(:,:,2);
    BW=zeros(size(ch));
    BW( sub2ind( size(BW), yd, xd ) ) = 1;
%     imshow(im2double(ch).*BW);
    ppg_mean = mean2(ch(BW>0));
    
end
