function [ output_struct ] = extractdigits( sudoku_image )
%Takes a clean sudoku image and extract the digit portion
%   The output is a struct with the digit image vector and the 
%   location vector

%Turn image into gray scale
gray_image = rgb2gray(sudoku_image);
%Set the threshold level
level = graythresh(gray_image);
%Convert whole image matrix to binary
binary_image = im2bw(gray_image, level);

%Determine the window size
[height, width] = size(gray_image);
window_height = floor(height/9);
window_width = floor(width/9);


digit_images = [];
digit_location = [];

location = 0;

for grid_h=2:window_height:(height-window_height)
    for grid_w=2:window_width:(width-window_width)
        pixel_sum = 0;
        
        %Go over the window and calculate the number of black pixels
        for window_h=grid_h:1:(grid_h+window_height)
            for window_w=grid_w:1:(grid_w+window_width)
                if(binary_image(window_h, window_w) == 0)
                    pixel_sum = pixel_sum + 1;
                end
            end
        end
        
        
        %If the total amount of black pixel exceeds a certain portion, then
        %count that window as containing digit
        if(pixel_sum > (window_height*window_width/7))
            digit_image = imcrop(binary_image, ...
                          [grid_w, grid_h, window_width, window_height]);
                      
            %imshow(digit_image,'Border', 'tight');
            digit_images = [digit_images, digit_image];
            digit_location = [digit_location, location];
        end
        
        %Keep track of digit location
        location = location + 1;
    end
end

%Construct the struct for return
field1 = 'digit_vector'; value1 = digit_images;
field2 = 'location_vector'; value2 = digit_location;

output_struct = struct(field1, value1, field2, value2);

end

