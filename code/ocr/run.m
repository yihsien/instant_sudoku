[ train_data, labels ] = create_train_data( );

[ alpha, trees ] = adaboost_tree( train_data, labels );

p = zeros(1,243);
err = 0.0;
for i = 1 : 243
    p(1, i) = adaboost_tree_predict( alpha, trees, train_data(i, :) );
    if p(1, i) ~= labels(i, 1);
        err = err + 1.0;
    end
end
disp(err/243.0);

disp(p);