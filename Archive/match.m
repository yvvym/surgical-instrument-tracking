function res = match(img,mask)
    res = conv2(img,mask,'same');
end