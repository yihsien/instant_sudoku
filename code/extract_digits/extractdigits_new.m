function [ output_struct ] = extractdigits_new( sudoku_image )
%Takes a clean sudoku image and extract the digit portion
%   input sudoku_image should be a binary image!
%   The output is a struct with the digit image vector and the 
%   location vector

binary_image = sudoku_image;

%Determine the window size
[height, width] = size(binary_image);

window_height = floor(height/9);
window_width = floor(width/9);

digit_images = {};
digit_location = [];


imshow(sudoku_image);
hold on;
count = 1;
for grid_h=2:window_height:(height-window_height+1)
    for grid_w=2:window_width:(width-window_width+1)
        
        window = imcrop(binary_image, ...
              [grid_w, grid_h, window_width, window_height]);
        
        % determine inner rectangle
        stat = regionprops(window,'boundingbox');
        maxarea = 0;
        maxsquare = 0;
        for cnt = 1 : numel(stat)
            bb = stat(cnt).BoundingBox;
            area = bb(3) * bb(4);
            
            if (area > maxarea && area < (size(window,1) * size(window,2)))
                maxarea = area;
                maxsquare = bb;
            end
        end

        inner_rectangle = imcrop(window, maxsquare);
        
        % rectangle to draw in original image =
        rect = [grid_w + maxsquare(1,1), grid_h + maxsquare(1,2), ...
            maxsquare(1,3), maxsquare(1,4)];
        rectangle('position', rect, 'edgecolor', 'r', 'linewidth', 2);

        count = count + 1;
    end
end

output_struct = 0;

end


