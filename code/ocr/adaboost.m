function [ alpha, dsmat ] = adaboost( train_data, labels )
alpha = zeros(1, 200);
dsmat = zeros(200, 4);

[r, c, num_trainex] = size(train_data);

weights = ones(1, num_trainex);
weights = weights * (1.0/num_trainex);

for t = 1 : 200
    [ error, splitR, splitC, label0, label1 ] = decision_stump( train_data, labels, weights );
    
    dsmat(t, 1) = splitR;
    dsmat(t, 2) = splitC;
    dsmat(t, 3) = label0;
    dsmat(t, 4) = label1;
    
    alpha(1, t) = 0.5 * log((1-error)/error);
    
    for i = 1 : num_trainex
        if dspredict(splitR, splitC, label0, label1, train_data(:,:,i)) == labels(i)
            weights(i) = weights(i) * exp(-alpha(1, t));
        else 
            weights(i) = weights(i) * exp(alpha(1, t));
        end
    end
    
    weights = weights / sum(weights);
    
end

end

