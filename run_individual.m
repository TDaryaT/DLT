%    program for individual dataset

% DESCRIPTION OF OPTIONS:
% For a new sequence you will certainly have to change p:
% * p = [px, py, sx, sy, theta]; - the location of the target in the first
%   frame.
%   px and py are th coordinates of the centre of the box
%   sx and sy are the size of the box in the x (width) and y (height)
%   dimensions, before rotation
%   theta is the rotation angle of the box
%   
%   р - начальное положение объекта

% * 'numsample',1000,   The number of samples used in the condensation
%   algorithm/particle filter.  Increasing this will likely improve the
%   results,>> load('car4_DLT.mat', 'results')
%   but make the tracker slower.
%
%   numsample - количество фильтр-часттиц из алг

% * 'condenssig',0.01,  The standard deviation of the observation likelihood
%
%   condenssing - стандартное отклонение модели = 0.01

% * 'affsig',[4,4,.02,.02,.005,.001]  These are the standard deviations of
%   the dynamics distribution, that is how much we expect the target
%   object might move from one frame to the next.  The meaning of each
%   number is as follows:
%   affsig(1) = x translation (pixels, mean is 0)
%   affsig(2) = y translation (pixels, mean is 0)
%   affsig(3) = x & y scaling
%   affsig(4) = rotation angle
%   affsig(5) = aspect ratio
%   affsig(6) = skew angle
%
%   affsig - предположительный сдвиг начального положения по параметрам p

%clear all


% Indicate whether to use GPU in computation. На моем компьюторе не может
% использоваться
global useGpu;
useGpu = false;

dataPath = '/home/dasha/Desktop/диплом/individual_siq/';

title = 'Woman'; %название датасета и папки с изображениями%

switch (title) %параметры для датасетов с сайта%
case 'davidin'; p = [158 106 62 78 0];
    opt = struct('numsample',1000, 'affsig',[4, 4,.005,.00,.001,.00]);
case 'trellis';  p = [200 100 45 49 0];
    opt = struct('numsample',1000, 'affsig',[4,4,.00, 0.00, 0.00, 0.0]);
case 'Car4';  p = [123 94 107 87 0];
    opt = struct('numsample',1000, 'affsig',[4,4,.02,.0,.001,.00]);
case 'Car1';  p = [88 139 30 25 0];
    opt = struct('numsample',1000,'affsig',[4,4,.005,.0,.001,.00]);
case 'animal'; p = [350 40 100 70 0];
    opt = struct('numsample',1000,'affsig',[12, 12,.005, .0, .001, 0.00]);
case 'shaking'; p = [250 170 60 70 0];%
    opt = struct('numsample',1000, 'affsig',[4,4,.005,.00,.001,.00]);
case 'singer1'; p = [100 200 100 300 0];
    opt = struct('numsample',1000, 'affsig',[4,4,.01,.00,.001,.0000]);
case 'bolt'; p = [292 107 25 60 0];
    opt = struct('numsample',1000, 'affsig',[4,4,.005,.000,.001,.000]);
case 'Woman';  p = [222 165 35 95 0.0];
    opt = struct('numsample',1000, 'affsig',[4,4,.005,.000,.001,.000]);               
case 'bird2';  p = [116 254 68 72 0.0];
    opt = struct('numsample',1000, 'affsig',[4,4,.005,.000,.001,.000]); 
case 'surfer';  p = [286 152 32 35 0.0];
    opt = struct('numsample',1000,'affsig',[8,8,.01,.000,.001,.000]);     
otherwise;  error(['unknown title ' title]);
end

% The number of previous frames used as positive samples.
opt.maxbasis = 10;
opt.updateThres = 0.8;

opt.condenssig = 0.01;
opt.tmplsize = [32, 32];
opt.normalWidth = 320;
opt.normalHeight = 240;
seq.init_rect = [p(1) - p(3) / 2, p(2) - p(4) / 2, p(3), p(4), p(5)];

% Load data
disp(title);
disp(dataPath);
disp('Loading data...');

fullPath = [dataPath, title, '/']; %полный путь до изображений
d = dir([fullPath, '*.jpg']); %создание дериктории в ко128торой 
                              %хранятся изображения

if size(d, 1) == 0 
    d = dir([fullPath, '*.png']);%выбор нужного формата изображений
end
if size(d, 1) == 0
    d = dir([fullPath, '*.bmp']);
end

im = imread([fullPath, d(1).name]);%чтение первого изображения в папке
                                   %теперь первый кадр назыв im

data = zeros(size(im, 1), size(im, 2), size(d, 1));
seq.s_frames = cell(size(d, 1), 1);
for i = 1 : size(d, 1)
    seq.s_frames{i} = [fullPath, d(i).name];
end
seq.opt = opt; % к последовательности добавили и обекты ort

load Woman_res_online;

%results_q = run_DLT(seq, '', false);
load Woman_res_new_L=256;
results_q.aver_disp_x = abs(results.res(:,1)-results_q.res(:,1));
results_q.aver_disp_y = abs(results.res(:,2)-results_q.res(:,2));
results_q.mean_x = mean(results_q.aver_disp_x);
results_q.mean_y = mean(results_q.aver_disp_y);
save([title '_res_new_L=256'], 'results_q'); %сохранение результатов 