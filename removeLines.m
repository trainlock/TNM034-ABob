%%%%%%%%%%%%%%%%%%%%%%%%%% 
function imWithoutLines = removeLines(BW, d)
%REMOVELINES Remove lines using morphological operations
%   BW: Binary image
%   d:  Distance between two lines, hiven as interval d = [dMin, dMax]
%
%   imWithoutLines: Binary image without the lines
%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Average distance between lines (avg height of note head)
d_avg = (d(2)+d(1))/2; 

% Add to binary images into one complete binary image withouth any lines
BWnl = imopen(BW, strel('line', floor(d_avg/3), 90));

imWithoutLines = BWnl;

end

