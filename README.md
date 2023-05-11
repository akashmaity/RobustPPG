# RobustPPG: camera-based robust heart rate estimation using motion cancellation

&emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp;
![ezgif com-gif-maker](https://user-images.githubusercontent.com/26046462/212691832-5cbe3f94-01e2-4f39-ab35-bdb5767b3359.gif)


# Overview

This is an implementation of the paper "RobustPPG: camera-based robust heart rate estimation using motion cancellation", Akash Kumar Maity<sup>*</sup>, Jian Wang, Ashutosh Sabharwal and Shree K. Nayar, in Biomedical Optics. 

In this work, we develop a motion-robust algorithm, labeled RobustPPG, for extracting photoplethysmography signals (PPG) from face video and estimating the heart rate. Our key innovation is to explicitly model and generate motion distortions due to the movements of the person’s face. Finally, we use the generated motion distortion to filter the motion-induced measurements. The overall results show improvement over the state-of-the art methods.

Publication: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9664884/.


Presentation video : https://www.youtube.com/watch?v=uxMm4vJhvFA.


# Dataset 

Download our RICE-Motion dataset [here](https://rice.box.com/s/yaxfkalx400kzze2jlb02nysv7m5mxbr).

# Instructions for running the code

1. Download the pre-trained [model](https://rice.box.com/s/71okdkjcd3owog49iu62si5yynhh4duy) and one example preprocessed [data](https://rice.app.box.com/folder/188646929228) containing landmarks and face mesh information. Please paste these two folders in the code directory. Please note that in this work, we use FaceMesh from Snap Inc. for face tracking and fitting. One may use other methods like [ARKit](https://developer.apple.com/videos/play/tech-talks/601/) and [MediaPipe](https://google.github.io/mediapipe/solutions/face_mesh.html) to generate face mesh from a face video.
2. Run the `main_start.m` to generate surface normal estimates and the pixel intensity fluctuations for each traingle in the face mesh. The result in saved in `*_processed.mat`. 
3. Run the `main_process.m` to extract the PPG signal and heart rate from the distorted pixel intensity fluctuations.
