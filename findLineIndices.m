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


% Make a guess if nr of indices is not divisible by 5 
% OBS: This method is not as accurate with its positions yet!
if(rem(length(lineIndices), 5) ~= 0)

    % Locate gruops
    dfilt = true(20,6);
    staffboxes = imclose(BW,dfilt ); %close the staff lines toghether
    sumStaff = sum(staffboxes, 2);
    staffGroupIntervals = sumStaff > max(sumStaff)*0.8;

    % Using the box indices to guess line indices
    % Starting points - positive derivative, end points negative, others 0
    startend = diff(staffGroupIntervals);
    a = 1:size(startend,1);
    startend = startend.*(a'); % set value to index
    startend = startend(startend ~= 0); %keep only the indices with start and end
    
    
    lineIndices = zeros(5*size(startend,1)/2, 1);
    
    % Set the indices eaqually spaced between the staff edges
    for i = 1:size(startend,1)/2
        j = 2*(i-1)+1;
        first = startend(j);
        last = -startend(j+1);
        spacing = floor((last-first)/4);
        
        li = 5*(i-1)+1;
        lineIndices(li:li+4) = first:spacing:last;
    end
end

end

