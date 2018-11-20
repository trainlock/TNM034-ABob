% Read image
filename = '././Images_Training/im1s.jpg';
im = imread(filename);
im = rgb2gray(im);

[BW, im] = invertAndRotate(im);

lineIndices = lineInfo(BW);

% find groups of five staff lines
nrGroups = length(lineIndices) / 5; %ASSUMPTION: previous steps fins all and only lines
                                    %TODO: Test this??

%Extract part of image with stafflines, padding: the height of one group
if(nrGroups > 1)
    groupPadding = ceil(lineIndices(6)-lineIndices(5)/2); %ASSUMPTION: We have rows and they are found correctly
    cutIm = im( (lineIndices(1)-groupPadding) : (lineIndices(end)+groupPadding),: );
    %imshow(cutIm)
    
    %alignedIm = zeroes( ceil(size(cutIm,1)/nrGroups), ceil(size(cutIm,2)*nrGroups) );
    alignedIm = reshape( cutIm, nrGroups, [] );
    imshow(alignedIm)
    
end

%THINK: Why?
%CONTINUE! Fix division and new aligned im