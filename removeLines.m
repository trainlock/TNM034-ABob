%%%%%%%%%%%%%%%%%%%%%%%%%% 
function imWithoutLines = removeLines(lineIndices, BW)
%REMOVELINES Remove lines at indices in image
%   lineIndices: Index of staff lines in image
%   BW: Binary image
%
%   imWithoutLines: Binary image where the rows corresponding to
%   lineIndices have been removed
%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 
% sobelFilter1 = [-1 -2 -1; 0 0 0; 1 2 1];
% sobelFilter2 = [1 2 1; 0 0 0; -1 -2 -1];
% %filteredIm = imfilter(im(lineIndices,:), sobelFilter);
% filteredIm1 = imfilter(im, sobelFilter1);
% filteredIm2 = imfilter(im, sobelFilter2);
% filteredIm = abs(filteredIm1+filteredIm2);
% figure
% imshow(filteredIm)

% Check morphological gradient
% Difference between dilation and erosion

BWnl = BW;
% Set lines to black, aka remove lines
BWnl(lineIndices,:) = 0;

imWithoutLines = BWnl;
end

