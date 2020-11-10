function dist = distance(point1,point2)
    tmp = (point1-point2).^2;
    dist = sqrt(sum(tmp));
end