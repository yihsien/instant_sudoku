function findsquare(bw)
%FINDSQUARE Summary of this function goes here
%   Detailed explanation goes here

% input is bw image through adaptive threshold

Ifill = imfill(~bw, 'holes');
Iarea = bwareaopen(Ifill, 100);
Ifinal = bwlabel(Iarea);

stat = regionprops(Ifinal,'boundingbox');

% find max bounding box
maxarea = 0;
maxsquare = 0;
for cnt = 1 : numel(stat)
    bb = stat(cnt).BoundingBox;
    area = bb(3) * bb(4);
    if area > maxarea
        maxarea = area;
        maxsquare = bb;
    end
end
imshow(bw);hold on;
rectangle('position',maxsquare,'edgecolor','r','linewidth',2);
    
end

