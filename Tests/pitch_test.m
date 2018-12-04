format compact
filename = './Images_Training/im1s.jpg';
im = imread(filename);
im = rgb2gray(im);
%im = imresize(im,1.8); % scale image (bicubic interpolation by default)

% Rotate image, find and remove lines and clip image to subimages

% Invertera from white to black
% Threshold to binary image
% Function returns the a rotated version of the original image (double) 
% and a rotated binary image. 
% Make binary and invert (0->1, 1->0)
[BW, im] = invertAndRotate(im);

% Compute distances n (line width) and d (line distance)
[d, n] = computeStaffMetrics(BW);

% Find lines and these save row indices
lineIndices = findLineIndices(BW);

% Create subimages containing one row each
subIms = createSubImages(im, lineIndices);

% TEST: draw line positions
% RGB = cat(3,im,im,im);
% RGB(lineIndices, :, 1) = 255;
% figure
% imshow(RGB);
%%
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
end

% TEST: draw line positions
% im_test = subIms(:,:,1);
% RGB = cat(3,im_test,im_test,im_test);
% RGB(lineIndices, :, 1) = 255;
% figure
% imshow(RGB);

%% For each sub-image: identify note head and its pitch

centerLine = lineIndices(3);
avgLineDist = (lineIndices(end)-lineIndices(1))/(length(lineIndices)-1);
pitchDist = avgLineDist/2;

encoding = ['g1'; 'a1'; 'b1'; 'c2'; 'd2'; 'e2'; 'f2'; 'g2'; 'a2'; 'b2'; 'c3'; 'd3'; 'e3'; 'f3'; 'g3'; 'a3'; 'b3'; 'c4'; 'd4'; 'e4'];
encoding = transpose(encoding);
positions = round(centerLine+9*pitchDist: -pitchDist : centerLine-10*pitchDist);

% TEST: draw line positions
im_test = subIms(:,:,1);
RGB = cat(3,im_test,im_test,im_test);
RGB(positions, :, 1) = 255;
RGB(centerLine, :, 2) = 255;
figure
imshow(RGB);

%%
res = ''; % empty string for result
for i = 1:size(BW_subIms,3)
    
    currentIm = BW_subIms(:,:,i);
    
    heads = findNoteHeads(currentIm, d);
    
    % TEST: Show the centroids
    if(length(heads) > 1)
        figure
        imshow(currentIm)
        hold on
        plot(heads(:,1),heads(:,2), 'b*')
        hold off
    end
    
    % For each centroid, encode the pitch
    for j = 1:length(heads)
        c_row = heads(j,2);  % col 2 = y = row
        diff = abs(c_row-positions);
        [c index] = min(diff); % find closest possible pitch pos
        res = [res, strcat(encoding(1,index), encoding(2,index))];
    end
    
    res = [res, 'n'];
    
end