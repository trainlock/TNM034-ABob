function [res] = determinePitch(imBW, lineIndices, d)
%DETERMINEPITCH Determine the pitch of all notes in the binary image imBW
%   imBW:        binary input image (one subImage of the score)
%   lineIndices: five rows determining where each staff line is
%   d:           distance between two lines, hiven as interval d = [dMin, dMax]
%   res:         a string containing the result (eg. 'g3e3f3e3....')

centerLine = lineIndices(3);
avgLineDist = (lineIndices(end)-lineIndices(1))/(length(lineIndices)-1);
pitchDist = avgLineDist/2;

encoding = ['g1'; 'a1'; 'b1'; 'c2'; 'd2'; 'e2'; 'f2'; 'g2'; 'a2'; 'b2'; 'c3'; 'd3'; 'e3'; 'f3'; 'g3'; 'a3'; 'b3'; 'c4'; 'd4'; 'e4'];
encoding = transpose(encoding);
positions = round(centerLine+9*pitchDist: -pitchDist : centerLine-10*pitchDist);

% Find the positions of the note heads
heads = findNoteHeads(imBW, d);

%% Generate result

res = ''; % empty string for result
% For each centroid, encode the pitch
for j = 1:length(heads)
    c_row = heads(j,2);  % col 2 = y = row
    diff = abs(c_row-positions);
    [c index] = min(diff); % find closest possible pitch pos
    res = [res, strcat(encoding(1,index), encoding(2,index))];
end

% At end of line, add an 'n'
res = [res, 'n'];
    
%% Some tests

% TEST: draw line positions
% grayIm = 255 * uint8(imBW);
% RGB = cat(3,grayIm,grayIm,grayIm);
% RGB(positions, :, 1) = 255;
% RGB(centerLine, :, 2) = 255;
% figure
% imshow(RGB);

% TEST: Show the centroids
% if(length(heads) > 1)
%     figure
%     imshow(imBW)
%     hold on
%     plot(heads(:,1),heads(:,2), 'b*')
%     hold off
% end

end

