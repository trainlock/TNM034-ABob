%%%%%%%%%%%%%%%%%%%%%%%%%% 
function imWithoutLines = removeLines(BW, n)
%REMOVELINES Remove lines using morphological operations
%   BW: Binary image
%   n:  line width, given as interval n = [nMin, nMax]
%
%   imWithoutLines: Binary image without the lines
%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Opening with vertical line segment with the size of the max line width
% to remove lines
BWnl = imopen(BW, strel('line', floor(n(2)*1.2), 90));

imWithoutLines = BWnl;
end

