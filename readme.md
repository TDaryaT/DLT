# Deep Learning Model for Visual Tracking

Undergraduate work.

Implementation of the dlt tracker in MATLAB and testing the algorithm for quantizing weighting coefficients.
Using this tracker, you can track the trajectory of an object on a set of images in real time. 

[Link ](https://drive.google.com/drive/folders/1hMDVy6wCHM7bUr9qSfCAgDy3ooHewATX?usp=sharing) to additional information.

## Annotation

Keywords: object tracking, quantization of weights, deep learning network, number of quantization levels, neurocomputer network.
 
The object of study is a network, which refers to the type of deep training of a neurocomputer network.

Purpose of work: research, development and modification of the existing algorithm for tracking a moving object on a set of images in real time. It was achieved by modifying the DLT deep trust network using a weighting quantization algorithm.

As a result, the number of quantization levels necessary for the quantization algorithm and acceptable tracking is obtained; An analysis of the effect of quantization on tracking an object is given.

### Prerequisites

I advise you to read the article on the [DLT](https://papers.nips.cc/paper/5192-learning-a-deep-compact-image-representation-for-visual-tracking) tracker and the article on [the weighting coefficient quantization algorithm](http://www.mathnet.ru/php/archive.phtml?wshow=paper&jrnid=pdm&paperid=676&option_lang=rus) before starting work.

Also, you can familiarize yourself with the [interesting work](https://ieeexplore.ieee.org/document/6619156) of comparing trackers and with sequences designed specifically for such programs.

From [here](http://cvlab.hanyang.ac.kr/tracker_benchmark/datasets.html) you can take sets of video frames for testing the tracker.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine. I spend my work on Linux OS.

Next, you need to change "run_individual.m", namely:

* path with the selected test sequence, namely with the folder in which the image, format jpg or png (variable: "datePath")

```
dataPath = 'name_data_path';
```

* If you want to use the GPU to get better results, change the "useGpu" variable to true.

```
useGpu = true;
```

* If your sequence is in the statement "swich", change the value of the title variable to the desired one.

```
title = 'name_folder\title'; 
```

* If you want to test your sequence, you need to enter the parameters in the switch statement, as

```
case 'name_folder_with_img'; p = [158 106 62 78 0]; 

    opt = struct('numsample',1000, 'affsig',[4, 4,.005,.00,.001,.00]);
```
where:
 
* p = [px, py, sx, sy, theta]; - the location of the target in the first frame. 
px and py are th coordinates of the centre of the box 
sx and sy are the size of the box in the x (width) and y (height) dimensions, before rotation
theta is the rotation angle of the box

* 'numsample',1000,   The number of samples used in the condensation
algorithm/particle filter.

* 'affsig',[4,4,.02,.02,.005,.001]  These are the standard deviations of
the dynamics distribution, that is how much we expect the target
   object might move from one frame to the next.  The meaning of each
   number is as follows:

   affsig(1) = x translation (pixels, mean is 0)

   affsig(2) = y translation (pixels, mean is 0)

   affsig(3) = x & y scaling

   affsig(4) = rotation angle

   affsig(5) = aspect ratio

   affsig(6) = skew angle

## About changing the number of quantization levels

The quantization algorithm is implemented in the initialization of the network in the file "initDLT.m". 
To change the quantization level, it is necessary to excuse the loaded file:

```
 load quant_res_new_NUMBER;
```

## Running by example

download the set Car4 to your computer and follow all the instructions described above, i.e.

* In my case, the folder where the sequence is located is here:

```
dataPath = '/home/dasha/Desktop/диплом/individual_siq/';
```

* Sequence options are in "swich":

```
title = 'Woman';  
```

Next we run the file "run_individual.m" and you can see the frame-by-frame 
output of the sequence on which the trajectory of the object will be visible with a red frame.

![Image](https://github.com/TDaryaT/DLT/blob/master/img1.jpg)


## Authors

* *Tlepbergenova Darya * - *MMF NSU 2020* 

See also the exhaust thesis on [overleaf](https://github.com/TDaryaT/Deep-Learning-Tracker).