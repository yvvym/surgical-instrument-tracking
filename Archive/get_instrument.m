videoReader = VideoReader('clip_surgery.mp4');
videoPlayer = vision.VideoPlayer;
frame = readFrame(videoReader);

%get masked image from segmenter (maskedImage)
masked_image = importdata('instrument-rgb.mat');
gray_scale = rgb2gray(masked_image);
thresold = graythresh(gray_scale);
bin_scale = im2bw(gray_scale,thresold);
bin_scale_batch = [];
for i = 0:5:360
   rotate = imrotate(bin_scale,i);
   [a,b] = find(rotate==1);
%    crop = imcrop(rotate,[a(1),b(1),1000,1000]);
%    imshow(crop);
end
% imshow(masked_image);
% imshow(gray_scale);
% imshow(bin_scale);