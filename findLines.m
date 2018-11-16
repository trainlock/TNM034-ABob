%%%%%%%%%%%%%%%%%%%%%%%%%% 
function lineIndicies = findLines(BW)
%FINDLINES Find horisontal lines
%  BW: input rotated image
%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Find lines and these save positions
sumBW = sum(BW, 2);
dilateBW = imdilate(sumBW, strel('cube', 3));
thresh = 0.3;
threshBW = dilateBW > max(dilateBW)*thresh;
threshBW = double(threshBW);

lineIndicies = find(threshBW);
end

