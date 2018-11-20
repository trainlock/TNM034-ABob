function [lineIndices] = lineInfo(BW)
%Return info about the staff lines
% BW: binary input image 
% lineIndices: one row index of each line
% d: average distance between two lines
% n: average thickness of lines
% nrGroups: Number of line groups (always 5 lines per group), on music sheet

% Find lines and these save positions
%%
sumBW = sum(BW, 2);

thresh = 0.4;
threshBW = sumBW > max(sumBW)*thresh;
%threshBW = double(threshBW);

lineRows = find(threshBW);

%Plot of found lines
% figure
% plot(sumBW)
% hold on
% plot(lineIndices, max(sumBW)*thresh, '*r')

% get one row per line in image (save as new variable)
[peaks,locs] = findpeaks(sumBW);
linePeaks = sumBW(locs) > max(sumBW(locs))*thresh;
lineIndices = locs(linePeaks);

% % find groups of five staff lines
% nrGroups = length(lineIndices) / 5; %ASSUMPTION: previous steps fins all and only lines
%                                     %TODO: Test this??
% 
% % find top and bottom line of each group
% staff
% 
% % compute average line thickness and distance
% 
% %%
% %temp
% d = 0;
% n = 0;
end

