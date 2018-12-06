function [res] = determinePitch(notes, lineIndices)
%DETERMINEPITCH Determine the pitch of all notes in the binary image imBW
%   notes:       list of structs containing note head position and string
%   specifying note type (struct('headPos', {}, 'type', {}))
%   lineIndices: five rows determining where each staff line is
%   d:           distance between two lines, hiven as interval d = [dMin, dMax]
%   res:         a string containing the result (eg. 'g3e3f3e3....')

centerLine = lineIndices(3);
avgLineDist = (lineIndices(end)-lineIndices(1))/(length(lineIndices)-1);
pitchDist = avgLineDist/2;

encoding = ['g1'; 'a1'; 'b1'; 'c2'; 'd2'; 'e2'; 'f2'; 'g2'; 'a2'; 'b2'; 'c3'; 'd3'; 'e3'; 'f3'; 'g3'; 'a3'; 'b3'; 'c4'; 'd4'; 'e4'];
encoding = transpose(encoding);
positions = round(centerLine+9*pitchDist: -pitchDist : centerLine-10*pitchDist);

%% Generate result

res = ''; % empty string for result
% For each note, encode the pitch
for j = 1:length(notes)
    head = notes(j).headPos;
    head_row = head(2);  % col 2 = y = row
    diff = abs(head_row-positions);
    [c idx] = min(diff); % find closest possible pitch pos
    
    pitch = strcat(encoding(1,idx), encoding(2,idx));
    
    if(notes(j).type == 'note4')
        pitch = upper(pitch);
    end
   
    res = [res, pitch];
end

    
%% Some tests (OBS! Not updated!!!)

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

