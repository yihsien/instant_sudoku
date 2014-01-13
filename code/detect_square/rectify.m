function [ output_img ] = rectify( input_img )
%RECTIFY Summary of this function goes here
%   Detailed explanation goes here
% run after output from findsquare. Try to rectify image so it's easier
% to process extract digits.
% input_img is a bw image of the extracted sudoku square
% output_img is a rectified bw image of the sudoku square

[x1, y1] = find_corner_point(input_img, 'top-left');
[x2, y2] = find_corner_point(input_img, 'top-right');
[x3, y3] = find_corner_point(input_img, 'bottom-left');
[x4, y4] = find_corner_point(input_img, 'bottom-right');

figure,imshow(input_img); hold on;
plot(x1,y1,'r.','MarkerSize',20);
plot(x2,y2,'r.','MarkerSize',20);
plot(x3,y3,'r.','MarkerSize',20);
plot(x4,y4,'r.','MarkerSize',20);
hold off;

%{
x = [x1, x2, x3, x4];
y = [y1, y2, y3, y4];
before = [x', y'];

length = max(size(input_img));
[w, h] = size(input_img);
%after = [ [1, length, 1, length]', [1, 1, length, length]'];
after = [ [1, w, 1, w]', [1, 1, h, h]'];

tform = cp2tform(before, after, 'projective');

output_img = imtransform(input_img, tform);
imshow(output_img);
%}
output_img = 0;
end


function [ x, y ] = find_corner_point( input_img, type )
% finds the corner point of the input image
% IMG: the sudoku square bw image
% TYPE: one of the 4 strings: 'top-left', 'top-right', 'bottom-left',
% 'bottom-right' to specify which corner point you want
% X, Y: returns x and y coordinates of the corner point relative to the img

% side_length of the corner
side_length = floor(max(size(input_img)) / 4);

switch type
case 'top-left'
    corner_x = 1;     % x and y coordinate of corner. (moving along diagonal)
    corner_y = 1;     % at the end this will hold the point of the corner
    break_type = 0;
    while (1)
        hline = input_img(corner_y, corner_x:corner_x+side_length-1);
        vline = input_img(corner_y:corner_y+side_length-1, corner_x);
        if (sum(vline) < side_length)       % contains black pixels
            break_type = 'v';
            break;
        elseif (sum(hline) < side_length)
            break_type = 'h';
            break;
        end
        corner_x = corner_x + 1;
        corner_y = corner_y + 1;
    end

    if (break_type == 'v')      % stopped at vertical line. continue to move horizontal
        while (1)
            hline = input_img(corner_y, corner_x:corner_x+side_length-1);
            if (sum(hline) < side_length)
                break;
            end
            corner_y = corner_y + 1;
        end
    elseif (break_type == 'h')
        while (1)
            vline = input_img(corner_y:corner_y+side_length-1, corner_x);
            if (sum(vline) < side_length)
                break;
            end
            corner_x = corner_x + 1;
        end    
    end
case 'top-right'  
    corner_x = size(input_img, 2);     % x and y coordinate of corner. (moving along diagonal)
    corner_y = 1;     % at the end this will hold the point of the corner
    break_type = 0;
    while (1)
        hline = input_img(corner_y, corner_x-side_length+1:corner_x);
        vline = input_img(corner_y:corner_y+side_length-1, corner_x);
        if (sum(vline) < side_length)       % contains black pixels
            break_type = 'v';
            break;
        elseif (sum(hline) < side_length)
            break_type = 'h';
            break;
        end
        corner_x = corner_x - 1;
        corner_y = corner_y + 1;
    end

    if (break_type == 'v')      % stopped at vertical line. continue to move horizontal
        while (1)
            hline = input_img(corner_y, corner_x-side_length+1:corner_x);
            if (sum(hline) < side_length)
                break;
            end
            corner_y = corner_y + 1;
        end
    elseif (break_type == 'h')
        while (1)
            vline = input_img(corner_y:corner_y+side_length-1, corner_x);
            if (sum(vline) < side_length)
                break;
            end
            corner_x = corner_x - 1;
        end    
    end
    
case 'bottom-left'
    corner_x = 1;     % x and y coordinate of corner. (moving along diagonal)
    corner_y = size(input_img, 1);     % at the end this will hold the point of the corner
    break_type = 0;
    while (1)
        hline = input_img(corner_y, corner_x:corner_x+side_length-1);
        vline = input_img(corner_y-side_length+1:corner_y, corner_x);
        if (sum(vline) < side_length)       % contains black pixels
            break_type = 'v';
            break;
        elseif (sum(hline) < side_length)
            break;
        end
        corner_x = corner_x + 1;
        corner_y = corner_y - 1;
    end

    if (break_type == 'v')      % stopped at vertical line. continue to move horizontal
        while (1)
            hline = input_img(corner_y, corner_x:corner_x+side_length-1);
            if (sum(hline) < side_length)
                break;
            end
            corner_y = corner_y - 1;
        end
    elseif (break_type == 'h')
        while (1)
            vline = input_img(corner_y-side_length+1:corner_y, corner_x);
            if (sum(vline) < side_length)
                break;
            end
            corner_x = corner_x + 1;
        end    
    end
case 'bottom-right'    
    corner_x = size(input_img, 2);     % x and y coordinate of corner. (moving along diagonal)
    corner_y = size(input_img, 1);     % at the end this will hold the point of the corner
    break_type = 0;
    while (1)
        hline = input_img(corner_y, corner_x-side_length+1:corner_x);
        vline = input_img(corner_y-side_length+1:corner_y, corner_x);
        if (sum(vline) < side_length)       % contains black pixels
            break_type = 'v';
            break;
        elseif (sum(hline) < side_length)
            break_type = 'h';
            break;
        end
        corner_x = corner_x - 1;
        corner_y = corner_y - 1;
    end

    if (break_type == 'v')      % stopped at vertical line. continue to move horizontal
        while (1)
            hline = input_img(corner_y, corner_x-side_length+1:corner_x);
            if (sum(hline) < side_length)
                break;
            end
            corner_y = corner_y - 1;
        end
    elseif (break_type == 'h')
        while (1)
            vline = input_img(corner_y-side_length+1:corner_y, corner_x);
            if (sum(vline) < side_length)
                break;
            end
            corner_x = corner_x - 1;
        end    
    end

otherwise
    error('invalid input argument');
end
x = corner_x;
y = corner_y;
end


