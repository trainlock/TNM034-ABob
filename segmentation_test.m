%% Test segmentation!
% But first do the all preprocessing before segmentation (27 nov)

format compact
filename = './Images_Training/im9s.jpg';
im = imread(filename);
im = rgb2gray(im);

[BW, im2] = invertAndRotate(im);

% Find lines and these save row indices
lineIndices = findLineIndices(BW);

% Create subimages containing one row each
subIms = createSubImages(im2, lineIndices);

% Compute level to use for thresholding
level = graythresh(subIms); 

% Put all sub images in one image and compute new line indices
subIms_aligned = reshape(subIms, size(subIms,1), [], 1);
BW_aligned = im2bw(subIms_aligned, level);
lineIndices = findLineIndices(BW_aligned);

% Create subimages without lines (binary)
BW_subIms = false(size(subIms));
for i = 1:size(subIms,3)
    % binarize subimage
    BW_subIms(:,:,i) = im2bw(subIms(:, :, i), level);
    % Remove lines
    BW_subIms(:,:,i) = removeLines(BW_subIms(:,:,i));
end


%% Segmentation 

for subIm = 1:size(BW_subIms,3)
    % find separate objects and stats
    CC = bwconncomp(BW_subIms(:,:,subIm));
    STATS = regionprops(CC, 'Area', 'BoundingBox', 'Centroid', 'Orientation');
    
    % Get matrices for different stats
    areas = cat(1,STATS.Area);
    boundingboxes = cat(1, STATS.BoundingBox);

    % Filter on area to remove small objects
    % OBS! Broken objects will be removed
    [BW_subNSO,keptId] = removeSmallObj(BW_subIms(:,:,subIm),areas, boundingboxes);
    
%% Plots   
    
%     figure(101)
%     imshow(BW_subNSO)
%     figure(100)
%     imshow(BW_subIms(:,:,subIm))
    
%     % Plot subimage with boundingboxes, ignore removed small
%     imshow(BW_subIms(:,:,subIm))
%     hold on;
%     for i = 1:size(boundingboxes,1)
%           if keptId(i)
%                 rectangle('Position',boundingboxes(i,:),'EdgeColor','r')
%           end
%     end
%     hold off
    
%     % Display a separate object
%     [r, c] = getBboxIdx(boundingboxes(1,:));
%     noteImg = BW_subIms(r,c,subIm);
%     imshow(noteImg)

end

