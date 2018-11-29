function [BW_filtered, keptIdx] = removeSmallObj(BW,areas, bbs)
% Remove small objects by by painting filling boundingboxes
% on objects with too small area

% Out:
% keptIdx - matrix with 1 for kept object indices, 0 for removed
% BW_filtered - image with small objects removed

% In:
% BW - image(2d)
% bbs - boundingboxes regionprop for BW
% areas - area regionprop for BW

 %%
BW_filtered = BW;
keptIdx = true(size(bbs,1),1); 

% Use the height of BW as it is connected to the height of linegroups
thresh = size(BW,1)*1.3;


% Loop all separate objects and find small
for i = 1:size(bbs,1)
    if areas(i) < thresh
        [r,c] = getBboxIdx(bbs(i,:));
        BW_filtered(r,c) = 0; % fill bounding box
        
        keptIdx(i) = 0;
    end
end

% figure('Filtered image')
% imshow(BW_filtered)
% figure('Original image')
% imshow(BW)
end

