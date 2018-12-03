function [ d, n ] = compStaffMetrics( BW )
%COMPSTAFFMETRICS Compute distances n (line width) and d (line distance)
% Input:
%   BW - score image, binary and inverted (staff lines and notes = white =
%   1 and background = black = 0)
% Output:
%   d - the distance between two lines, given as interval: [d_min, d_max]
%   n - the width of a line, given as interval: [n_min, n_max]

% Note: In order to manage noise and variability, an interval is returned.


% For each column in the binary image, count size of sequences of black and
% white pixels (OBS! Staff lines = 1 = white)

nrCols = size(BW,2);
nrRows = size(BW,1);

sizes_b = []; % black = 0, used to determine d: line distance
sizes_w = []; % white = 1, used to determine n: line thickness

for col = 1:nrCols
    % count first
    count = 1;
    prev = BW(1,col); 
    for row = 2:nrRows
       curr = BW(row,col);
       if(curr == prev)
           % if same, increase counter
           count = count + 1;
       else
           % if not same, change prev and add to correct list of sizes and
           % reset count

           % OBS! if current is 0, the previous was 1
           if(curr == 0)
              sizes_w = [sizes_w, count];
           else % curr = 1
              sizes_b = [sizes_b, count]; 
           end
           count = 1;
           prev = curr;
       end
    end
end

%% Compute ranges for d and n

b_unique = unique(sizes_b);
w_unique = unique(sizes_w);

bincounts_b = histc(sizes_b, b_unique);
bincounts_w = histc(sizes_w, w_unique);

% TEST: Plot result
% figure
% subplot(2,1,1);
% plot(unique(sizes_b), bincounts_b);
% title('Distance between staff lines (black pixels)')
% subplot(2,1,2);
% plot(unique(sizes_w), bincounts_w);
% title('Thickness of staff lines (white pixels)')

b_thresh = (1/3)*max(bincounts_b);
w_thresh = (1/3)*max(bincounts_w);

% find the distances that has more than 1/3 of the largest value for
% occurences
d =  b_unique(bincounts_b > b_thresh); % used for d
n =  w_unique(bincounts_w > w_thresh); % used for n

% Only save the largest and smallest value (the range)
d = [min(d) max(d)];
n = [min(n) max(n)];

end

