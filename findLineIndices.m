%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [lineIndices] = findLineIndices(BW)
%Return info about the rows containing staff lines
% BW: binary input image 
% lineIndices: one row index per line

%%
% Horizontal projection
sumBW = sum(BW, 2);

% get one row per line in image (save as new variable)
[peaks,locs] = findpeaks(sumBW);

% Threshold for peak to be considered a line
k = 0.4;   
thresh = max(sumBW(locs))*k; 

linePeaks = sumBW(locs) > thresh;
lineIndices = locs(linePeaks);

%Plot of found lines
% figure
% plot(sumBW)
% hold on
% plot(lineIndices, thresh, '*r')

end

