%% Copyright (C) Naiyan Wang and Dit-Yan Yeung.
%% Learning A Deep Compact Image Representation for Visual Tracking. (NIPS2013')
%% All rights reserved.

% initialize variables
% clc; clear;
function results=run_DLT(seq, res_path, bSaveImage)
    addpath('affineUtility'); %добавление папок
    addpath('drawUtility');
    addpath('imageUtility');
    addpath('NN');
    
    rng(0);  rng(0);
    if isfield(seq, 'opt')%если все параметры заданы (в individual) 
        opt = seq.opt;   
    else
        trackparam_DLT;  %переходим к доопределению параметров
    end
    
    %восстонавливаем обратно нужные параметры из последов. данных
    rect=seq.init_rect;
    p = [rect(1)+rect(3)/2, rect(2)+rect(4)/2, rect(3), rect(4), 0];
    frame = imread(seq.s_frames{1});
    
    %приведение к нужному формату
    if size(frame,3)==3
        frame = double(rgb2gray(frame));
    end
    
    scaleHeight = size(frame, 1) / opt.normalHeight;
    scaleWidth = size(frame, 2) / opt.normalWidth;
    p(1) = p(1) / scaleWidth;
    p(3) = p(3) / scaleWidth;
    p(2) = p(2) / scaleHeight;
    p(4) = p(4) / scaleHeight;
    frame = imresize(frame, [opt.normalHeight, opt.normalWidth]);
    frame = double(frame) / 255;
    
    paramOld = [p(1), p(2), p(3)/opt.tmplsize(2), p(5), p(4) /p(3) / (opt.tmplsize(1) / opt.tmplsize(2)), 0];
    param0 = affparam2mat(paramOld); %из affineUtility
    
    
    if ~exist('opt','var')
        opt = [];
    end
    
    
% These are the staThese are the standard deviations of  the dynamics
% distribution, that is how much we expect the target object might move 
% from one frame to the next.  The meaning of each
% number is as follows:ndard deviations of  the dynamics distribution,
% that is how much we expect the target object might move from one frame to the next.  
% The meaning of each number iss follows:

% Подсчет смещения объекта: Аналитика первого изображения
    if ~isfield(opt,'minopt')
      opt.minopt = optimset; opt.minopt.MaxIter = 25; opt.minopt.Display='off';
    end
    reportRes = [];
    tmpl.mean = warpimg(frame, param0, opt.tmplsize);
    tmpl.basis = [];
    
    % Sample 10 positive templates for initialization
    for i = 1 : opt.maxbasis / 10
        tmpl.basis(:, (i - 1) * 10 + 1 : i * 10) = samplePos_DLT(frame, param0, opt.tmplsize);
    end
    
    % Sample 100 negative templates for initialization
    p0 = paramOld(5);
    tmpl.basis(:, opt.maxbasis + 1 : 100 + opt.maxbasis) = sampleNeg(frame, param0, opt.tmplsize, 100, opt, 8);

    param.est = param0;
    param.lastUpdate = 1;

    wimgs = [];

    % draw initial track window
    % рисуем рамку с первым изображением
    drawopt = drawtrackresult([], 0, frame, tmpl, param, []);
    drawopt.showcondens = 0;
    drawopt.thcondens = 1/opt.numsample;
    if (bSaveImage)
        imwrite(frame2im(getframe(gcf)),sprintf('%s0000.jpg',res_path));    
    end
    
    % track the sequence from frame 2 onward
    % отслеживание объекта от 2 изображения и последующих
    duration = 0;
    tic;
    if (exist('dispstr','var'))  
        dispstr = '';
    end
    L = [ones(opt.maxbasis, 1); (-1) * ones(100, 1)];
    nn = initDLT(tmpl, L);
    
    %{
    tic;
    %квантование??
    quantization_layer = 32;
    disp(["start quantization L = "  num2str(quantization_layer)]);
    for g = 1 : (nn.n - 1)
        w_max_str = max(abs(nn.W{1,g}));
        w_max = max(abs(w_max_str));
        delta = w_max/(quantization_layer - 1);
        colich = nn.size(g)+1;
        colich_2 = nn.size(g+1);
        for d = 1 : colich_2
            for e = 1 : colich
                for k = 1 : quantization_layer
                   w = nn.W{1,g}(d,e);
                    if w > (k-1)*delta && w < k*delta
                        nn.W{1,g}(d,e) = (k-1)*delta*sign(w);
                    end
                end
            end
        end
    end
    time = toc;
    disp(['end quantization ' num2str(time)]);
    %}
    
    L = [];
    pos = tmpl.basis(:, 1 : opt.maxbasis);
    pos(:, opt.maxbasis + 1) = tmpl.basis(:, 1);
    opts.numepochs = 5 ;
    
    for f = 1:size(seq.s_frames,1)  
      tic;
      frame = imread(seq.s_frames{f});
      if size(frame,3)==3
        frame = double(rgb2gray(frame));
      end  
      frame = imresize(frame, [opt.normalHeight, opt.normalWidth]);
      frame = double(frame) / 255;

      % do tracking
       param = estwarp_condens_DLT(frame, tmpl, param, opt, nn, f);

      % do update

      temp = warpimg(frame, param.est', opt.tmplsize);
      pos(:, mod(f - 1, opt.maxbasis) + 1) = temp(:);
      
      if  param.update
          opts.batchsize = 10;
          % Sample two set of negative samples at different range.
          neg = sampleNeg(frame, param.est', opt.tmplsize, 49, opt, 8);
          neg = [neg sampleNeg(frame, param.est', opt.tmplsize, 50, opt, 4)];
          
          %nn = nntrain(nn, [pos neg]', [ones(opt.maxbasis + 1, 1); zeros(99, 1)], opts);
          
          duration = duration + toc;
      
          res = affparam2geom(param.est);
          p(1) = round(res(1));
          p(2) = round(res(2)); 
          p(3) = round(res(3) * opt.tmplsize(2));
          p(4) = round(res(5) * (opt.tmplsize(1) / opt.tmplsize(2)) * p(3));
          p(5) = res(4);
          p(1) = p(1) * scaleWidth;
          p(3) = p(3) * scaleWidth;
          p(2) = p(2) * scaleHeight;
          p(4) = p(4) * scaleHeight;
          paramOld = [p(1), p(2), p(3)/opt.tmplsize(2), p(5), p(4) /p(3) / (opt.tmplsize(1) / opt.tmplsize(2)), 0];
      
          reportRes = [reportRes;  affparam2mat(paramOld)]; 
      
          tmpl.basis = [pos];   
          %рисуем следующий кадр
          drawopt = drawtrackresult(drawopt, f, frame, tmpl, param, []);
          if (bSaveImage)
             imwrite(frame2im(getframe(gcf)),sprintf('%s/%04d.jpg',res_path,f));
          end
          tic;
    end
    duration = duration + toc
    fprintf('%d frames took %.3f seconds : %.3fps\n',f,duration,f/duration);
    results.res=reportRes;
    results.type='ivtAff';
    results.tmplsize = opt.tmplsize;
    results.fps = f/duration;
end
