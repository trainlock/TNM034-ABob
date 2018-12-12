format compact
filename = '././Images_Training/im13s.jpg';
im = imread(filename);
im = rgb2gray(im);
im = imresize(im, 2); 

% Rotate image, find and remove lines and clip image to subimages

% Invertera from white to black
% Threshold to binary image
% Function returns the a rotated version of the original image (double) 
% and a rotated binary image. 
% Make binary and invert (0->1, 1->0)
[BW, im2] = invertAndRotate(im);

% Fix geometric distortions
% tform = fitgeotrans(movingPoints,fixedPoints,?...)
% B = imwarp(A,tform) ;

% Compute distances n (line width) and d (line distance)
[d, n] = computeStaffMetrics(BW);

[lIdx] = findLineIndices(BW,d);

%% function [lineIndices] = findLineIndices(BW)
%Return info about the rows containing staff lines
% BW: binary input image 
% lineIndices: one row index per line

%%
% Horizontal projection
sumBW = sum(BW, 2);

% get one row per line in image (save as new variable)
% OBS! Smooth data to avoid double peaks
[peaks,locs] = findpeaks(sumBW);

% Threshold for peak to be considered a line
k = 0.4;   
thresh = max(sumBW(locs))*k; 

linePeaks = sumBW(locs) > thresh;
lineIndices = locs(linePeaks);

plot(sumBW, 'b'); 
hold on
plot(lineIndices, 500, '*r')
hold off

%% Extra checks
% Check if number of groups matches the number of lineindices found!

dfilt = true(mean(d)*2,6);
staffboxes = imclose(BW,dfilt ); %close groups
sumStaff = sum(staffboxes, 2);
staffGroupIntervals = sumStaff > max(sumStaff)*0.8;

% Using the box indices to guess line indices
% Starting points - positive derivative, end points negative, others 0
startend = diff(staffGroupIntervals);
a = 1:size(startend,1);

% Ugly fix if number of staff lines are not matching
if(length(lineIndices) ~= 5*size(startend,1)/2)
%%
    startend = startend.*(a'); % set value to index
    startend = startend(startend ~= 0); 
    
    % The spacing between the lines will be 1/5 of each box
    lineIndices = zeros(5*size(startend,1)/2, 1);
    
    for i = 1:size(startend,1)/2
        j = 2*(i-1)+1;
        first = startend(j);
        last = -startend(j+1);
        spacing = floor((last-first)/4);
        
        li = 5*(i-1)+1;
        lineIndices(li:li+4) = first:spacing:last;
    end

    plot(sumBW, 'b'); 
    hold on
%     plot(staffGroupIntervals*1000, 'r');  
%     plot(SumBW2);
    plot(lineIndices, 500, '*r')
end


 %% Smoothing alternative
if (rem(length(lineIndices), 5) ~= 0)
    % Keep only large images
     small = sumBW < thresh*0.7;
     smallSumBW = sumBW;
     smallSumBW(small) = 0;
    
    % Smoothen to remove small local peaks
   % filt = [ 1 1 1 1 1 ]./2; % TODO: make it depend on d and n
    
%     smoothSumBW = conv(smallSumBW, dfilt,'same');
%     smoothSumBW(smoothSumBW > thresh) = 500;
    
    %smoothSumBW = conv(SumBW, dfilt,'same');
    
    thresh2 = max(smoothSumBW)*0.4;
    [peaks,locs] = findpeaks(smoothSumBW);

    linePeaks = smoothSumBW(locs) > thresh2;
    lineIndices = locs(linePeaks);

    % Estimate number of grouips and return k largest 
    % k = ?
    %thresh = maxk(smoothSumBW,k);
    
    % Plot of found lines
    figure
    plot(sumBW,'b')
    hold on
    plot(smoothSumBW, 'r')
    plot(lineIndices, thresh2, '*r')
end
