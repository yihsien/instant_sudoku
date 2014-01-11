function [] = runme (force_overwrite)
  % By default we do not overwrite results
  if (nargin < 1)
    force_overwrite = false;
  end

  close all

  % Get list of all filenames in input directory
  filenames = dir('../input');

  % Keep record of the evaluation results for each input image
  %scores = [];

  % Process all filenames in input directory
  for i = 1:size(filenames)
    filename = filenames(i).name;
  
    % Check if filename is an image
    if (~isempty(strfind(filename, '.jpg')))
    
      % Determine filenames
      basename = strrep(filename, '.jpg', '');
      input_filename = strcat('../input/', basename, '.jpg');
      %canny_filename = strcat('../canny/', basename, '.jpg');
      %hough_filename = strcat('../hough/', basename, '.jpg');
      %stronglines_filename = strcat('../stronglines/', basename, '.jpg');
      output_filename = strcat('../output/', basename, '.jpg');
      %overlay_filename = strcat('../overlay/', basename, '.jpg');
      %groundtruth_filename = strcat('../groundtruth/', basename, '.jpg');
    
      % Create output image, if it does not already exist
      if (force_overwrite || ~exist(output_filename, 'file'))
        disp(['Creating ' output_filename]);

        % Read the input image
        input_image = imread(input_filename);
        if (size(input_image, 3) == 3) 
          input_image = rgb2gray(input_image);
        end
        input_image = im2double(input_image);

        % Begin timer
        tic
  
        % Compute gradients
        [xgradient_image, ygradient_image] = computegradients ( input_image );

        % Detect Canny edges
        canny_image = detectedges ( xgradient_image, ygradient_image );

        % Compute Hough transform
        hough_transform = votelines ( canny_image, xgradient_image, ygradient_image );

        % Combine Canny and Hough into final output
        output_image = predictlines( canny_image, hough_transform, xgradient_image, ygradient_image, 1.0, 1.0, 2.0 );
        
       
      
        % End timer
        toc
      
        % Evaluate the output image by computing the correlation with the groundtruth image   
        %{
        score = 0;
        if (exist(groundtruth_filename, 'file'))
          groundtruth_image = imread(groundtruth_filename);
          groundtruth_image = im2double(groundtruth_image);
          score = evaluate(output_image, groundtruth_image);
          disp(score)
        end
        scores = [scores; score];
        %}

        % Write the computed images
        %imwrite(visualnormalize(canny_image), canny_filename);
        %imwrite(visualnormalize(hough_transform), hough_filename);
        imwrite(output_image, output_filename);
        %imwrite(visualnormalize(output_image), output_filename);
      
        % Write an image that shows the strong lines (without scaling by the Canny edges or dot products)
        %stronglines_image = predictlines(canny_image, hough_transform, xgradient_image, ygradient_image, 0.0, 1.0, 0.0);
        %imwrite(visualnormalize(stronglines_image), stronglines_filename);

        %imwrite(stronglines_image, stronglines_filename);

      else
        
        % Read the previously computed output image
        output_image = im2double(imread(output_filename));

        % Evaluate the result by computing the correlation with the groundtruth image      
        
        %{
        score = 0;
        if (exist(groundtruth_filename, 'file'))
          groundtruth_image = imread(groundtruth_filename);
          groundtruth_image = im2double(groundtruth_image); 
          score = evaluate(output_image, groundtruth_image);      
        end
        scores = [scores; score];
        %}
      end
    
      % Create overlay image, if it does not already exist
      
      %{
      if (~exist(overlay_filename, 'file'))
        disp(['Creating ' overlay_filename]);
      
        % Read the input and output images
        input_image = imread(input_filename);
        input_image = im2double(input_image);
        output_image = imread(output_filename);
        output_image = im2double(output_image);
      
        % Create the overlay image
        overlay_image = createoverlay(input_image, output_image);

        % Write the overlay image      
        if (exist(groundtruth_filename, 'file'))
          % Add the score into the corner of the overlay image
          h = figure('Visible', 'off');
          hold on
          imshow(overlay_image, 'Border', 'tight');
          text(10, 10, num2str(score(end)),'color', [0 1 0], 'FontSize', 20);
          print(h, '-djpeg', overlay_filename);
          hold off
          close(h);
        else 
          imwrite(overlay_image, overlay_filename);
        end
      end
      %}
      
    end
  end

   %Save the scores 
   %save('score', 'score');

   %Plot the scores 
   %figure;
   %plot(1:1:size(score, 1), score, '.-');

end




function overlay_image = createoverlay( image1, image2 )
  if ( size( image1, 3 ) == 1 )
    image1 = gray2rgb( image1 );
  end
  if ( size( image2, 3 ) == 1 )
    image2 = gray2red( image2 );
  end
  overlay_image = ( image1 + 10*image2 ) / 5;
end



function color_image = gray2rgb( image )
  im = zeros(size(image,1),size(image,2),3);
  im(:,:,1) = image;
  im(:,:,2) = image;
  im(:,:,3) = image;
  color_image = im;
end



function color_image = gray2red( image )
  im = zeros(size(image,1),size(image,2),3);
  im(:,:,1) = image;
  color_image = im;
end



function score = evaluate( prediction, groundtruth )
  if (size(prediction) ~= size(groundtruth))
    disp('Error: size of the output image should be consistent with the input image.');
  else
    score = corr2(prediction, groundtruth);
  end
end



function normalized_image = visualnormalize( image )
  [height, width] = size(image);
  normalized_image = zeros(height, width);
  positive_list = image(image > 0);
  minimum = prctile(positive_list, 0) * 0.7;
  maximum = prctile(positive_list, 95) * 1.25;
  prctile(positive_list, 100);
  normalized_image( image > 0 & image < maximum ) = ...
    (image(image > 0 & image < maximum) - minimum) ./ (maximum - minimum);
  normalized_image( image >= maximum ) = 1;
end

