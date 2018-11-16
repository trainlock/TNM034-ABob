%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [res_bw,res] = invertAndRotate(im)
%INVERTANDROTATEIMG Rotate image, so staff lines are horizontal
%  im: input image
%
%  res_bw: the resulting (rotated) image, binary
%  res:    the resulting image, same type as im
%  both resulting images are the inverted (complement) version,
%  i.e. the staff and notes have value 1 (255) and the rest 0
%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Make binary and invert im (0->1, 1->0)
level = graythresh(im);
BW = imcomplement(im2bw(im,level));

% Compute Hough transform - rough - to find the approximated max peak
[H, theta, rho] = hough(BW);
peaks = houghpeaks(H); 
theta_peak = theta(peaks(2));

% Do a second - more detailed - Hough transform around the max angle
% to find the value
theta_range = theta_peak-2 : 0.01 : theta_peak+2;

% Remove unvalid theta values (that hough transform cannot handle)
theta_range = theta_range(theta_range < 90);
theta_range = theta_range(theta_range >= -90);

[H, theta, rho] = hough(BW, 'Theta', theta_range);
peaks = houghpeaks(H); 
theta_peak = theta(peaks(2));

% Rotate the image (OBS! Handle clockwise and counterclockwise rotation)

im = imcomplement(im);  % to avoid the added areas after rotation to be visible
if(theta_peak > 0)
    rot_angle = -(90 - theta_peak);
else
    rot_angle = 90 + theta_peak;
end

im2 = imrotate(im, rot_angle, 'bicubic'); 

% Result
level = graythresh(im2);
res_bw = im2bw(im2,level);
res = im2;

end

