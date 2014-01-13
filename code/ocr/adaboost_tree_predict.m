function [ class ] = adaboost_tree_predict( alpha, trees, ex )
score = zeros(1, 9);

for t = 1 : 200
    c = predict(trees{1, t}, ex);
    %disp(c);
    score(1, c) = score(1, c) + alpha(1, t);
end
%disp(score);
[~, class] = max(score);


end

