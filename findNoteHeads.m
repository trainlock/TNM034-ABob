function [heads] = findNoteHeads(BW, d)
%FINDNOTEHEADS find the positions of the note heads 
% Input:
%   BW - binary image to find circular note heads in
%   d -  Distance between two lines, hiven as interval d = [dMin, dMax]
% Output:
%   heads - the resulting positions of the note heads. One row per head. 

% Average distance between lines (avg height of note head)
d_avg = (d(2)+d(1))/2; 

% first remove any thick horizontal beams using opening
IM = imopen(BW,strel('rectangle',[floor(d_avg/4),floor(2*d_avg)]));
IM = BW-IM; % Remove the beams.

% remove thick vertical lines using opening
IM1 = imopen(BW,strel('rectangle',[floor(2*d_avg), floor(d_avg/2.5)]));
IM = IM-IM1; % Remove found lines

% Clean up a bit
IM = bwmorph(IM, 'open');

% Opening with ciruclar (disk) structuring element to separate the heads
IM = imopen(IM,strel('disk',round(d_avg/2))); 
L = bwlabel(IM);
s = regionprops(L,'centroid');
heads = cat(1, s.Centroid); % The result!

end

