%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [sNotes, isEmpty] = classification(note, d)
%classification Classifies if the notes are 1/4 or 1/8 else discarded
%   note: Contains image of note or group of notes
%   d: Size of notehead
%
%   sNotes: struct with added objects
%   isEmpty: 1 if no objects been added otherwise 0
%%%%%%%%%%%%%%%%%%%%%%%%%% 

% TODO: Spara bilder till rapporten (t.ex. projektionerna och kanske en miniboxbild)

sNotes = struct('headPos', {}, 'type', {});

% Add padding to image
notePadded = padarray(note,[2 2],'both');
nrElements = 1;
startNrElements = nrElements;
multipleHeads = 0; % 0 = no multiple heads, 1 = multiple heads

% Get positions of note heads
heads = findNoteHeads(notePadded, d);

if(size(heads,1) >= 1)
%     figure
%     imshow(notePadded)
%     hold on
%     plot(heads(:,1),heads(:,2), 'b*')
%     hold off
    midOfIm = size(note,1)/2;
    isSingle = size(heads,1) == 1;
    
    % Check if there is multiple note heads on one staff
    if(size(heads,1)>1)
        for j = 2:size(heads,1)
            x = heads(j,1);
            xPrev = heads(j-1,1);
            xDiff = abs(x-xPrev);
            % Check if heads are on the same staff
            if(0 <= xDiff && xDiff <= 2*d(2))
                multipleHeads = 1;
                isSingle = 1;
            elseif(xDiff > d(2))
                isSingle = 0;
            else
                multipleHeads = 0;
            end
        end
    end
end
if(size(heads,1) < 1)
%     A = "NO heads"
    isEmpty = 1;
elseif(isSingle) % For single objects
    % Place the bounding box beneath the note head.
    % Might need to be modified to detect two flags
    numberOfColumns = size(notePadded, 1);
    numberOfRows = d(1); % 5
    leftColumn = 0;
    topRow = midOfIm;
    
    % Create croppedImage of element
    % Check if there is one, two or no flags
    croppedImage = imcrop(notePadded, [leftColumn, topRow, numberOfColumns, numberOfRows]);
    
    % Projection
    verticalProfile = sum(croppedImage, 1); % Single head
    peaks = findpeaks(verticalProfile);
    
    % Check if noteheads are more than one and then write those to the
    % array. (Can be done by looking at the position of the noteheads and
    % see if they have approximately the same x-value
    if(multipleHeads == 1)
        for i = 1:size(heads, 1)
            if(size(peaks,2) <= 1)
%                 A = "One bar = 1/4"
                % Save head position if head exists in struct element
                sNotes(nrElements).headPos = heads(i,:);

                % Add duration note8
                sNotes(nrElements).type = 'note4';

                % Increment nr of elements in struct
                nrElements = nrElements + 1;
                
                isEmpty = 0; % Not empty
            elseif(size(peaks,2) == 2)
%                 A = "One bar = 1/8"
                % Save head position if head exists in struct element
                sNotes(nrElements).headPos = heads(i,:);

                % Add duration note8
                sNotes(nrElements).type = 'note8';

                % Increment nr of elements in struct
                nrElements = nrElements + 1;
                
                isEmpty = 0; % Not empty
            else
%                 A = "Multiple flags = less"
                isEmpty = 1; % Not interesting = regarded as empty
            end
        end
    else
        % This applies for both single and multiple heads
        if(size(peaks,2) <= 1) % No bars or flags
%             A = "No flags = 1/4"
            % Save head position if head exists in struct element
            sNotes(nrElements).headPos = heads;

            % Add duration note4
            sNotes(nrElements).type = 'note4';

            % Increment nr of elements in struct
            nrElements = nrElements + 1;

            isEmpty = 0; % Not empty

        elseif(size(peaks,2) == 2) % One bar of flag
%             A = "One flag = 1/8"
            % Save head position if head exists in struct element
            sNotes(nrElements).headPos = heads;

            % Add duration note8
            sNotes(nrElements).type = 'note8';

            % Increment nr of elements in struct
            nrElements = nrElements + 1;

            isEmpty = 0; % Not empty

        else % Multiple bars or flags
%             A = "Multiple flags = less"
            isEmpty = 1; % Not interesting = regarded as empty
        end
    end
else
    noHeads = removeHeads(notePadded, heads);
    horisontalProjectionBar = sum(noHeads, 2); % Multiple heads

    [barValue, barIndex] = max(horisontalProjectionBar);

    % Check if bar is on top of image or bottom. Head is reversed position
    % isBarBottom = 0 => head is bottom
    % isBarBottom = 1 => head is top
    isBarBottom = barIndex > midOfIm;

    % Loop through all elements except the last one
    for i = 1:size(heads, 1)-1
        if(isBarBottom == 1) % Head on top
            numberOfColumns = (d(1)+d(2))/2; % 7, 1d
            numberOfRows = 3*(d(1)+d(2))/2; % 25, 3d+lite till+position
            leftColumn = heads(i,1); 
            topRow = size(notePadded,1)-numberOfRows;
            
        else % Head on bottom
            numberOfColumns = (d(1)+d(2))/2; % 7, 1d
            numberOfRows = 3*(d(1)+d(2))/2; % 25, 2d+lite till+position
            leftColumn = heads(i,1)+(d(1)+d(2))/2; % + 7, 1d
            topRow = 0;
        end
        % Create croppedImage for each element
        % Check if there is one or more bars
        croppedImage = imcrop(notePadded, [leftColumn, topRow, numberOfColumns, numberOfRows]);
        
        % Projection
        horisontalProfile = sum(croppedImage, 2); % Multiple heads
        verticalProfile = sum(croppedImage, 1);
        
        peaks = findpeaks(horisontalProfile);
        meanVertical = mean(verticalProfile);
        
        % This applies for both single and multiple heads
        if(size(peaks,1) < 1) % No bars or flags
%             A = "No bars"
        elseif(size(peaks,1) == 1 && meanVertical < (d(1)+d(2))/2) % One bar
%             A = "One bar = 1/8"
            % Save head position if head exists in struct element
            sNotes(nrElements).headPos = heads(i,:);

            % Add duration note8
            sNotes(nrElements).type = 'note8';

            % Increment nr of elements in struct
            nrElements = nrElements + 1;
            
            % Add a check to see if this is the second last element
            % If it is, then the last element should be added as well. 
            if(i == size(heads, 1)-1)
%                 A = "One more bar = 1/8"
                % Save head position if head exists in struct element
                sNotes(nrElements).headPos = heads(i+1,:);

                % Add duration note8
                sNotes(nrElements).type = 'note8';

                % Increment nr of elements in struct
                nrElements = nrElements + 1;
            end
        else % Multiple bars
%             A = "Multiple bars = less"
        end
    end
    % Check if at least one object in multiple object images has been added
    if(startNrElements < nrElements)
        isEmpty = 0; % Not Empty
    else
        isEmpty = 1; % Empty
    end
end

end

