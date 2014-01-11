function output_image = predictlines( canny_image, hough_transform, xgradient_image, ygradient_image, alpha, beta, gamma )

  % Get the input image dimensions
  [height, width, ~] = size(canny_image);

  % Initialize output image to be all zeroes
  output_image = zeros(height, width);
  
  [hough_height, hough_width] = size(hough_transform);
  
  theta = atan(ygradient_image ./ xgradient_image);
  

  for h=1:1:height
      y = -(h-height/2);
      for w=1:1:width
          x = w-width/2;
          if(canny_image(h,w)~=0)
          maximum = 0;
          for a=1:1:180
              d = -x*cos(degtorad(a)) - y*sin(degtorad(a));
              angle = a;
              if(d<=0)
                 d = abs(d);
                 angle = mod(angle+180,360);  
              end
              ix1 = floor(d);
              ix2 = ceil(d);
              iy = angle;
              dx = d-ix1;
              weight1 = (1.0-dx);
              weight2 = dx;
              
              if(ix1==0)
                ix1 = hough_height;
              end
              if(ix2==0)
                ix2 = hough_height;
              end
              if(iy==0)
                iy = hough_width;
              end
              
              image = (canny_image(h,w)^alpha * (hough_transform(ix1,iy)*weight1+hough_transform(ix2,iy)*weight2)^beta * cos(theta(h,w)-degtorad(angle))^gamma);
              if(image>maximum)
                  maximum = image;
              end
          end
          output_image(h,w) = maximum;
          end 
      end
  end
  
  
  
  for h=1:height-1:height
      for w = 1:width-1:width
          output_image(h,w) = 0;
      end
  end
  output_image = output_image + 0.001;
  output_image = output_image / max(max(output_image)) +1 ;
  output_image = log(output_image);
  output_image = output_image+exp(1);
  output_image = output_image/exp(1);
  output_image = output_image / max(max(output_image));
  output_image(output_image <= 0.7985) = 0;
  output_image = output_image * 0.8;
  
  
  
  %{
  positive_list = output_image(output_image > 0);
  minimum = prctile(positive_list, 0) * 0.2;
  maximum = prctile(positive_list, 95) * 1.25;
  prctile(positive_list, 100);
  output_image( output_image > 0 & output_image < maximum ) = ...
  (output_image(output_image > 0 & output_image < maximum) - minimum) ./ (maximum - minimum);
  output_image( output_image >= maximum ) = 1;
  %}
  
  %{
  
  disp(max(max(output_image)));
  disp(min(min(output_image)));
  
  %}

  %{
  
  max_value = max(max(output_image));
  output_image = output_image / max_value;
  
  positive_list = output_image(output_image > 0);
  
  minimum = prctile(positive_list, 0) * 15;
  maximum = prctile(positive_list, 95) * 0.5;
  prctile(positive_list, 100);
  output_image( output_image > 0 & output_image < maximum ) = ...
  (output_image(output_image > 0 & output_image < maximum) - minimum) ./ (maximum - minimum);
  output_image( output_image >= maximum ) = 1;
  %}
  %disp(output_image)
  
  % COMBINE THE CANNY EDGES AND HOUGH TRANFORM INTO THE FINAL LINE PREDICTION HERE

end
