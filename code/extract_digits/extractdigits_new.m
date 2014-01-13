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
for grid_h=1:window_height:(height-window_height+1)
    for grid_w=1:window_width:(width-window_width+1)
        
        window = imcrop(binary_image, ...
              [grid_w, grid_h, window_width, window_height]);
        
        % determine rectangle
        rect = get_rectangle(window);
        cropped_img = imcrop(window, rect);
                
        % Testing: draw rectangles in original image
        r1 = [grid_w + rect(1,1)-1, grid_h + rect(1,2)-1, ...
            rect(1,3), rect(1,4)];
        %rectangle('position', r1, 'edgecolor', 'r', 'linewidth', 2);
        
        % determine shrinked rectangle
        shrinked_rect = shrink_rectangle(cropped_img);
        cropped_img = imcrop(cropped_img, shrinked_rect);   % crop image down again
        
        % Testing: draw shrinked rectangle in original image
        r2 = [r1(1,1) + shrinked_rect(1,1) - 1, r1(1,2) + shrinked_rect(1,2) - 1, ...
            shrinked_rect(1,3), shrinked_rect(1,4)];
        if (contains_digit(cropped_img))
            rectangle('position', r2, 'edgecolor', 'g', 'linewidth', 2);
        end
        
        count = count + 1;
    end
end

output_struct = 0;

end

function [output_rectangle] = get_rectangle(window)
% determines the inner rectangle of the current window. Used to remove the
% borders of the grid in a first step. (afterwards we run
% shrink_inner_rectangle to improve the result)
% window: pass in the image of the window that we're iterating over
% output_rectangle: outputs a rectangle [x y w h] as output that can be
% used for imcrop then. Positions are relative to input "window"
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
    output_rectangle = maxsquare;
end

function [output_rectangle] = shrink_rectangle(img)
% the inner rectangle as determined by regionprops might still contain some
% black pixels at the border. Use this function to shrink it to remove
% those black pixels.
% We look at the middle 1/3 strip of each side and shrink it until that
% strip has only white pixels
% img: the inner_rectangle as input
% output_rectangle: return a rectangle [x y w h] as output, that can be
% used for imcrop then. Positions are relative to input "img"

    [h, w] = size(img);
    v_length = floor(h/3);  % vertical length
    h_length = floor(w/3);  % horizontal length

    corners = zeros(2, 4);  % saves the result coordinates of the 4 corners

    % moving top edge down
    y_pos = 1;
    while (1)
        hline = img(y_pos, h_length:2*h_length-1);
        if (sum(hline) == h_length)     % all white
            break;
        end
        y_pos = y_pos + 1;
    end
    corners(2, 1:2) = y_pos;

    % moving bottom edge up;
    y_pos = h;
    while (1)
        hline = img(y_pos, h_length:2*h_length-1);
        if (sum(hline) == h_length)     % all white
            break;
        end
        y_pos = y_pos - 1;
    end
    corners(2, 3:4) = y_pos;

    % moving left edge right
    x_pos = 1;
    while (1)
       vline = img(v_length:2*v_length-1, x_pos);
        if (sum(vline) == v_length)     % all white
            break;
        end   
       x_pos = x_pos + 1;
    end
    corners(1, 1) = x_pos;
    corners(1, 3) = x_pos;

    % moving right edge left
    x_pos = w;
    while (1)
       vline = img(v_length:2*v_length-1, x_pos);
        if (sum(vline) == v_length)     % all white
            break;
        end   
       x_pos = x_pos - 1;
    end
    corners(1, 2) = x_pos;
    corners(1, 4) = x_pos;

    output_rectangle = [corners(1,1), corners(2,1), corners(1,2)-corners(1,1), corners(2,3)-corners(2,1)];

end


function [ret] = contains_digit (square) 
% determines if the square which we cropped out contains a digit
% square: pass in the cropped down image. Has to be a bw image.
% ret: return value either true (1) or false (0)
    
    if (islogical(square) == 0)
        error('input image is not a bw image!');
    end
    THRESHOLD_RATIO = 0.1;
    [h, w] = size(square);
    
    square = ~square;   % let black pixels have value 1
    
    % create a mask by dividing square into 9 regions and have the center
    % region valued at 3 and the remaining at 1.
    % this way we're weighing the center of the square more
    % 1 1 1
    % 1 3 1
    % 1 1 1
    mask = ones(h, w);
    mask(floor(h/3)+1:floor(h/3*2), floor(w/3)+1:floor(w/3*2)) = 3;
    
    allblack = sum(sum(mask));
    black_pixels = sum(sum(square .* mask));
    disp(black_pixels/allblack);
    if (black_pixels / allblack > THRESHOLD_RATIO)
        ret = true;
    else
        ret = false;
    end
end
