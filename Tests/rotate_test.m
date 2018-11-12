% Read image
filename = '././Images_Training/im1s_rotated.jpg';
im = imread(filename);

[im2_BW, im2] = invertAndRotate(im);

figure
subplot(2,1,1)
imshow(im2)
subplot(2,1,2)
imshow(im2_BW)









