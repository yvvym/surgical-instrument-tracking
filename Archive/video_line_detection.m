videoReader = VideoReader('clip_surgery.mp4');
while hasFrame(videoReader)
    frame = readFrame(videoReader);
    linedetection(frame);
    pause(1/(videoReader.FrameRate*100));
end