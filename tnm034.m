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

% Position of heads if any (can be array)
% Duration
% Interesting or not?

clear sNotes
clear resultingStruct
sNotes = struct('headPos', {}, 'type', {});

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

% Compute distances n (line width) and d (line distance)
[d, n] = computeStaffMetrics(BW);

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
    BW_subIms(:,:,i) = removeLines(BW_subIms(:,:,i), d);
    % Try to fix some possibly broken objects
    BW_subIms(:,:,i) = bwmorph(BW_subIms(:,:,i), 'close');
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

    % Filter on area and height to remove small objects
    % OBS! Broken objects will be removed
    [BW_subNSO,keptId] = removeSmallObj(BW_subIms(:,:,subIm),areas, boundingboxes, d);
    
    for i = 1:size(boundingboxes)
        % 2-3+5-6 = large object, 10+12 = single flag
        bbx = boundingboxes(i,:); % Tv� noter saknas! De som inte har n�gon flagga!
        [r, c] = getBboxIdx(bbx);
        note = BW_subIms(r,c,subIm);
        [resultingStruct, isEmpty] = classification(note, d);
        if(isEmpty == 0)
            % The resulting array is not quite right...
            sNotes = [sNotes, resultingStruct]; % Add result to a list
        end
        clear resultingStruct
    end
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

% clear sNotes
% clear resultingStruct
% sNotes = struct('headPos', {}, 'type', {});

% for i = 1:size(boundingboxes)
%     % 2-3+5-6 = large object, 10+12 = single flag
%     bbx = boundingboxes(i,:); % Tv� noter saknas! De som inte har n�gon flagga!
%     [r, c] = getBboxIdx(bbx);
%     note = BW_subIms(r,c,subIm);
%     [resultingStruct, isEmpty] = classification(note, d);
%     if(isEmpty == 0)
%         % The resulting array is not quite right...
%         sNotes = [sNotes, resultingStruct]; % Add result to a list
%     end
%     clear resultingStruct
% end

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

