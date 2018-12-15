%%%%%%%%%%%%%%%%%%%%%%%%%% 
function strout = tnm034(im) 
% 
% Im: Inputimage of captured sheet music. Im should be in
% double format, normalized to the interval [0,1] 
% strout: The resulting character string of the detected 
% notes. The string must follow a pre-defined format. 

im = rgb2gray(im);

%% Struct for symbol
clear sNotes
clear resultingStruct
sNotes = struct('headPos', {}, 'type', {});

%% Preprocessing I: Fix camera images to scanned quality

% TODO: Handle camera images

% Compensate for unsharp images (OBS!  Breaks notes in some images)
% im = imsharpen(im);

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

% Compute distances n (line width) and d (line distance)
[d, n] = computeStaffMetrics(BW);

% Find lines and these save row indices
lineIndices = findLineIndices(BW,d);

% Create subimages containing one row each
subIms = createSubImages(im2, lineIndices);

% Compute level to use for thresholding
level = graythresh(subIms); 

% Put all sub images in one image and compute new line indices
subIms_aligned = reshape(subIms, size(subIms,1), [], 1);
BW_aligned = im2bw(subIms_aligned, level);

% figure
% imshow(BW_aligned)

lineIndices = findLineIndices(BW_aligned,d);


%% Process each subimage 

res = ''; % empty string for result
nrSubIms = size(subIms,3);

for i = 1:nrSubIms
    
    % binarize subimage
    BW_subIm = im2bw(subIms(:, :, i), level);
    
    % For better line removal, recompute n for the subImage
    [d_subIm, n_subIm] = computeStaffMetrics(BW_subIm);
    
    % Remove lines
    BW_subIm = removeLines(BW_subIm, n_subIm); 
    
    % Try to fix some possibly broken objects
    BW_subIm = bwmorph(BW_subIm, 'close');
    BW_subIm = imclose(BW_subIm, strel('line', mean(n_subIm)*3, 90));

%     figure
%     imshow(BW_subIm)
    
    % SEGMENTATION
    
    % find separate objects and stats
    CC = bwconncomp(BW_subIm);
    STATS = regionprops(CC, 'Area', 'BoundingBox', 'Centroid', 'Orientation');
    
    % Get matrices for different stats
    areas = cat(1,STATS.Area);
    boundingboxes = cat(1, STATS.BoundingBox);

    % Filter on area and height to remove small objects
    % OBS! Broken objects will be removed
    [BW_subNSO,keptId] = removeSmallObj(BW_subIm, areas, boundingboxes, d);
    
    % Save interesting objects separately
    interestingBoxes = boundingboxes(keptId,:);
    
    % CLASSIFICATION
    
    % Classify the found interesting objects in the image 
    sNotes = struct('headPos', {}, 'type', {});
    for j = 1:size(interestingBoxes)
        bbx = interestingBoxes(j,:); 
        [resultingStruct, isEmpty] = classification(BW_subNSO, d, bbx);
        if(isEmpty == 0)
            sNotes = [sNotes, resultingStruct]; % Add result to a list
        end
        clear resultingStruct
    end
    
    % TEST - Remember to comment before submission!!!
    % plotClassification(BW_subIm, BW_subNSO, sNotes);
    
    % PITCH AND OUTPUT STRING 
    
    res = [res, determinePitch(sNotes, lineIndices)];
    
    % If not last image, add an 'n' at end of line
    if(i < nrSubIms) 
        res = [res, 'n'];
    end
    
end 

strout = res;

%%%%%%%%%%%%%%%%%%%%%%%%%%

