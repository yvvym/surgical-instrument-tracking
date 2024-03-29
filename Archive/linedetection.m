function linedetection(I)
%I = frame;
%[~,I] = createMask_ycbcr(I);
I = rgb2gray(I);
[Gmag, Gdir] = imgradient(I,'prewitt');
Gmag = Gmag/max(Gmag,[],'all');
Gmag = uint8(Gmag*255);
Gmag(Gmag>=10) = 255;
tmp = Gdir/360;
tmp = tmp+0.5;
tmp = uint8(tmp*255);
%I = Gmag;

BW = edge(I,'canny');
% Compute the Hough transform of the binary image returned by edge.
[H,theta,rho] = hough(BW);
% Display the transform, H, returned by the hough function.
% figure
% imshow(imadjust(rescale(H)),[],...
%        'XData',theta,...
%        'YData',rho,...
%        'InitialMagnification','fit');
% xlabel('\theta (degrees)')
% ylabel('\rho')
% axis on
% axis normal 
% hold on
% colormap(gca,hot)
% Find the peaks in the Hough transform matrix, H, using the houghpeaks function.
P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
% Superimpose a plot on the image of the transform that identifies the peaks.
x = theta(P(:,2));
y = rho(P(:,1));
%plot(x,y,'s','color','black');

% Find lines in the image using the houghlines function.
lines = houghlines(BW,theta,rho,P,'FillGap',5,'MinLength',5);
% Create a plot that displays the original image with the lines superimposed on it.
imshow(I), hold on

%max_len = 0;
%num_threashold = 4;
cluster_representative_line = lines(1);
left_points = zeros(length(lines),2);
right_points = zeros(length(lines),2);
left_points(1,:) = lines(1).point1;
right_points(1,:) = lines(1).point2;

cluster_num = 1;

for k = 1:length(lines)
    % to eliminate the border, **TODO: figure out the threasholds**
    if ((cluster_representative_line.rho ~= lines(k).rho) || (cluster_representative_line.theta ~= lines(k).theta))
        cluster_representative_line = lines(k);
        if(distance(right_points(cluster_num,:),left_points(cluster_num,:)) > 200)
            % it means that the previous line is actually not a dot!
            cluster_num = cluster_num + 1;
        end
    elseif(distance(right_points(cluster_num,:),lines(k).point1) > 200)
        if(distance(right_points(cluster_num,:),left_points(cluster_num,:)) > 200)
            % it means that the previous line is actually not a dot!
            cluster_num = cluster_num + 1;
        end
        cluster_representative_line = lines(k);
    end
    if ((cluster_representative_line.point1 == lines(k).point1) & (cluster_representative_line.point2 == lines(k).point2))
        % if it is the first starting point - initialize!
        left_points(cluster_num,:) = cluster_representative_line.point1;
        right_points(cluster_num,:) = cluster_representative_line.point2;
    else
        right_points(cluster_num,:) = lines(k).point2;
    end
end

std_pixel = zeros(1,cluster_num);
std_dir = zeros(1,cluster_num);
std_mag = zeros(1,cluster_num);

for i = 1:cluster_num
   point1 = left_points(i,:);
   point2 = right_points(i,:);
   points = get_line_set(point1,point2);
   std_pixel(i) = get_std(points,I);
   std_dir(i) = get_std(points,Gdir);
   std_mag(i) = get_std(points,Gmag);
end

[~,idx_pixel] = mink(std_pixel,3);
[~,idx_dir] = mink(std_dir,3);
[~,idx_mag] = mink(std_mag,4);

final_idx = intersect(intersect(idx_pixel,idx_dir),idx_mag);
for i = 1:length(final_idx)
   point1 = left_points(final_idx(i),:);
   point2 = right_points(final_idx(i),:);
   xy = [point1(1),point1(2);point2(1),point2(2)];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   hold on
end
hold off
end
% % highlight the longest line segment
% plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
% hold off