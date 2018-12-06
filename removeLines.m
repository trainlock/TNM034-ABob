%%%%%%%%%%%%%%%%%%%%%%%%%% 
function imWithoutLines = removeLines(BW, n)
%REMOVELINES Remove lines using morphological operations
%   BW: Binary image
%   n:  line width, given as interval n = [nMin, nMax]
%
%   imWithoutLines: Binary image without the lines
%%%%%%%%%%%%%%%%%%%%%%%%%% 

n_avg = (n(1)+n(2))/2;

% Opening with vertical line segment with the size of the max line width
% to remove lines
BWnl = imopen(BW, strel('line', floor(n_avg*2), 90));

imWithoutLines = BWnl;
end

