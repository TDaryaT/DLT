function newNN = initDLT(tmpl, L)
    %load pretrain;
    load quant_res_new_2;
    global useGpu;
    newNN = nnsetup([1024 2560 1024 512 256 1]);
    %{
    tic;
    quantization_layer = 256;
    %квантование??
    disp(['start quantization L = ' num2str(quantization_layer)]);
    for g = 1 : 4
        w_max_str = max(abs(W{1,g}));
        w_max = max(abs(w_max_str));
        delta = w_max/(quantization_layer - 1);
        colich = newNN.size(g)+1;
        colich_2 = newNN.size(g+1);
        for d = 1 : colich_2
            for e = 1 : colich
                for k = 1 : quantization_layer
                   w = abs(W{1,g}(d,e));
                    if w > (k-1)*delta && w < k*delta
                        W{1,g}(d,e) = (k-1)*delta*sign(W{1,g}(d,e));
                    end
                end
            end
        end
    end
    time = toc;
    disp(['end quantization ' num2str(time)]);
    save(['quant_res_new_' int2str(quantization_layer)],'W');
    %}
    for i = 1 : 4
        if useGpu
            newNN.W{i} = gpuArray(W{i});
        else
            newNN.W{i} = W{i};
        end
    end
    newNN.weightPenaltyL2 = 2e-3;
    newNN.activation_function = 'sigm';
    newNN.learningRate = 1e-1;
    newNN.momentum = 0.5;
    opts.numepochs = 20;
    opts.batchsize = 10;
    
    L(L == -1) = 0;
    
    newNN = nntrain(newNN, tmpl.basis', L, opts);
    clear nn;
end