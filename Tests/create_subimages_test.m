% Read image
filename = '././Images_Training/im1s.jpg';
im = imread(filename);
im = rgb2gray(im);

[BW, im] = invertAndRotate(im);

lineIndices = findLineIndices(BW);

subImages = createSubImages(im, lineIndices);

% show result!
figure
montage(subImages,'size',[1 NaN]);
