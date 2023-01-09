# RobustPPG: camera-based robust heart rate estimation using motion cancellation

&emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; **Input video** &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; **Rendered video**\
&emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; ![real](https://user-images.githubusercontent.com/26046462/197064760-52326d29-4b3a-419f-b825-b444d4efc2da.gif)      ![sim](https://user-images.githubusercontent.com/26046462/197064774-7ae2dabc-1015-41bd-b61d-b2e6febaa6fd.gif)

&emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; <img src="https://user-images.githubusercontent.com/26046462/197075057-cee7ff64-538c-4e7e-84d6-d2824d760cbb.gif" width="320" >  <img src="https://user-images.githubusercontent.com/26046462/197075350-f0c43665-6f87-43a2-842d-afc56f67df82.gif" width="320" >

Download our RICE-Motion dataset [here](https://rice.box.com/s/yaxfkalx400kzze2jlb02nysv7m5mxbr).

# Instructions for running the code

1. Download the pre-trained [model](https://rice.app.box.com/folder/188647757901) and one example preprocessed [data](https://rice.app.box.com/folder/188646929228) containing landmarks and face mesh information. Please paste these two folders in the code directory. Please note that in this work, we use FaceMesh from Snap Inc. for face tracking and fitting. One may use other methods like [ARKit][https://developer.apple.com/videos/play/tech-talks/601/] and [MediaPipe][https://google.github.io/mediapipe/solutions/face_mesh.html] to generate face mesh from a face video.
2. Run the `main_start.m` to generate surface normal estimates and the pixel intensity fluctuations for each traingle in the face mesh. The result in saved in `*_processed.mat`. 
3. Run the `main_process.m` to extract the PPG signal and heart rate from the distorted pixel intensity fluctuations.
