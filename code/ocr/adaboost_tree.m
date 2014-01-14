function [ alpha, trees ] = adaboost_tree( train_data, labels )
%function trains data train_data and labels using adaboost with pruned
%decision trees and 200 boosts
alpha = zeros(1, 200);
trees = cell(1, 200);

[num_trainex, ~] = size(train_data);

%initialize all weights to 1/n
weights = ones(num_trainex, 1);
weights = weights * (1.0/num_trainex);

for t = 1 : 200
    %calculate a pruned tree using the current weights
    tree = prune(ClassificationTree.fit( train_data, labels, 'Weights', weights ));
    
    %store the calculated tree
    trees{1, t} = tree;
    
    %calculate the current error rate
    error = err_rate(tree, train_data, labels, weights);
    
    %calculate the alpha at step t
    alpha(1, t) = 0.5 * log((1-error)/error);
    
    %update weights
    for i = 1 : num_trainex
        if predict(tree, train_data(i, :)) == labels(i, 1)
            weights(i, 1) = weights(i, 1) * exp(-alpha(1, t));
        else 
            weights(i, 1) = weights(i, 1) * exp(alpha(1, t));
        end
    end
    
    %normalize weights
    weights = weights / sum(weights);
    
end

%disp(alpha);


end

