%%%%%%%%%%%%%%%%%%%%%%%%%% 
function strout = tnm034(im) 
% 
% Im: Inputimage of captured sheet music. Im should be in
% double format, normalized to the interval [0,1] 
% strout: The resulting character string of the detected 
% notes. The string must follow a pre-defined format. 

format compact
filename = './Images_Training/im3s.jpg';
im = imread(filename);
im = rgb2gray(im);

%% Struct for symbol
clear sNotes
clear resultingStruct
% sNotes = struct('headPos', {}, 'type', {});

%% Preprocessing I: Fix camera images to scanned quality

% Compensate for unsharp images
im = imsharpen(im);

% figure
% imshow(im)

%% Preprocessing II: Clean preprocessed image
% Rotate image, find and remove lines and clip image to subimages

% Invertera from white to black
% Threshold to binary image
% Function returns the a rotated version of the original image (double) 
% and a rotated binary image. 
% Make binary and invert (0->1, 1->0)
[BW, im2] = invertAndRotate(im);

% figure
% imshow(BW)

% Find lines and these save row indices
lineIndices = findLineIndices(BW);

% Compute distances n (line width) and d (line distance)
[d, n] = computeStaffMetrics(BW);

% Create subimages containing one row each
subIms = createSubImages(im2, lineIndices);

% Compute level to use for thresholding
level = graythresh(subIms); 

% Put all sub images in one image and compute new line indices
subIms_aligned = reshape(subIms, size(subIms,1), [], 1);
BW_aligned = im2bw(subIms_aligned, level);

% figure
% imshow(BW_aligned)

lineIndices = findLineIndices(BW_aligned);

% Create subimages without lines (binary)
BW_subIms = false(size(subIms));
for i = 1:size(subIms,3)
    % binarize subimage
    BW_subIms(:,:,i) = im2bw(subIms(:, :, i), level);
    % Remove lines
    BW_subIms(:,:,i) = removeLines(BW_subIms(:,:,i), n); 
    % Try to fix some possibly broken objects
    BW_subIms(:,:,i) = bwmorph(BW_subIms(:,:,i), 'close');
    
%     figure
%     imshow(BW_subIms(:,:,i))
end


%% Process each subimage 

res = ''; % empty string for result

for subIm = 1:size(BW_subIms,3)
    
    % SEGMENTATION
    
    % find separate objects and stats
    CC = bwconncomp(BW_subIms(:,:,subIm));
    STATS = regionprops(CC, 'Area', 'BoundingBox', 'Centroid', 'Orientation');
    
    % Get matrices for different stats
    areas = cat(1,STATS.Area);
    boundingboxes = cat(1, STATS.BoundingBox);

    % Filter on area and height to remove small objects
    % OBS! Broken objects will be removed
    [BW_subNSO,keptId] = removeSmallObj(BW_subIms(:,:,subIm),areas, boundingboxes, d);
    
    interestingBoxes = boundingboxes(keptId,:);
    
    % CLASSIFICATION
    
    % Classify the found objects in the image 
    sNotes = struct('headPos', {}, 'type', {});
    for i = 1:size(interestingBoxes)
        bbx = interestingBoxes(i,:); 
        [resultingStruct, isEmpty] = classification(BW_subNSO, d, bbx);
        if(isEmpty == 0)
            sNotes = [sNotes, resultingStruct]; % Add result to a list
        end
        clear resultingStruct
    end
    
    % PITCH AND OUTPUT STRING 
    
    res = [res, determinePitch(sNotes, lineIndices)];
    
    % At end of line, add an 'n'
    res = [res, 'n'];
    
end 

strout = res;

%%%%%%%%%%%%%%%%%%%%%%%%%%

