%%%%%%%%%%%%%%%%%%%%%%%%%% 
function imWithoutLines = removeLines(BW)
%REMOVELINES Remove lines using morphological operations
%   BW: Binary image
%
%   imWithoutLines: Binary image without the lines
%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Remove all kinds of lines, leaves only noteheades and the thicker lines
BWnoHorisontalLines = bwmorph(BW, 'open');
BWnoHorisontalLines = bwareaopen(BWnoHorisontalLines, 30);

% Remove everything but vertical objects/lines
BWverticalLines = imopen(BW, strel('rectangle', [15 1]));

% Find flags on notes
BWflags = imopen(BW, strel('line', 4, 90));

% Add to binary images into one complete binary image withouth any lines
BWnl = BWnoHorisontalLines+BWverticalLines+BWflags;

imWithoutLines = BWnl;
end

