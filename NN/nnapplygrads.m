function nn = nnapplygrads(nn, opts)
%NNAPPLYGRADS updates weights and biases with calculated gradients
% nn = nnapplygrads(nn) returns an neural network structure with updated
% weights and biases
% обновляет веса и смещения с вычисленными градиентами
% nn = nnapplygrads (nn) возвращает структуру нейронной сети с обновленными
% весами и смещениями
    
    for i = 1 : (nn.n - 1)
        
        if(nn.weightPenaltyL2>0)
            dW = nn.dW{i} + nn.weightPenaltyL2 * nn.W{i};
            dW(:, 1) = dW(:, 1) - nn.weightPenaltyL2 * nn.W{i}(:, 1);
        else
            dW = nn.dW{i};
        end
        
        
        dW = nn.learningRate * dW;
%         if i == nn.n - 1
%             dW = dW * 100;
%         end
        if(nn.momentum>0)
            nn.vW{i} = nn.momentum*nn.vW{i} + dW;
            dW = nn.vW{i};
        end

        nn.W{i} = nn.W{i} - dW;
    end
end
