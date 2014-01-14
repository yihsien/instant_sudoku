function [ test_data ] = create_test_data( filename )
image = imread(filename);
[~,~,dim] = size(image);
if dim == 3
    image = rgb2gray(image);
end

%Set the threshold level
level = graythresh(image);

%Convert whole image matrix to binary
image = im2bw(image, level);
str = extractdigits_new(image, 'square_1');

imsize = 10;
[~, num_data] = size(str.digit_vector);
test_data = zeros(num_data, imsize * imsize);

for i = 1 : num_data
    im = imresize(str.digit_vector{1, i}, [imsize imsize]);
    for j = 1 : imsize * imsize
        test_data(i, j) = im(ceil(j/imsize), mod((j-1), imsize) + 1);
    end
end
end

