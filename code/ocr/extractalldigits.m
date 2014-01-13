function [ output_struct ] = extractalldigits( sudoku_image )
%Takes a clean sudoku image and extract the digit portion
%   The output is a struct with the digit image vector and the 
%   location vector

%Turn image into gray scale
gray_image = rgb2gray(sudoku_image);

%Set the threshold level
level = graythresh(gray_image);

%Convert whole image matrix to binary
binary_image = im2bw(gray_image, level);

%binary_image = sudoku_image;

%Determine the window size
[height, width] = size(binary_image);


window_height = floor(height/9);
window_width = floor(width/9);

digit_images = {};
digit_location = [];

%disp(window_height);
%disp(height);
%disp(window_width);
%disp(width);

location = 1;
count = 0;
for grid_h=1:window_height:(height-window_height+1)
    for grid_w=1:window_width:(width-window_width+1)
        pixel_sum = 0;
        
        window = imcrop(binary_image, ...
              [grid_w, grid_h, window_width, window_height]);
        
        % determine inner rectangle
        stat = regionprops(window,'boundingbox');
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
        %rectangle('position',maxsquare,'edgecolor','r','linewidth',2);
        inner_rectangle = imcrop(window, maxsquare);
        [inner_h, inner_w] = size(inner_rectangle);

        center_h = floor(inner_h / 2);
        center_w = floor(inner_w / 2);
        
        allblack_sum = 0;
        %Go over the window and calculate the number of black pixels
        for window_h=1:1:inner_h
            for window_w=1:1:inner_w
                dist_h = abs(window_h - center_h);
                dist_w = abs(window_w - center_w);
                dist = sqrt(dist_h * dist_h + dist_w * dist_w);
                if (dist == 0)
                    dist = 1;
                end
                allblack_sum = allblack_sum + 1/power(dist,2);
                if(inner_rectangle(window_h, window_w) == 0)
                    pixel_sum = pixel_sum + 1/(power(dist,2));
                end
            end
        end
        %If the total amount of black pixel exceeds a certain portion, then
        %count that window as containing digit
        
        if(pixel_sum > ((allblack_sum)/10000000))
            count = count + 1;  
            %imshow(digit_image,'Border', 'tight');
            digit_images{1,count} = inner_rectangle;
            %digit_images = [digit_images, [digit_image]];
            digit_location = [digit_location, location];
        end
        %Keep track of digit location
        location = location + 1;
    end
end
%disp(location);
%Construct the struct for return
value1 = digit_images;
field2 = 'location_vector'; value2 = digit_location;

output_struct = struct(field2, value2);
output_struct.digit_vector = value1;

end


