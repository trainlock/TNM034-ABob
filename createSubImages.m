function [subImages] = createSubImages(im,lineIndices)
%Return n subimages, each containing one line group from the image im.
% im: input image (uint8)
% lineIndices: one row index of each line

% find groups of five staff lines
nrGroups = floor(length(lineIndices) / 5); % ASSUMPTION: previous steps fins all and only lines
                                           % If decimal number, something
                                           % went wrong earlier.. 
                                           
%Extract part of image with stafflines, padding: the height of one group
subImages = im;
if(nrGroups > 0)
    padding = 3* ceil(lineIndices(3) - lineIndices(1));  % dist from center line to top line
    
    % Pad top and bottom of image with white, in case there is not enough
    % pixels to "cut" using the padding
    % OBS! Requires Adding one padding to the values of the lineindices
    im = padarray(im,[padding 0],1,'both');
    lineIndices = lineIndices + padding;
    
    figure
    imshow(im)
    
    rowCounter = 3;
    subImages = uint8(zeros(padding*2+1, size(im,2), nrGroups));
    for i = 1:nrGroups 
        % cut out and save one group, with padding
        row = lineIndices(rowCounter);
        subImages(:, :, i) = im(row - padding : row + padding, :);
        rowCounter = rowCounter + 5 ;
    end 
end

end

