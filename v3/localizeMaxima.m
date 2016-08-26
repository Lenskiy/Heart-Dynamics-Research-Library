function [locs, avgInterval] = localizeMaxima(ppg, fs)
    
    offset = round(fs/10);  % this constant is used in adjucting the maxima
    
    sgPPG = smooth(ppg,10, 'sgolay', 4);  % smooth the signal

	% * add moving average and pass it as a NonConstantThreshold
       
	% first iteration of finding peaks 
	[~, locs] = findpeaks_ext(sgPPG,'MaxPeakWidth', round(2*fs),...
                                              'MinPeakWidth', round(fs/15),...
                                              'MinPeakHeight',0.2*std(sgPPG),...
                                              'MinPeakDistance', round(fs/3));%,...
                                              %'NonConstantThreshold', th);

	% estimate the average distance between the beats
	% rerun the peak detection with adjusted MinPeakDistance paramter
        
	temp_hr = (length(ppg)/fs)/length(locs);
	[~, locs] = findpeaks_ext(sgPPG,'MaxPeakWidth', round(2*fs),...
                                              'MinPeakWidth', round(fs/15),...
                                              'MinPeakHeight',0.3*std(sgPPG),...
                                              'MinPeakDistance', round(0.5*fs*temp_hr));
                                          
        
	% Based on maxima in sgPPG find maxima in original PPG signal                             
	for j = 1 : length(locs)
            leftPos = max( locs(j) - offset, 1);
            rightPos = min( locs(j) + offset, length(sgPPG));
            inds = leftPos : rightPos;
            signal = ppg(inds);
            [~, mind] = max(signal);
            locs(j) = leftPos + mind - 1;
    end
                                          
	avgInterval = length(locs)/(length(ppg)/fs);
                                     
  
%   figure, hold on;
%   plot(sgPPG);
%   plot(locs,sgPPG(locs),'.', 'MarkerSize', 30);
end