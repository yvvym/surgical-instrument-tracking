function std_t = get_std(points,properties)
    num = size(points,1);
    val = zeros(1,num);
    for i = 1:num
        val(i) = properties(points(i,1),points(i,2));
    end
    std_t = std(val);
end