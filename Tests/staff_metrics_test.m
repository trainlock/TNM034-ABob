format compact
filename = './Images_Training/im1s.jpg';
im = imread(filename);
im = rgb2gray(im);

% Rotate image, find and remove lines and clip image to subimages

% Invertera from white to black
% Threshold to binary image
% Function returns the a rotated version of the original image (double) 
% and a rotated binary image. 
% Make binary and invert (0->1, 1->0)
[BW, im2] = invertAndRotate(im);

% Compute distances n (line width) and d (line distance)
[d, n] = compStaffMetrics(BW);

