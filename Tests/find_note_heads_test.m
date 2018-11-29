format compact
filename = './Images_Training/im1s.jpg';
im = imread(filename);
im = rgb2gray(im);

% Invertera from white to black
% Threshold to binary image
% Function returns the a rotated version of the original image (double) 
% and a rotated binary image. 
% Make binary and invert (0->1, 1->0)
[BW, im2] = invertAndRotate(im);

% Find lines and these save row indices
lineIndices = findLineIndices(BW);

% Find the note head positions 

heads = findNoteHeads(BW);

% TEST: Show the result, on top of the image
figure
imshow(BW)
hold on
plot(heads(:,1),heads(:,2), 'b*')
hold off