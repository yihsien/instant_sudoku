function [ alpha, trees ] = adaboost_tree( train_data, labels )
alpha = zeros(1, 200);
trees = cell(1, 200);

[num_trainex, ~] = size(train_data);

weights = ones(num_trainex, 1);
weights = weights * (1.0/num_trainex);

for t = 1 : 200
    tree = prune(ClassificationTree.fit( train_data, labels, 'Weights', weights ));
    
    trees{1, t} = tree;
    
    error = err_rate(tree, train_data, labels, weights);
    
    alpha(1, t) = 0.5 * log((1-error)/error) + log(8);
    
    for i = 1 : num_trainex
        if predict(tree, train_data(i, :)) == labels(i, 1)
            weights(i, 1) = weights(i, 1) * exp(-alpha(1, t));
        else 
            weights(i, 1) = weights(i, 1) * exp(alpha(1, t));
        end
    end
    
    weights = weights / sum(weights);
    
end

%disp(alpha);


end

