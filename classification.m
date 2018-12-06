%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [sNotes, isEmpty] = classification(note, d)
%classification Classifies if the notes are 1/4 or 1/8 else discarded
%   note: Contains image of note or group of notes
%   d: Size of notehead
%
%   sNotes: struct with added objects
%   isEmpty: 1 if no objects been added otherwise 0
%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Ska få in note bilden, resten behöver inte vara med.

sNotes = struct('headPos', {}, 'type', {});

% Add padding to image
notePadded = padarray(note,[2 2],'both');
nrElements = 1;
startNrElements = nrElements;

% Get positions of note heads
heads = findNoteHeads(notePadded, d);

if(size(heads,1) >= 1)
%     imshow(notePadded)
%     hold on
%     plot(heads(:,1),heads(:,2), 'b*')
%     hold off
    
    midOfIm = size(note,1)/2;
    isSingle = size(heads,1) == 1;
    % Lägg till något som kollar om det är flera nothuvuden på ett skaft
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
%     figure
%     imshow(croppedImage)
    
    % Projection
    verticalProfile = sum(croppedImage, 1); % Single head
    peaks = findpeaks(verticalProfile);
    
    % This applies for both single and multiple heads
    if(size(peaks,2) <= 1) % No bars or flags
%         A = "No flags = 1/4"
        % Save head position if head exists in struct element
        sNotes(nrElements).headPos = heads;
        
        % Add duration note4
        sNotes(nrElements).type = 'note4';
        
        % Increment nr of elements in struct
        nrElements = nrElements + 1;
        
        isEmpty = 0; % Not empty

    elseif(size(peaks,2) == 2) % One bar of flag
%         A = "One flag = 1/8"
        % Save head position if head exists in struct element
        sNotes(nrElements).headPos = heads;
        
        % Add duration note8
        sNotes(nrElements).type = 'note8';
        
        % Increment nr of elements in struct
        nrElements = nrElements + 1;
        
        isEmpty = 0; % Not empty

    else % Multiple bars or flags
%         A = "Multiple flags = less"
        isEmpty = 1; % Not interesting = regarded as empty
    end
else
    noHeads = removeHeads(notePadded, heads);
    horisontalProjectionBar = sum(noHeads, 2); % Multiple heads

    [barValue, barIndex] = max(horisontalProjectionBar);

    % Check if bar is on top of image or bottom. Head is reversed position
    % isBarBottom = 0 => head is bottom
    % isBarBottom = 1 => head is top
    isBarBottom = barIndex > midOfIm;
    
    % TODO: Fix so that it can handle thick bars (two bars merged to one)

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
%         figure
%         imshow(croppedImage)
        
        % Projection
        horisontalProfile = sum(croppedImage, 2); % Multiple heads
        verticalProfile = sum(croppedImage, 1);
        
%         [rows, columns] = size(croppedImage)
%         figure
%         plot(horisontalProfile, 1:rows, 'b-')
%         title('horisontal')
%         figure
%         plot(1:columns, verticalProfile, 'b-')
%         title('vertical')
        
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

