videoReader = VideoReader('clip_surgery.mp4');
videoPlayer = vision.VideoPlayer;
filter_original = importdata('blue-area-gray.mat');
compressed_filter = imresize(filter_original,1/10);
imshow(compressed_filter);
I = readFrame(videoReader);
I = rgb2gray(I);
I2 = imfilter(I,compressed_filter);
imshow(I2);
% detector = vision.ForegroundDetector;
% load('back_BWDfill.mat');
% initialize the background filter
% initialized = false;
% figure;
% while hasFrame(videoReader)
%     frame = readFrame(videoReader);
%     % Step 1: Read Image & thresholding
%     [~,thre_img] = createMask_ycbcr(frame);
%     I = rgb2gray(thre_img);
%     % Step 2: detect edge entire cell
%     I2 = conv2(I,bin_scale);
%     imshow(I2);
% %     [~,threshold] = edge(I,'sobel');
% %     fudgeFactor = 0.5;
% %     BWs = edge(I,'sobel',threshold * fudgeFactor);
% %     % Step 3: Dilate the image
% %     se90 = strel('line',3,90);
% %     se0 = strel('line',3,0);
% %     BWsdil = imdilate(BWs,[se90 se0]);
% %     % Step 4: Fill Interior Gaps
% %     BWdfill = imfill(BWsdil,'holes');
% %     if (initialized)
% %         BWdfill = BWdfill & ~back_BWDfill & ~back_BWDfill_1 & ~back_BWDfill_2 & ~back_BWDfill_3 & ~back_BWDfill_4;
% %     else
% %         back_BWDfill = BWdfill;
% %         height = size(back_BWDfill,1);
% %         width = size(back_BWDfill,2);
% %         back_BWDfill_1 = [back_BWDfill(51:end,:);zeros(50,width)];   % upper
% %         back_BWDfill_2 = [zeros(50,width);back_BWDfill(1:end-50,:)];   % bottom
% %         back_BWDfill_3 = [zeros(height,50),back_BWDfill(:,1:end-50)]; % right
% %         back_BWDfill_4 = [back_BWDfill(:,51:end),zeros(height,50)];
% %         initialized = true;
% %     end
% %     % display
% %     subplot(2,1,1);
% %     imshow(frame);
% %     subplot(2,1,2);
% %     imshow(BWdfill);
% %  %   title(sprintf('Current Time = %.3f sec', videoReader.CurrentTime));
% %     pause(1/(videoReader.FrameRate*30));
% end
