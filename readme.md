# Deep Learning Model for Visual Tracking

Implementation of the dlt tracker in MATLAB and testing the algorithm for quantizing weighting coefficients.
Using this tracker, you can track the trajectory of an object on a set of images in real time. 

[Link ](https://drive.google.com/drive/folders/1hMDVy6wCHM7bUr9qSfCAgDy3ooHewATX?usp=sharing) to additional information.

##Annotation

Keywords: object tracking, quantization of weights, deep learning network, number of quantization levels, neurocomputer network.
 
The object of study is a network, which refers to the type of deep training of a neurocomputer network.

Purpose of work: research, development and modification of the existing algorithm for tracking a moving object on a set of images in real time. It was achieved by modifying the DLT deep trust network using a weighting quantization algorithm.

As a result, the number of quantization levels necessary for the quantization algorithm and acceptable tracking is obtained; An analysis of the effect of quantization on tracking an object is given.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine. I spend my work on Linux OS.

From [here](http://cvlab.hanyang.ac.kr/tracker_benchmark/datasets.html) you can take sets of video frames for testing the tracker.

Next, you need to change "run_individual.m", namely:

* path with the selected test sequence, namely with the folder in which the image, format jpg or png (variable: "datePath")

* If you want to use the GPU to get better results, change the "useGpu" variable to true.

* If you want to test your sequence, you need to enter the parameters in the switch statement, as

case 'name_folder_with_img'; p = [158 106 62 78 0]; 
    opt = struct('numsample',1000, 'affsig',[4, 4,.005,.00,.001,.00]);

where:

%p = [px, py, sx, sy, theta]; - the location of the target in the first
%   frame.
%   px and py are th coordinates of the centre of the box
%   sx and sy are the size of the box in the x (width) and y (height)
%   dimensions, before rotation
%   theta is the rotation angle of the box

%'numsample',1000,   The number of samples used in the condensation
%   algorithm/particle filter.

% 'affsig',[4,4,.02,.02,.005,.001]  These are the standard deviations of
%   the dynamics distribution, that is how much we expect the target
%   object might move from one frame to the next.  The meaning of each
%   number is as follows:
%   affsig(1) = x translation (pixels, mean is 0)
%   affsig(2) = y translation (pixels, mean is 0)
%   affsig(3) = x & y scaling
%   affsig(4) = rotation angle
%   affsig(5) = aspect ratio
%   affsig(6) = skew angle

### Prerequisites

You need to install python3, pip and some packages.

For an individual launch of the program, you will need sets of video frames. I crawled ready-made kits on this [website](http://cvlab.hanyang.ac.kr/tracker_benchmark/datasets.html).

To run the program, you need to specify the path to the set in the appropriate column: (!)

If your set is not from the above set, you will need to enter the initial parameters of the object in the program (run_individual.py) 

```


```

## Running by example

download the set Car4 to your computer ....


## Built With

* [Pycharm](https://www.jetbrains.com/ru-ru/pycharm/) - development environment used
* [analog](https://github.com/lyjh/dlt_beta) - on matlab

## Authors

* **Tlepbergenova Darya ** - *MMF NSU 2020* 

See also the  [article](https://papers.nips.cc/paper/5192-learning-a-deep-compact-image-representation-for-visual-tracking.pdf).


Deep Learning Tracker to track the trajectory of the selected object. Undergraduate work.

