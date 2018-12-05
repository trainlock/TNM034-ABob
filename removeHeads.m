function noHeadsIm = removeHeads(notePadded, heads)
%REMOVEHEADS Returns an image without the noteheads
%   notePadded: Image of an object of notes
%   heads: Vector containing the positions of the noteheads

addedMasks = zeros(size(notePadded));
[rNum,cNum,~] = size(notePadded);

for i = 1:size(heads, 1)
    % Define coordinates and radius
    x1 = heads(i, 1);
    y1 = heads(i, 2);
    radius = 8; % 2d

    % Generate grid with binary mask representing the circle. 
    [xx,yy] = ndgrid((1:rNum)-y1,(1:cNum)-x1);
    mask = (xx.^2 + yy.^2)<radius^2;
    addedMasks = addedMasks + mask;
end

% Mask the original image
addedMasks(mask) = uint8(1);

% Invert masked image
binImage = addedMasks;
binImage = ~binImage;
binImage = 1-binImage;
binImage = (binImage == 0);

% Remove points on mask from original image
noHeadsIm = notePadded .* binImage;
end

