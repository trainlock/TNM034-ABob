format compact
filename = './Images_Training/im3s.jpg';
im = imread(filename);
im = rgb2gray(im);

% Rotate image, find and remove lines and clip image to subimages

% Invertera from white to black
% Threshold to binary image
% Function returns the a rotated version of the original image (double) 
% and a rotated binary image. 
% Make binary and invert (0->1, 1->0)
[BW, im] = invertAndRotate(im);

% Find lines and these save row indices
lineIndices = findLineIndices(BW);

% Create subimages containing one row each
subIms = createSubImages(im, lineIndices);

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

%% For each sub-image: identify note head and its pitch

centerLine = lineIndices(3);
avgLineDist = (lineIndices(end)-lineIndices(1))/(length(lineIndices)-1);
pitchDist = floor(avgLineDist/2);

encoding = ["g1",'a1','b1','c2','d2','e2','f2','g2','a2','b2','c3','d3','e3','f3','g3','a3','b3','c4','d4','e4'];
positions = int8(centerLine+9*pitchDist: -pitchDist : centerLine-10*pitchDist);

% OBS! Might want to compute and use line width and sompute distance
% between lines differently...

% TEST: draw line positions
% im_test = subIms(:,:,1);
% RGB = cat(3,im_test,im_test,im_test);
% RGB(positions(2:2:end), :, 1) = 255;
% figure
% imshow(RGB);

%%

res = ''; % empty string for result
for i = 1:size(BW_subIms,3)
    
    currentIm = BW_subIms(:,:,i);
    
    % first remove the thick beams using opening
    IM = imopen(currentIm,strel('rectangle',[4,10]));
    IM = currentIm-IM;
    % Opening with ciruclar (disk) structuring element to get heads
    IM = imopen(IM,strel('disk',4));
    
    % Find the note head positions (centroids of objects in IM)
    L = bwlabel(IM);
    s = regionprops(L,'centroid');
    heads = cat(1, s.Centroid);
    
    % TEST: Show the centroids
%     figure
%     imshow(currentIm)
%     hold on
%     plot(heads(:,1),heads(:,2), 'b*')
%     hold off
    
    % For each centroid, encode the pitch
    for j = 1:length(heads)
        c_row = heads(j,2);  % col 2 = y = row
        [c index] = min(abs(c_row-positions)); % find closest possible pitch pos
        res = [res, encoding(index)];
    end
    
    res = [res, 'n'];
    
    % OBS!!! The lines are not fully horizontal, so the patch is encoded
    % incorrectly several times :( 
    % TODO: Fix this!!!
end