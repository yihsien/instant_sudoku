function [ digits ] = read_digits( filename )
[ train_data, labels ] = create_train_data( );

[ alpha, trees ] = adaboost_tree( train_data, labels );
[ test_data ] = create_test_data( filename );
[num_testex, ~] = size(test_data);

digits = zeros(1,num_testex);

for i = 1 : num_testex
    digits(1, i) = adaboost_tree_predict( alpha, trees, test_data(i, :) );
end


disp(digits);
end

