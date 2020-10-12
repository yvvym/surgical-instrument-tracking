I = rgb2gray(thre_img);
figure;
imshow(I)
title('Original Image');
% Step 2: Edge Detect Entire Cell
[~,threshold] = edge(I,'sobel');
fudgeFactor = 0.5;
BWs = edge(I,'sobel',threshold * fudgeFactor);
%BWs = BWs & ~back_BWDfill;
figure;
imshow(BWs)
title('Binary Gradient Mask')
% Step 3: Dilate the image
se90 = strel('line',3,90);
se0 = strel('line',3,0);
BWsdil = imdilate(BWs,[se90 se0]);
%BWsdil = BWsdil & ~back_BWDfill;
figure;
imshow(BWsdil)
title('Dilated Gradient Mask')
% Step 4: Fill Interior Gaps
figure;
BWdfill = imfill(BWsdil,'holes');
%BWdfill = BWdfill & ~back_BWDfill & ~back_BWDfill_1 & ~back_BWDfill_2 & ~back_BWDfill_3 & ~back_BWDfill_4;
imshow(BWdfill)
title('Binary Image with Filled Holes')