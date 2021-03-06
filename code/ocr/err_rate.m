function [ err ] = err_rate( tree, train_data, labels, weights )
%function calculates the error rate of the decision tree on train_data and
%labels with weights
[num_trainex, ~] = size(train_data);
err = 0.0;
for i = 1 : num_trainex
    if predict(tree, train_data(i, :)) ~= labels(i, 1);
        err = err + weights(i, 1);
    end
end

end

