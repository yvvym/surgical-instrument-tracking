%function video_thres_edge(scale)
    scale = 0.25;
    videoReader = VideoReader('clip_surgery.mp4');
    %   load('back_BWDfill.mat');
    instrument_mask = load('instrument_mask.mat').instrument_mask;
    instrument_mask = imresize(instrument_mask,scale);
    p = (instrument_mask==0);
    p_1 = (instrument_mask==1);
    instrument_mask = int8(instrument_mask);
    instrument_mask(p)=-1;
    instrument_mask(p_1)=5;
    brown_mask = load('brown_mask.mat').brown_mask;
    brown_mask = imresize(brown_mask,scale);
    p = (brown_mask==0);
    p_1 = (brown_mask==1);
    brown_mask = int8(brown_mask);
    brown_mask(p)=-1;
    brown_mask(p_1)=2;
    height = ceil(1080*scale);
    width = ceil(1920*scale);
    width_brown = size(brown_mask,2);
    height_brown = size(brown_mask,1);
    width_ins = size(instrument_mask,2);
    height_ins = size(instrument_mask,1);
    target_range_row = 1:height;
    target_range_col = 1:width;
% initialize the background filter
% initialized = false;
while hasFrame(videoReader)
    frame = readFrame(videoReader);
    % Step 1: Read Image & thresholding
    frame = imresize(frame,scale);
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
    max_col_r = int32(ceil(max_point/height));
    max_row_r = int32(max_point)-(max_col_r-1)*height;
    max_col_r = max(max_col_r) + round((width_brown-1)/2);
    max_col_l = min(max_col_r) - (width_brown-1);
    max_row_r = max(max_row_r) + round((height_brown-1)/2);
    max_row_l = min(max_row_r) - (height_brown-1);
    zero = zeros(size(BWsdil,1),size(BWsdil,2));
    zero(max(max_row_l-50*scale,1):min(max_row_r+50*scale,height),max(max_col_l-50*scale,1):min(max_col_r+50*scale,width)) = 1;
    target_area_1 = BWsdil .* zero;
    
%     % Step 4: Fill Interior Gaps
    BWdfill = imfill(BWsdil,'holes');
    matched_res = match(BWdfill,instrument_mask);
    max_value = max(matched_res(target_range_row,target_range_col),[],'all');
    max_point = find(matched_res == max_value);
    left_bound = min(target_range_row)+(min(target_range_col)-1)*height;
    rightt_bound = max(target_range_row)+(max(target_range_col)-1)*height;
    max_point = max_point(max_point>=left_bound & max_point<=rightt_bound);
    max_col_r = int32(ceil(max_point/height));
    max_row_r = int32(max_point) - (max_col_r-1)*height;
    
    target_range_row = max(min(max_row_r)-100*scale,1):min(max(max_row_r)+100*scale,height);
    target_range_col = max(min(max_col_r)-100*scale,1):min(max(max_col_r)+100*scale,width);
    
    max_col_r = max(max_col_r) + round((width_ins-1)/2);
    max_col_l = min(max_col_r) - (width_ins-1);
    max_row_r = max(max_row_r) + round((height_ins-1)/2);
    max_row_l = min(max_row_r) - (height_ins-1);
    
    zero = zeros(size(BWdfill,1),size(BWdfill,2));
    zero(max(max_row_l,1):min(max_row_r+100*scale,height),max(max_col_l,1):min(max_col_r+100*scale,width)) = 1;
    target_area = BWdfill .* zero;

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
    final_target = target_area .* ~target_area_1;
    final_area = frame;
    final_area(final_target==1) = 0;
    % display 
    subplot(3,2,1);
    imshow(frame);
    title('original frame');

    subplot(3,2,2);
    
    imshow(BWdfill);
    title('filtered frame with thresholding and edging');

    subplot(3,2,3);

    imshow(target_area);
    title('instrument detection');

    subplot(3,2,4);
    
    imshow(target_area_1);
    title('eye detection');

    subplot(3,2,5);
    imshow(final_target);
    title('final detection');
    
    subplot(3,2,6);
    imshow(final_area);
    title('final detection on original frame');
 %   title(sprintf('Current Time = %.3f sec', videoReader.CurrentTime));
    pause(1/(videoReader.FrameRate*100));
  %  break;
end
%end
