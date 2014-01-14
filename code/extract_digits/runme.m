function [] = runme (force_overwrite)
  % By default we do not overwrite results
  if (nargin < 1)
    force_overwrite = false;
  end

  close all

  % Get list of all filenames image directory
  filenames = dir('../../output/extracted_squares');

  % Keep record of the evaluation results for each input image
  %scores = [];

  % Process all filenames in input directory
  for i = 1:size(filenames)
    filename = filenames(i).name;
  
    % Check if filename is an image
    if (~isempty(strfind(filename, '.jpg')) || ~isempty(strfind(filename, '.png')))
        disp(['[+] Processing ' filename]);
      if (~isempty(strfind(filename, '.jpg')))  
          % Determine filenames
          basename = strrep(filename, '.jpg', '');
          input_filename = strcat('../../output/extracted_squares/', basename, '.jpg');
          output_filename = strcat('../../output/extracted_digits/square_', basename, '.jpg');
      elseif(~isempty(strfind(filename, '.png')))
          basename = strrep(filename, '.png', '');
          input_filename = strcat('../../output/extracted_squares/', basename, '.png');
          output_filename = strcat('../../output/extracted_digits/square_', basename, '.png');
      end
              
    
      % Create output image, if it does not already exist
      if (force_overwrite || ~exist(output_filename, 'file'))

        % Read the input image
        input_image = imread(input_filename);   % should be a gray image

        % Begin timer
        tic
        
        % adaptive thresholding to convert to bw image
        img = im2bw(input_image);
        output_struct = extractdigits(img, basename);   
        
        % writing to output folder happens inside extractdigits()
  
        % End timer
        toc
      

      end

      
    end
  end
end
