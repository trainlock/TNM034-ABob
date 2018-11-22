%%%%%%%%%%%%%%%%%%%%%%%%%% 
function imWithoutLines = removeLines(BW)
%REMOVELINES Remove lines using morphological operations
%   BW: Binary image
%
%   imWithoutLines: Binary image without the lines
%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Remove all kinds of lines, leaves only noteheades and the thicker lines
BWnoLines = bwmorph(BW, 'open');
BWnoLines = bwareaopen(BWnoLines, 30);

% Remove everything but vertical objects/lines
BWverticalLines = imopen(BW, strel('rectangle', [15 1]));

% Add to binary images into one complete binary image withouth any lines
BWnl = BWnoLines+BWverticalLines;

imWithoutLines = BWnl;
end

