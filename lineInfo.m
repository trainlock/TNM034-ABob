function [lineIndices, d, n, nrGroups] = lineInfo(BW)
%Return info about the staff lines
% BW: binary input image 
% lineIndices: one row index of each line
% d: average distance between two lines
% n: average thickness of lines
% nrGroups: Number of line groups (always 5 lines per group), on music sheet

% Find lines and these save positions
%%
sumBW = sum(BW, 2);
dilateBW=sumBW;%dilateBW = imdilate(sumBW, strel('cube', 3));

thresh = 0.4;
threshBW = dilateBW > max(dilateBW)*thresh;
threshBW = double(threshBW);

lineIndices = find(threshBW);

%Plot of found lines
figure
plot(sumBW)
hold on
plot(lineIndices, max(dilateBW)*thresh, '*r')

% use average to get one row per line in image (save as new variable)

% find groups of five staff lines

% find top and bottom line of each group

% compute average line thickness and distance

%%
%temp
lineIndices = 0;
d = 0;
n = 0;
end

