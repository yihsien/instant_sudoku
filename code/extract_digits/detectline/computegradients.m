function [ xgradient_image, ygradient_image ] = computegradients( input_image )

  % Get the input image dimensions
  [height, width] = size(input_image);

  %{
  % Initialize gradient images to be all zeroes
  xgradient_image = zeros(height, width);
  ygradient_image = zeros(height, width);
    %}
  
  
  g_filter = fspecial('gaussian', 10, 1);
  d_filter_x = [-1,1];
  d_filter_y = [1 ; -1];
  
  %{
  xgradient_image = imfilter(gray_image, g_filter, 'conv');
  ygradient_image = imfilter(gray_image, g_filter, 'conv');
  
  xgradient_image = imfilter(xgradient_image, d_filter_x, 'conv');
  ygradient_image = imfilter(ygradient_image, d_filter_y, 'conv');
  %}
  
  
  
  filter_x = conv2(g_filter, d_filter_x, 'same');
  filter_y = conv2(g_filter, d_filter_y, 'same');
  
  xgradient_image = conv2(input_image, filter_x, 'same');
  ygradient_image = conv2(input_image, filter_y, 'same');

  %{
  xgradient_image = conv2(input_image, g_filter, 'same');
  ygradient_image = conv2(input_image, g_filter, 'same');
  
  xgradient_image = conv2((xgradient_image), d_filter_x, 'same');
  ygradient_image = conv2((ygradient_image), d_filter_y, 'same');
  %}
  
  %xgradient_image = ((xgradient_image + 255) / 510 * 255);
  %ygradient_image = ((ygradient_image + 255) / 510 * 255);
  % COMPUTE IMAGE GRADIENTS HERE

end
