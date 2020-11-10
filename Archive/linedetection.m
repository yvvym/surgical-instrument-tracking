function linedetection(I)
%I = imread('target.png');
%[~,thre_img] = createMask_ycbcr(I);
I = rgb2gray(I);
[Gmag, Gdir] = imgradient(I,'prewitt');
Gmag = Gmag/max(Gmag,[],'all');
Gmag = uint8(Gmag*255);
Gmag(Gmag>=10) = 255;
I = Gmag;

%I = I(:,1:1300);
% I = imread('circuit.tif');
%figure;
%imshow(I)
%rotI = imrotate(I,33,'crop');
%figure;
%imshow(rotI)
BW = edge(I,'canny');
%figure;
%imshow(BW);
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
imshow(Gmag), hold on

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
    %if (lines(k).point1(1) <= ?? ...)
    if ((cluster_representative_line.rho ~= lines(k).rho) || (cluster_representative_line.theta ~= lines(k).theta))
        cluster_representative_line = lines(k);
        cluster_num = cluster_num + 1;
    elseif(distance(right_points(cluster_num,:),lines(k).point1) > 200)
        cluster_representative_line = lines(k);
        cluster_num = cluster_num + 1;        
    end
    
    if ((cluster_representative_line.point1 == lines(k).point1) & (cluster_representative_line.point2 == lines(k).point2))
        % if it is the first starting point - initialize!
        left_points(cluster_num,:) = cluster_representative_line.point1;
        right_points(cluster_num,:) = cluster_representative_line.point2;
    else
%    if (lines(k).point1(2) < left_points(cluster_num,2))
%        left_points(cluster_num,:) = lines(k).point1;
%    end
%    if (lines(k).point2(2) > right_points(cluster_num,2))
        right_points(cluster_num,:) = lines(k).point2;
    end
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
%    hold on
end

for i = 1:cluster_num
   point1 = left_points(i,:);
   point2 = right_points(i,:);
   xy = [point1(1),point1(2);point2(1),point2(2)];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   hold on
end


hold off
end
% % highlight the longest line segment
% plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
% hold off