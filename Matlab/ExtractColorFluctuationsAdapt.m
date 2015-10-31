function color_channels = ExtractColorFluctuationsAdapt(VideoPath, reduction_coef)
    xyloObj = VideoReader(VideoPath);
    nFrames = xyloObj.NumberOfFrames;
    vidHeight = xyloObj.Height;
    vidWidth = xyloObj.Width;
       
    color_channels{1} = zeros(vidHeight/reduction_coef, vidWidth/reduction_coef, nFrames);
    color_channels{2} = zeros(vidHeight/reduction_coef, vidWidth/reduction_coef, nFrames);
    color_channels{3} = zeros(vidHeight/reduction_coef, vidWidth/reduction_coef, nFrames);
    for k = 1 : nFrames
        k/nFrames
        im = read(xyloObj, k);     
        color_channels{1}(:,:,k) = (im(1:reduction_coef:vidHeight,1:reduction_coef:vidWidth,1));
        color_channels{2}(:,:,k) = (im(1:reduction_coef:vidHeight,1:reduction_coef:vidWidth,2));
        color_channels{3}(:,:,k) = (im(1:reduction_coef:vidHeight,1:reduction_coef:vidWidth,3));
    end

end