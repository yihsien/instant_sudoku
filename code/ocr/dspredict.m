function [ class ] = dspredict( splitR, splitC, label0, label1, ex )
if ex(splitR, splitC) == 0
    class = label0;
else
    class = label1;
end

end

