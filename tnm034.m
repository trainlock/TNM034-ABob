%%%%%%%%%%%%%%%%%%%%%%%%%% 
function strout = tnm034(im) 
% 
% Im: Inputimage of captured sheet music. Im should be in
% double format, normalized to the interval [0,1] 
% strout: The resulting character string of the detected 
% notes. The string must follow a pre-defined format. 

format compact
filename = './Images_Training/im1s.jpg';
im = imread(filename);
im = rgb2gray(im);

%% Preprocessing I: Fix camera images to scanned quality

%% Preprocessing II: Clean preprocessed image
% Rotate image, find and remove lines and clip image to subimages

% Invertera from white to black
% Threshold to binary image
% Function returns the a rotated version of the original image (double) 
% and a rotated binary image. 
% Make binary and invert (0->1, 1->0)
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
    
    % SEGMENTATION
    
    % find separate objects and stats
    CC = bwconncomp(BW_subIms(:,:,subIm));
    STATS = regionprops(CC, 'Area', 'BoundingBox', 'Centroid', 'Orientation');
    
    % Get matrices for different stats
    areas = cat(1,STATS.Area);
    boundingboxes = cat(1, STATS.BoundingBox);

    % Filter on area to remove small objects
    % OBS! Broken objects will be removed
    [BW_subNSO,keptId] = removeSmallObj(BW_subIms(:,:,subIm),areas, boundingboxes);
    

end % TODO: extend loop to include classification and writing pitch



% Search for "interesting" parts in the image. 
% Apply Sobel-filter to find gradient and the change in the image. 
% Make objects easier to find using opening
% Opening with discs help find note heads, opening with horisontal
% lemenents help find stems

% When separate objects are found, make sure that they are in a correct
% order where they are read horisontally, according to lines. 


%% Classification

% Template matching with normxcorr2(TEMPLATE, A)


% Local vertical/horisontal projection to find flags (or not)
% Local vertical projection to find bars


% bwlabel for classification, new bwconncomp instead of bwlabel
% Labeling sets so that each object have its unique label


% Regionprops, centroid and eulernumber
% Centroid returns center of mass of the region
% EulerNumber returns 1 if no hole is found in the object and 0 if
% a hole exists. 

%% Pitch

% See if object is interesting and then find the pitch for it. 
% Add pitch to strout. Write from left to right (line). 
% fourth = A, eigth = a

strout = 'hej';

%%%%%%%%%%%%%%%%%%%%%%%%%%

