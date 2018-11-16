%%%%%%%%%%%%%%%%%%%%%%%%%% 
function modifiedBW = fixBrokenObjects(BWnl)
%FIXBROKENOBJECTS Fix broken objects in binary image
%   BW: Binary image without lines
%
%   modifiedBW: Broken objects in BW partly fixed
%%%%%%%%%%%%%%%%%%%%%%%%%% 

%openBW = imopen(BWnl, strel('rectangle', [3 1])); % Gives blobs
closedBW = imclose(BWnl, strel('rectangle', [5 1]));
%closedBW = imopen(openBW, strel('disk', 3));
%closedBW = imclose(closedBW, strel('sphere', 4)) + closedBW;

modifiedBW = closedBW;
end

