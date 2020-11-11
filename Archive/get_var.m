function variance = get_var(lines, image, rho, theta)
%     variance = 0;
    values = [];
    count_values = 0;
%     threashold = 10;
    for i = 1:length(lines)
       if (rho == lines(i).rho & theta == lines(i).thate)
          count_values++;
          values(count_values) += image(lines(i).point1(1),lines(1).point1(2));
          count_values++;
          values(count_values) = image(lines(i).point2(1),lines(1).point2(2));
       end
    end
    variance = var(values)
end