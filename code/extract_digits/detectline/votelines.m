function hough_transform = votelines( canny_image, xgradient_image, ygradient_image )

  % Get the input image dimensions
  [height, width, ~] = size(canny_image);

  % Initialize output image to be all zeroes
  hough_transform = zeros(round((height^2 + width^2)^0.5/2  + 1), 360);
  
  [hough_height, hough_width] = size(hough_transform);
  
%   theta = atand(ygradient_image ./ xgradient_image);
  %theta = flipud(theta);
  theta = atan(ygradient_image ./ xgradient_image);
  theta1 = theta;
  theta = radtodeg(theta);

  
  for h=1:1:height
      y = -(h-height/2);
      for w=1:1:width
          x = w-width/2;
          if(canny_image(h,w)~=0)
              d = -x*cos(theta1(h,w)) - y*sin(theta1(h,w));
              a = theta(h,w);
              if(theta(h,w)<0)
                  a = theta(h,w) + 360;
              end
              
              if(d<0)
                  d = abs(d);
                  a = mod(a + 180,360);
                  
              end
            
              
              ix1 = floor(d);
              iy1 = floor(a);
              ix2 = ceil(d);
              iy2 = ceil(a);
              dx = d-ix1;
              dy = a-iy1;
              
              if(ix1==0)
                ix1 = hough_height;
              end
              if(iy1==0)
                iy1 = hough_width;
              end
              if(ix2==0)
                ix2 = hough_height;
              end
              if(iy2==0)
                iy2 = hough_width;
              end
              
              weight1 = (1.0-dx)*(1.0-dy);
              weight2 = (1.0-dx)*dy;
              weight3 = dx*(1.0-dy);
              weight4 = dx*dy;
              hough_transform(ix1,iy1) = hough_transform(ix1,iy1) + canny_image(h,w)*weight1;
              hough_transform(ix1,iy2) = hough_transform(ix1,iy2) + canny_image(h,w)*weight2;
              hough_transform(ix2,iy1) = hough_transform(ix2,iy1) + canny_image(h,w)*weight3;
              hough_transform(ix2,iy2) = hough_transform(ix2,iy2) + canny_image(h,w)*weight4;

                  
          end
      end
  end
  
  %imshow(hough_transform)
  
  %figure, imshow(hough_transform)
              
      
          
   

  % IMPLEMENT THE HOUGH TRANFORM VOTING ALGORITHM HERE

end
