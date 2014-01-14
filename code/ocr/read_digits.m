function [ digits ] = read_digits( filename )
%function reads an image specified by string filename and outputs a row vector of
%all the digits (int).

%create training data
[ train_data, labels ] = create_train_data( );

%train data using adaboost and pruned decision trees
[ alpha, trees ] = adaboost_tree( train_data, labels );

%create test data using filename
[ test_data ] = create_test_data( filename );

[num_testex, ~] = size(test_data);

digits = zeros(1,num_testex);
%fill the row vector digits with predictions
for i = 1 : num_testex
    digits(1, i) = adaboost_tree_predict( alpha, trees, test_data(i, :) );
end


disp(digits);
end

