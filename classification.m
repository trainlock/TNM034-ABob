function classifiedNote = classification(interestingBoxes, BW_subIms, subIm)
%classification Classifies if the notes are 1/4 or 1/8 else discarded
%   interestingBoxes: Contains images of each note or group of notes
%   BW_subIms: 
%   subIm: 

% Ska få in note bilden, resten behöver inte vara med. 

% DELA UPP HELA KODEN FRÅN SINGLE OCH MULTIPLES DIREKT!

% 2-5 = large object, 6+8 = single flag
bbx = interestingBoxes(8,:); % Två noter saknas! De som inte har någon flagga!
[r, c] = getBboxIdx(bbx);
note = BW_subIms(r,c,subIm);
figure
imshow(note)

% Add padding to image
notePadded = padarray(note,[2 2],'both');

% Get positions of note heads
heads = findNoteHeads(notePadded);
if(size(heads,1) >= 1)
    imshow(notePadded)
    hold on
    plot(heads(:,1),heads(:,2), 'b*')
    hold off

    midOfIm = size(note,1)/2;
    isSingle = size(heads,1) == 1;
    % Lägg till något som kollar om det är flera nothuvuden på ett skaft
end
if(size(heads,1) < 1)
    a = "NO heads"
elseif(isSingle) % For single objects
    % Place the bounding box beneath the note head.
    % Might need to be modified to detect two flags
    numberOfColumns = size(notePadded, 1);
    numberOfRows = 5; % 1d
    leftColumn = 0;
    topRow = midOfIm;
    
    % Create croppedImage of element
    % Check if there is one, two or no flags
    croppedImage = imcrop(notePadded, [leftColumn, topRow, numberOfColumns, numberOfRows]);
    figure
    imshow(croppedImage)
    
    % Projection
    verticalProfile = sum(croppedImage, 1); % Single head
    peaks = findpeaks(verticalProfile);
    
    % This applies for both single and multiple heads
    if(size(peaks,2) <= 1) % No bars or flags
        A = "No flags = 1/4"
    elseif(size(peaks,2) == 2) % One bar of flag
        A = "One flag = 1/8"
    else % Multiple bars or flags
        A = "Multiple flags = less"
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
            numberOfColumns = 7; % 1d
            numberOfRows = 25; %2d+lite till+position
            leftColumn = heads(i,1); 
            topRow = size(notePadded,1)-numberOfRows;
            
        else % Head on bottom
            numberOfColumns = 7; % 1d
            numberOfRows = 25; % 2d+lite till+position
            leftColumn = heads(i,1)+7; % + 1d
            topRow = 0;
        end
        % Create croppedImage for each element
        % Check if there is one or more bars
        croppedImage = imcrop(notePadded, [leftColumn, topRow, numberOfColumns, numberOfRows]);
        figure
        imshow(croppedImage)
        
        % Projection
        horisontalProfile = sum(croppedImage, 2); % Multiple heads
        peaks = findpeaks(horisontalProfile);
        
        % This applies for both single and multiple heads
        if(size(peaks,1) < 1) % No bars or flags
            A = "No flags or bars"
        elseif(size(peaks,1) == 1) % One bar
            A = "One bar = 1/8"
        else % Multiple bars
            A = "Multiple bars = less"
        end
    end
end

% Hur vill jag returnera informationen?? Om jag hittat noter som uppfyller
% rätt krav, hur sparar jag dem då? I en lista? Som en position? Skriver
% direkt till en lista med alla pitchar? Vad vill jag returnera och vad
% vill jag spara?

classifiedNote = "A";

end

