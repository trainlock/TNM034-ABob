%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [lineIndices] = findLineIndices(BW, d)
%Return info about the rows containing staff lines
% BW: binary input image 
% d:  Distance between two lines, given as interval d = [dMin, dMax]
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

%% Extra check
% Check if number of groups matches the number of lineindices found!

dfilt = true(2*mean(d),6);
staffboxes = imclose(BW,dfilt ); %close groups
sumStaff = sum(staffboxes( :, 1:ceil( size(staffboxes,2)/2) ),2);
staffGroupIntervals = sumStaff > max(sumStaff)*0.8;

% Using the box indices to guess line indices
% Starting points - positive derivative, end points negative, others 0
startend = diff(staffGroupIntervals);

a = 1:size(startend,1);
startend = startend.*(a'); % set value to index
startend = startend(startend ~= 0); 

nrGr = floor(size(startend,1)/2);

% Ugly fix if number of staff lines are not matching
if(length(lineIndices) ~= 5*nrGr)
%%
    % Set correct length
    lineIndices = zeros(5*nrGr, 1);
    
    % Set index values
    % The spacing between the lines will be 1/5 of each box
    for i = 1:nrGr
        
        j = 2*(i-1)+1;
        first = startend(j);
        last = -startend(j+1);
        spacing = ((last-first)/4);
        
        if(spacing > 0)
            li = 5*(i-1)+1;
            lineIndices(li:li+4) = round(first:spacing:last);
        end
       
    end
end

end

