% lines is the struct, 
function points = get_line_set(point1,point2)
% input: point1 1*2 , point2 1*2
% return: points n*2
% step 1: calculate k,b
    if(point2(1) == point1(1))
         % this is a vertical line
         if(point2(2) > point1(2))
             row = point1(2):point2(2);
         else
             row = point2(2):point1(2);
         end
         col = point1(1)*ones(1,length(row));
    else
        if(point2(2) == point1(2))
            if(point2(1) > point1(1))
                col = point1(1):point2(1);
            else
                col = point2(1):point1(1);
            end
            row = point1(2)*ones(1,length(col));
        else
            k = (point2(2)-point1(2))/(point2(1)-point1(1));
            b = point2(2) - k*point2(1);
%     step 2
% =======not understanding the actual meaning of the function here=======
            range_y = abs(point2(2) - point1(2));
            range_x = abs(point2(1) - point1(1));
            if(range_y > range_x)
                if(point2(2) > point1(2))
                    row = point1(2):point2(2);
                else
                    row = point2(2):point1(2);
                end
                col = uint32((row - b)/k);
            else
                if(point2(1) > point1(1))
                    col = point1(1):point2(1);
                else
                    col = point2(1):point1(1);
                end
                row = uint32(k*col+b);            
            end
        end
    end
    points = [row',col'];
end