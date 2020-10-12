videoReader = VideoReader('Surgery Congenital Total Cataract.mp4');
videoPlayer = vision.VideoPlayer;
currAxes = axes;
detector = vision.ForegroundDetector;
thre = uint8(60);
while hasFrame(videoReader)
   frame = readFrame(videoReader);
%   frame = (frame >  thre);
   image(frame, 'Parent', currAxes);
 %   mask = detector(frame);
  % imshow(mask);
 %   image(mask);
   %step(videoPlayer,frame);
   title(sprintf('Current Time = %.3f sec', videoReader.CurrentTime));
   pause(1/videoReader.FrameRate);
end