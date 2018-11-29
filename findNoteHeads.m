function [heads] = findNoteHeads(BW)
%FINDNOTEHEADS find the positions of the note heads 
% Input:
%   BW - binary image to find circular note heads in
% Output:
%   heads - the resulting positions of the note heads. One row per head. 

% first remove any thick beams using opening
IM = imopen(BW,strel('rectangle',[4,15])); % OBS! Size should be dependent on image scale. 
IM = BW-IM; % Remove the beams.

% Opening with ciruclar (disk) structuring element to separate the heads
IM = imopen(IM,strel('disk',4)); % OBS! Same here. Size based on image scale

% Find the note head positions (centroids of objects in IM)
L = bwlabel(IM);
s = regionprops(L,'centroid');
heads = cat(1, s.Centroid); % The result!

end

