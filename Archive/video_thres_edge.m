videoReader = VideoReader('clip_surgery.mp4');
videoPlayer = vision.VideoPlayer;
load('back_BWDfill.mat');
load('instrument_mask.mat');
p = (instrument_mask==0);
p_1= (instrument_mask==1);
instrument_mask = int8(instrument_mask);
instrument_mask(p)=-1;
instrument_mask(p_1)=2;
load('brown_mask.mat');
p = (brown_mask==0);
p_1= (brown_mask==1);
brown_mask = int8(brown_mask);
brown_mask(p)=-1;
brown_mask(p_1)=2;

% initialize the background filter
initialized = false;
figure;
while hasFrame(videoReader)
    frame = readFrame(videoReader);
    % Step 1: Read Image & thresholding
    [~,thre_img] = createMask_ycbcr(frame);
%    gau_img = imgaussfilt(thre_img,8);
    gau_img = thre_img;
    I = rgb2gray(gau_img);
    % Step 2: detect edge entire cell
 %   [~,threshold] = edge(I,'Sobel');
 %   fudgeFactor = 0.5;
 %   BWs = edge(I,'Sobel',threshold * fudgeFactor);
%    BWs = edge(I,'canny');
    BWs = edge(I,'approxcanny');
%    p = remove_small_spots(BWs,50);
    % Step 3: Dilate the image
    se90 = strel('line',3,90);
    se0 = strel('line',3,0);
    BWsdil = imdilate(BWs,[se90 se0]);
    matched_res_1 = match(BWsdil,brown_mask);
    max_point = find(matched_res_1==max(matched_res_1,[],'all'));
%     matched_res_1 = matched_res_1/max(matched_res_1,[],'all');
%     max_col_r = int32(ceil(max_point/1080));
%     max_row_r = max_point-(max_col_r-1)*1080;
%     max_col_r = max_col_r + round(585/2);
%     max_col_l = max_col_r - 585;
%     max_row_r = max_row_r + 572/2;
%     max_row_l = max_row_r - 572;
%     target_area_1 = BWsdil(max(max_row_l,1):min(max_row_r,1080),max(max_col_l,1):min(max_col_r,1920));

%     % Step 4: Fill Interior Gaps
    BWdfill = imfill(BWsdil,'holes');
%     matched_res = match(BWdfill,instrument_mask);
%     max_point = find(matched_res==max(matched_res,[],'all'));
%     max_col_r = int32(ceil(max_point/1080));
%     max_row_r = max_point-(max_col_r-1)*1080;
%     max_col_r = max_col_r + round(657/2);
%     max_col_l = max_col_r - 657;
%     max_row_r = max_row_r + round(271/2);
%     max_row_l = max_row_r - 271;
%     target_area = BWdfill(max(max_row_l,1):min(max_row_r,1080),max(max_col_l,1):min(max_col_r,1920));

%     if (initialized)
%         BWdfill = BWdfill & ~back_BWDfill & ~back_BWDfill_1 & ~back_BWDfill_2 & ~back_BWDfill_3 & ~back_BWDfill_4;
%     else
%         back_BWDfill = BWdfill;
%         height = size(back_BWDfill,1);
%         width = size(back_BWDfill,2);
%         back_BWDfill_1 = [back_BWDfill(51:end,:);zeros(50,width)];   % upper
%         back_BWDfill_2 = [zeros(50,width);back_BWDfill(1:end-50,:)];   % bottom
%         back_BWDfill_3 = [zeros(height,50),back_BWDfill(:,1:end-50)]; % right
%         back_BWDfill_4 = [back_BWDfill(:,51:end),zeros(height,50)];
%         initialized = true;
%    end
    % display
    subplot(3,1,1);
    imshow(frame);
    subplot(3,1,2);
    imshow(BWsdil);
    subplot(3,1,3);
    imshow(BWdfill);
 %   title(sprintf('Current Time = %.3f sec', videoReader.CurrentTime));
    pause(1/(videoReader.FrameRate*30));
    break;
end