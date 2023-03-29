function BW = visualize_weights(weights,TR,frame)
    
    w = size(frame,2);
    h = size(frame,1);

    x = 1:w;
    y = 1:h;
    
    [Y,X] = meshgrid(y,x);
    c=cat(2,X',Y');
    d=reshape(c,[],2);
    ID = pointLocation(TR,d(:,1),d(:,2));
    BW = zeros(h,w);
    IDn = unique(ID,'stable');
    BW(~isnan(ID)) = weights(ID(~isnan(ID)));
end