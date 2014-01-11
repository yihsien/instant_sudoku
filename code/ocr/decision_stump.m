function [ error, splitR, splitC, label0, label1 ] = decision_stump( train_data, labels, weights )

        error = Inf;
        
        [r, c, num_trainex] = size(train_data);
        
        for i = 1 : r
            for j = 1 : c
                ind0 = find(train_data(i,j,:) == 0);
        
                ind1 = find(train_data(i,j,:));
        
                labels0 = labels(ind0);
                num0 = length(labels0);
                num1 = num_trainex - num0;
                labels1 = labels(ind1);
        
                count0 = zeros(1, 9);
        
                count1 = zeros(1, 9);
        
                for a = 1 : num0
                    count0(labels0(a)) = count0(labels0(a)) + 1;
                end
       
                for a = 1 : num1
                    count1(labels1(a)) = count1(labels1(a)) + 1;
                end
        
                [~, l0] = max(count0);
        
                [~, l1] = max(count1);
            
                double e = 0.0;
                for k = 1: num_trainex
                    if train_data(i, j, k) == 0 & labels(k) ~= l0
                        e = e + weights(k);
                    end
                    
                    if train_data(i, j, k) == 1 & labels(k) ~= l1
                        e = e + weights(k);
                    end
                end
                
                if e < error
                    error = e;
                    splitR = i;
                    splitC = j;
                    label0 = l0;
                    label1 = l1;
                end
            end
        end


end

