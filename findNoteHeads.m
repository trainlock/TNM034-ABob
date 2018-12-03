function [heads] = findNoteHeads(BW, d)
%FINDNOTEHEADS find the positions of the note heads 
% Input:
%   BW - binary image to find circular note heads in
%   d -  Distance between two lines, hiven as interval d = [dMin, dMax]
% Output:
%   heads - the resulting positions of the note heads. One row per head. 

% Average distance between lines (avg height of note head)
d_avg = (d(2)+d(1))/2; 

% first remove any thick beams using opening
IM = imopen(BW,strel('rectangle',[floor(d_avg/3),floor(2*d_avg)]));
IM = BW-IM; % Remove the beams.

% Opening with ciruclar (disk) structuring element to separate the heads
IM = imopen(IM,strel('disk',floor(d_avg/2))); % OBS! Same here. Size based on image scale

% Find the note head positions (centroids of objects in IM)
L = bwlabel(IM);
s = regionprops(L,'centroid');
heads = cat(1, s.Centroid); % The result!

end

