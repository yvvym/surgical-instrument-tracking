% videoReader = VideoReader('clip_surgery.mp4');
% videoPlayer = vision.VideoPlayer;
% frame = readFrame(videoReader);

%get masked image from segmenter (maskedImage)
masked_image = importdata('brown-area-rgb.mat');
gray_scale = rgb2gray(masked_image);
thresold = graythresh(gray_scale);
bin_scale = im2bw(gray_scale,thresold);