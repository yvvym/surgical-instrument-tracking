I = imread('target.png');
I = rgb2gray(I);
[Gmag, Gdir] = imgradient(I,'prewitt');
Gmag = Gmag/max(Gmag,[],'all');
Gmag = uint8(Gmag*255);
%Gmag(Gmag>0.5)=1;
%figure
%imshowpair(Gmag, Gdir, 'montage');
%title('Gradient Magnitude, Gmag (left), and Gradient Direction, Gdir (right), using Prewitt method')
