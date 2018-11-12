%%%%%%%%%%%%%%%%%%%%%%%%%% 
function strout = tnm034(im) 
% 
% Im: Inputimage of captured sheet music. Im should be in
% double format, normalized to the interval [0,1] 
% strout: The resulting character string of the detected 
% notes. The string must follow a pre-defined format. 

%% Segmentation

% Invertera from white to black
% Threshold to binary image
% Function returns the a rotated version of the original image (double) 
% and a rotated binary image. 
% Make binary and invert (0->1, 1->0)
level = graythresh(im);
BW = im2bw(im, level);
BW = imcomplement(BW);


% Find lines and these save positions

% Remove lines

% Remove "false" objects, noise
% Fix damaged objects. Use opening/closing depending on the damage type
% Opening removes lines, closing removes holes and creates bridges
% Save as separate objects


% Search for "interesting" parts in the image. 
% Apply Sobel-filter to find gradient and the change in the image. 
% Make objects easier to find using opening
% Opening with discs help find note heads, opening with horisontal
% lemenents help find stems

% When separate objects are found, make sure that they are in a correct
% order where they are read horisontally, according to lines. 


%% Classification

% Template matching with normxcorr2(TEMPLATE, A)

% Local vertical/horisontal projection to find flags (or not)
% Local vertical projection to find bars

% bwlabel for classification, new bwconncomp instead of bwlabel
% Labeling sets so that each object have its unique label

% Regionprops, centroid and eulernumber
% Centroid returns center of mass of the region
% EulerNumber returns 1 if no hole is found in the object and 0 if
% a hole exists. 

%% Pitch

% See if object is interesting and then find the pitch for it. 
% Add pitch to strout. Write from left to right (line). 
% fourth = A, eigth = a

%%%%%%%%%%%%%%%%%%%%%%%%%%

