% lines is the struct, 
function points = get_line_set(lines,point1_x,point1_y,point2_x,point2_y)
%     step 1
    is_x = false;
    threashold = 10;
    points = [];
    count_point2 = 1;
    k = (point2_y-point1_y)/(point2_x-point1_x);
    b = point2_y - k*point2_x;
%     step 2
% =======not understanding the actual meaning of the function here=======
    if ((point2_y - point1_y) > (point2_x - point1_x))
        is_x = false;
    else
        if_x = true;
    end
    for i = 1:length(lines)
        pt1 = lines(i).point1;
        pt2 = lines(i).point2;
    end
end