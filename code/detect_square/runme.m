function [] = runme (force_overwrite)
  % By default we do not overwrite results
  if (nargin < 1)
    force_overwrite = false;
  end

  close all

  % Get list of all filenames in input directory
  filenames = dir('../../input');

  % Keep record of the evaluation results for each input image
  %scores = [];

  % Process all filenames in input directory
  for i = 1:size(filenames)
    filename = filenames(i).name;
  
    % Check if filename is an image
    if (~isempty(strfind(filename, '.jpg')) || ~isempty(strfind(filename, '.png')))
    
      if (~isempty(strfind(filename, '.jpg')))  
          % Determine filenames
          basename = strrep(filename, '.jpg', '');
          input_filename = strcat('../../input/', basename, '.jpg');
          output_filename = strcat('../../output/square_', basename, '.jpg');
      elseif(~isempty(strfind(filename, '.png')))
          basename = strrep(filename, '.png', '');
          input_filename = strcat('../../input/', basename, '.png');
          output_filename = strcat('../../output/square_', basename, '.png');
      end
              
    
      % Create output image, if it does not already exist
      if (force_overwrite || ~exist(output_filename, 'file'))
        disp(['Creating ' output_filename]);

        % Read the input image

        input_image = imread(input_filename);
        if (size(input_image, 3) == 3) 
          input_image = rgb2gray(input_image);
        end

        % Begin timer
        tic
        
        % adaptive thresholding to convert to bw image
        
        bw = adaptivethreshold(input_image, 15, 0.06);
        output_image = findsquare(bw);
        rectify(output_image);
  
        % End timer
        toc
      
        % Write the computed images
        imwrite(output_image, output_filename);
      else
        
        % Read the previously computed output image
%        output_image = im2double(imread(output_filename));

      end

      
    end
  end
end
