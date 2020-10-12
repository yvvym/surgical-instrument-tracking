%% Detect Moving Cars In Video
% Create a video source object to read file.
%%
videoSource = VideoReader('clip_surgery.mp4');
%% 
% Create a detector object and set the number of training frames to 5 (because 
% it is a short video.) Set initial standard deviation.
%%
detector = vision.ForegroundDetector;
%% 
% Perform blob analysis.
%%
blob = vision.BlobAnalysis(...
       'CentroidOutputPort', false, 'AreaOutputPort', false, ...
       'BoundingBoxOutputPort', true, ...
       'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 250);
%% 
% Insert a border.
%%
shapeInserter = vision.ShapeInserter('BorderColor','White');
%% 
% Play results. Draw bounding boxes around cars.
%%
videoPlayer = vision.VideoPlayer();
while hasFrame(videoSource)
     frame  = readFrame(videoSource);
     fgMask = detector(frame);
     bbox   = blob(fgMask);
     out    = shapeInserter(frame,bbox);
     videoPlayer(out);
     pause(1/videoSource.FrameRate);
end
%% 
% Release objects.
%%
release(videoPlayer);

%% 
% Copyright 2012 The MathWorks, Inc.