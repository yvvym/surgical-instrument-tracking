function removed_img = remove_small_spots(bin_img,size)
    I = ones(size,size);%size is better to be around 50
    removed_img = conv2(bin_img,I,'same');
    removed_img(removed_img<175)=0;
    removed_img(removed_img~=0)=1;
end