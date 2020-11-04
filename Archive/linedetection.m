I = imread('target.png');
[~,thre_img] = createMask_ycbcr(I);
I = rgb2gray(thre_img);
%I = I(:,1:1300);
% I = imread('circuit.tif');
figure;
imshow(I)
%rotI = imrotate(I,33,'crop');
%figure;
%imshow(rotI)
rotI = I;
BW = edge(rotI,'canny');
figure;
imshow(BW);
% Compute the Hough transform of the binary image returned by edge.
[H,theta,rho] = hough(BW);
% Display the transform, H, returned by the hough function.
figure
imshow(imadjust(rescale(H)),[],...
       'XData',theta,...
       'YData',rho,...
       'InitialMagnification','fit');
xlabel('\theta (degrees)')
ylabel('\rho')
axis on
axis normal 
hold on
colormap(gca,hot)
% Find the peaks in the Hough transform matrix, H, using the houghpeaks function.
P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
% Superimpose a plot on the image of the transform that identifies the peaks.
x = theta(P(:,2));
y = rho(P(:,1));
plot(x,y,'s','color','black');

% Find lines in the image using the houghlines function.
lines = houghlines(BW,theta,rho,P,'FillGap',5,'MinLength',5);
% Create a plot that displays the original image with the lines superimposed on it.
figure, imshow(rotI), hold on

max_len = 0;
num_threashold = 4;
cluster_representative_line = lines(1);
left_points = [];
right_points = [];
cluster_num = 1;


for k = 1:length(lines)
    % to eliminate the border, **TODO: figure out the threasholds**
    %if (lines(k).point1(1) <= ?? ...)
    if (cluster_representative_line.rho ~= lines(k).rho | cluster_representative_line.theta ~= lines(k).theta)
        cluster_representative_line = lines(k);
        cluster_num = cluster_num + 1;
    end
    
    if (cluster_representative_line.point1 == lines(k).point1 & cluster_representative_line.point2 == lines(k).point2)
        left_points(cluster_num,:) = cluster_representative_line.point1;
        right_points(cluster_num,:) = cluster_representative_line.point2;
    end
    if (lines(k).point1(2) < left_points(cluster_num,2))
        left_points(cluster_num,:) = lines(k).point1;
    end
    if (lines(k).point2(2) > right_points(cluster_num,2))
        right_points(cluster_num,:) = lines(k).point2;
    end
%    xy = [lines(k).point1; lines(k).point2]
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
%    hold on
end

for i = 1:length(left_points)
   point1 = left_points(i,:);
   point2 = right_points(i,:);
   xy = [point1(1),point1(2);point2(1),point2(2)];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   hold on
end


hold off


%   for k = 1:length(lines)
%     xy = [lines(k).point1; lines(k).point2];
%  %  xy = [219,949;1064,861];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%    % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% 
%    xy = [256,875;1064,861];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','cyan');
% % 
% %    % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% % 
%    xy = [182,1138;1035,909];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% % 
% %    % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% % 
%    xy = [253,1061;1035,909];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','cyan');
% % 
% %    % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% 
%    % Determine the endpoints of the longest line segment
%    len = norm(lines(k).point1 - lines(k).point2);
%    if (len > max_len)
%       max_len = len;
%       xy_long = xy;
%    end
%   end
% % highlight the longest line segment
% plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
% hold off