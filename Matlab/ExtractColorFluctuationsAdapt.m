function [red_ch green_ch blue_ch] = ExtractColorFluctuationsAdapt(VideoPath)
    reduction_factor = 8;
    xyloObj = VideoReader(VideoPath);
    nFrames = xyloObj.NumberOfFrames;
    vidHeight = xyloObj.Height;
    vidWidth = xyloObj.Width;
       
    red_ch = zeros(vidHeight/reduction_factor, vidWidth/reduction_factor, nFrames);
    green_ch = zeros(vidHeight/reduction_factor, vidWidth/reduction_factor, nFrames);
    blue_ch = zeros(vidHeight/reduction_factor, vidWidth/reduction_factor, nFrames);
    for k = 1 : nFrames
        k/nFrames
        im = read(xyloObj, k);     
        red_ch(:,:,k) = (im(1:reduction_factor:vidHeight,1:reduction_factor:vidWidth,1));
        green_ch(:,:,k) = (im(1:reduction_factor:vidHeight,1:reduction_factor:vidWidth,2));
        blue_ch(:,:,k) = (im(1:reduction_factor:vidHeight,1:reduction_factor:vidWidth,3));
    end

    
end