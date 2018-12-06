function [BW_filtered, keptIdx] = removeSmallObj(BW, areas, bbs, d)
% Remove small objects by by painting filling boundingboxes
% on objects with too small area

% Out:
% keptIdx - matrix with 1 for kept object indices, 0 for removed
% BW_filtered - image with small objects removed

% In:
% BW - image(2d)
% bbs - boundingboxes regionprop for BW
% areas - area regionprop for BW
% d - distance between two lines, hiven as interval d = [dMin, dMax]

%%
BW_filtered = BW;
keptIdx = true(size(bbs,1),1); 

% Approx. radius of a note head
rad = d(2)/2; 

% Threshold for minimum area to keep (based on area of note head)
areaThresh = round( rad*rad*3.14 * 1.8);

% Threshold for minimum height to keep 
heightThresh = d(2) * 3;

% Loop all separate objects and remove too small or short objects
for i = 1:size(bbs,1)
    height = bbs(i,4); % Get height from bounding box
    if areas(i) < areaThresh || height < heightThresh
        [r,c] = getBboxIdx(bbs(i,:));
        BW_filtered(r,c) = 0; % fill bounding box
        
        keptIdx(i) = 0;
    end
end

% figure
% subplot(2,1,1)
% imshow(BW_filtered)
% subplot(2,1,2)
% imshow(BW)

end

