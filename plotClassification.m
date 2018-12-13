function plotClassification(img_original, img_filtered, sNotes)
% Plot result from classification. 
% Red star on heads classified as 1/4 note
% Yellow on 1/8 note
% Grey areas are removed by filter

% make filtered grey and kept white
figure(15)
img = uint8(img_original.*100) + uint8(img_filtered).*155;
imshow(img)

% add notehead classification stars
hold on
for i = 1:length(sNotes)
    if sNotes(:,i).type == 'note4'
        plot(sNotes(:,i).headPos(1),sNotes(:,i).headPos(2), 'r*');
    end
    if sNotes(:,i).type == 'note8'
        plot(sNotes(:,i).headPos(1),sNotes(:,i).headPos(2), 'g*');
    end
end
hold off

end
