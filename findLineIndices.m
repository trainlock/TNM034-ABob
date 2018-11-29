%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [lineIndices] = findLineIndices(BW)
%Return info about the rows containing staff lines
% BW: binary input image 
% lineIndices: one row index per line

%%
% Horizontal projection
sumBW = sum(BW, 2);

% get one row per line in image (save as new variable)
% OBS! Smooth data to avoid double peaks
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

% Test if nr indices is divisible by 5, else show an error
if(rem(length(lineIndices), 5) ~= 0)
    error("Number of found lines not divisible by 5.");
end

end

