# RobustPPG: camera-based robust heart rate estimation using motion cancellation




https://user-images.githubusercontent.com/26046462/212691098-004b2f13-a595-43b3-81fb-c960ca5603ab.mp4




# Overview

This is an implementation of the paper "RobustPPG: camera-based robust heart rate estimation using motion cancellation", Akash Kumar Maity, Jian Wang, Ashutosh Sabharwal and Shree K. Nayar, in Biomedical Optics. 

In this work, we develop a motion-robust algorithm, labeled RobustPPG, for extracting photoplethysmography signals (PPG) from face video and estimating the heart rate. Our key innovation is to explicitly model and generate motion distortions due to the movements of the person’s face. Finally, we use the generated motion distortion to filter the motion-induced measurements. The overall results show improvement over the state-of-the art methods.


# Dataset 

Download our RICE-Motion dataset [here](https://rice.box.com/s/yaxfkalx400kzze2jlb02nysv7m5mxbr).

# Instructions for running the code

1. Download the pre-trained [model](https://rice.app.box.com/folder/188647757901) and one example preprocessed [data](https://rice.app.box.com/folder/188646929228) containing landmarks and face mesh information. Please paste these two folders in the code directory. Please note that in this work, we use FaceMesh from Snap Inc. for face tracking and fitting. One may use other methods like [ARKit](https://developer.apple.com/videos/play/tech-talks/601/) and [MediaPipe](https://google.github.io/mediapipe/solutions/face_mesh.html) to generate face mesh from a face video.
2. Run the `main_start.m` to generate surface normal estimates and the pixel intensity fluctuations for each traingle in the face mesh. The result in saved in `*_processed.mat`. 
3. Run the `main_process.m` to extract the PPG signal and heart rate from the distorted pixel intensity fluctuations.
