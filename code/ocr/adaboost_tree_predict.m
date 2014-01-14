function [ class ] = adaboost_tree_predict( alpha, trees, ex )
%function predicts the class of observation ex using the training results
%of adaboost_tree, which are alpha and trees
%ex is a row vector
%class is an int between 1 and 9
score = zeros(1, 9);

for t = 1 : 200
    c = predict(trees{1, t}, ex);
    %disp(c);
    score(1, c) = score(1, c) + alpha(1, t);
end
%disp(score);
[~, class] = max(score);


end

