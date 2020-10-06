video_object = VideoReader('clip_surgery.mp4');
nframes = get(video_object, 'NumFrames');
for k = 1:nframes
%     video read and simple modifications
    current_frame = read(video_object, k);
    current_frame_gray = rgb2gray(current_frame);
    current_frame_bw = imbinarize(uint8(current_frame_gray), graythresh(current_frame_gray));
%     figure(1);
%     subplot(2,2,1);
%     imshow(current_frame);
%     title('original video');
%     subplot(2,2,2);
%     imshow(current_frame_gray);
%     title('gray scale video')
%     subplot(2,2,3);
%     imshow(current_frame_bw);
%     title('binary video');
    
    
    
%     edge detection
    [~, threshold] = edge(current_frame_gray, 'Sobel');
    fudge_factor = 0.5;
    current_frame_edge_Sobel = edge(current_frame_gray,'Sobel',threshold * fudge_factor);
%     morphological operations
    se90 = strel('line',3,90);
    se0 = strel('line',3,0);
    current_frame_dilate = imdilate(current_frame_edge_Sobel, [se90,se0]);
    current_frame_fill = imfill(current_frame_dilate, 'holes');
    figure(2);
    subplot(2,2,1);
    imshow(current_frame_edge_Sobel);
    title('edge detected with Sobel');
    subplot(2,2,2);
    imshow(current_frame_dilate);
    title('dilated image');
    subplot(2,2,3);
    imshow(current_frame_fill);
    title('filled image');
    
%     color channel separation
%     current_frame_red = current_frame(:,:,1);
%     current_frame_green = current_frame(:,:,2);
%     current_frame_blue = current_frame(:,:,3);
%     figure(3);
%     subplot(2,2,1);
%     imshow(current_frame);
%     title('original frame');
%     subplot(2,2,2);
%     imshow(current_frame_red);
%     title('red');
%     subplot(2,2,3);
%     imshow(current_frame_green);
%     title('green');
%     subplot(2,2,4);
%     imshow(current_frame_blue);
%     title('blue');
   
   
end