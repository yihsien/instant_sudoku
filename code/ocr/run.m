[ train_data, labels ] = create_train_data( );
[ test_data ] = create_test_data( 'test.png' );
test_labels = [5 3 7 6 1 9 5 9 8 6 8 6 4 8 3 1 2 6 6 2 8 4 1 9 5 8 7 9];

[ alpha, trees ] = adaboost_tree( train_data, labels );
[num_testex, ~] = size(test_data);

p = zeros(1,num_testex);
err = 0.0;
for i = 1 : num_testex
    p(1, i) = adaboost_tree_predict( alpha, trees, test_data(i, :) );
    if p(1, i) ~= test_labels(1, i);
        err = err + 1.0;
    end
end
disp(err/num_testex);

disp(p);