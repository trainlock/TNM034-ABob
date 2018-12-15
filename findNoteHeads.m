function [heads] = findNoteHeads(BW, d)
%FINDNOTEHEADS find the positions of the note heads 
% Input:
%   BW - binary image to find circular note heads in
%   d -  Distance between two lines, hiven as interval d = [dMin, dMax]
% Output:
%   heads - the resulting positions of the note heads. One row per head. 

% Average distance between lines (avg height of note head)
d_avg = (d(2)+d(1))/2; 

% Try to separate connected objects
IM = bwmorph(BW, 'open');

% remove thick vertical lines using opening
IM1 = imopen(IM,strel('rectangle',[floor(2*d_avg), floor(d_avg/2.5)]));
IM = IM-IM1; % Remove the beams.

% remove any thick horizontal beams using opening
IM2 = imopen(IM,strel('rectangle',[floor(d_avg/3),floor(2*d_avg)]));
IM = IM-IM2; % Remove found lines

% Clean up a bit by using thinning to try to destroy thick not round objects
IM = bwmorph(IM, 'thin', 2);

% Opening with ciruclar (disk) structuring element to separate the heads
IM = imopen(IM,strel('disk',floor(d_avg/3.5))); 
L = bwlabel(IM);
s = regionprops(L,'centroid');
heads = cat(1, s.Centroid); % The result!

end

