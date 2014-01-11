function [ class ] = abpredict(alpha, dsmat, ex)
score = zeros(1, 9);

for t = 1 : 200
    c = dspredict( dsmat(t,1), dsmat(t,2), dsmat(t,3), dsmat(t,4), ex );
    score(c) = score(c) + alpha(t);
end

[~, class] = max(score);
end

