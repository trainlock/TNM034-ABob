function [rows, cols] = getBboxIdx(bbox)
% Get row and column indices for a BoundingBox from regionprops

% bbox - [ loxest_x-0.5  lowest_y-0.5  width  height ] 

rows = ceil(bbox(2)):ceil(bbox(2)+bbox(4));
cols = ceil(bbox(1)):ceil(bbox(1)+bbox(3));
end

