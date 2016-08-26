function [video, frameRate] = readVideo(file, reduction_coef)
    if(nargin() == 1)
        reduction_coef = 8;
    end
       
    xyloObj = VideoReader(file);
    vidHeight = xyloObj.Height;
    vidWidth = xyloObj.Width;
    nFrames = round(xyloObj.Duration * xyloObj.FrameRate);
    %prelocate memory
    video{1} = zeros(vidHeight/reduction_coef, vidWidth/reduction_coef,'uint8');
    video{2} = zeros(vidHeight/reduction_coef, vidWidth/reduction_coef,'uint8');
    video{3} = zeros(vidHeight/reduction_coef, vidWidth/reduction_coef,'uint8');
    k = 1;
    while hasFrame(xyloObj)
        im = readFrame(xyloObj,'native'); 
        video{1}(:,:,k) = im(1:reduction_coef:end, 1:reduction_coef:end, 1);
        video{2}(:,:,k) = im(1:reduction_coef:end, 1:reduction_coef:end, 2);
        video{3}(:,:,k) = im(1:reduction_coef:end, 1:reduction_coef:end, 3);
        k = k + 1;
        disp(['Progress: ' num2str(100 * k / nFrames, 2) '%'])
    end
    
    frameRate = xyloObj.FrameRate;
end