% Read image
filename = '././Images_Training/im10s.jpg';
im = imread(filename);
imshow(im)

[im_BW, im] = invertAndRotate(im);

% Test 1: Opening with ciruclar (disc) structuring element
SE = strel('disk',4); % Structuring element
J = imopen(im_BW,SE);

% Find the centroids (center positions of the heads)
L = bwlabel(J);
s = regionprops(L,'centroid');
centroids = cat(1, s.Centroid);

imshow(im_BW)
hold on
plot(centroids(:,1),centroids(:,2), 'b*')
hold off

% figure
% subplot(2,1,1)
% imshow(J)
% subplot(2,1,2)
% imshow(im_BW)







