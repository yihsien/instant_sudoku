function canny_image = detectedges( xgradient_image, ygradient_image )

  % Get the input image dimensions
  [height, width, ~] = size(xgradient_image);
    
  
  % Initialize output image to be all zeroes
  canny_image = zeros(height, width);
  
  
  magnitude = sqrt(xgradient_image .* xgradient_image + ygradient_image .* ygradient_image);
  direction = atan(ygradient_image ./ xgradient_image);
  
  
  supress_result = magnitude;
  
  for H = 2:1:height-1
      for W = 2:1:width-1
          if(direction(H,W)>=-(pi/8) && direction(H,W)<(pi/8))
              if(magnitude(H,W)<magnitude(H,W+1) || magnitude(H,W)<magnitude(H,W-1))
                  supress_result(H,W) = 0;
              end
          elseif(direction(H,W)>=(pi/8) && direction(H,W)<(3*pi/8))
              if(magnitude(H,W)<magnitude(H-1,W+1) || magnitude(H,W)<magnitude(H+1,W-1))
                  supress_result(H,W) = 0;
              end
          elseif(direction(H,W)>=-(3*pi/8)&& direction(H,W)<-(pi/8))
              if(magnitude(H,W)<magnitude(H-1,W-1) || magnitude(H,W)<magnitude(H+1,W+1))
                  supress_result(H,W) = 0;
              end
          else
              if(magnitude(H,W)<magnitude(H-1,W) || magnitude(H,W)<magnitude(H+1,W))
                  supress_result(H,W) = 0;
              end
              
          end
              
      end
  end
  
  for h=1:height-1:height
      for w=1:width-1:width
          supress_result(h,w) = 0;
      end
  end
  
  
  %{
  tHi = 0.08;
  tLo = 0.01;
  highmask = supress_result>tHi; 
  lowmask = bwlabel(~(supress_result<tLo)); 
  final = ismember(lowmask,unique(lowmask(highmask)));
  canny_image = final .* magnitude;
  %}
  
  
  %imshow(uint8(magnitude));
  T_h = 0.08;
  T_l = 0.01;
  strong = (supress_result) > T_h;
  [weakr, weakc] = find((supress_result)>T_l);
  bw = bwselect(strong, weakc, weakr, 8);
  %canny_image = supress_result;
  %imshow(uint8(supress_result))
  canny_image = bw .* magnitude;
  
  % IMPLEMENT THE CANNY EDGE DETECTION ALGORITHM HERE

end
