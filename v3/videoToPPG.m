function [ppg, sf] = videoToPPG(video, frameRate)
    upsampleCoef = 1;
    sf          = upsampleCoef*frameRate;

    % Pack into 1D array
    % Average i.e. sum maybe not the best representative of the
    % fluctuations
    ppg = squeeze(sum(sum(video)));
    
    % do not divide by STD here, the time-series still can have high ampl.
    ppg = ppg - mean(ppg);
    
    %remove extremly large 
    ppg(find(abs(ppg) > 4*std(ppg))) = 0; 

    signalSize = length(ppg);
    windowsSize = round(frameRate * 5); % five seconds window;
    
    % remove trends and high-frequency noise
    hF = 0.5 * frameRate;
    d = designfilt('bandpassiir', ...
      'StopbandFrequency1',0.03*hF,'PassbandFrequency1', 0.05*hF, ...
      'PassbandFrequency2',0.5*hF,'StopbandFrequency2', 0.55*hF, ...
      'StopbandAttenuation1',1,'PassbandRipple', 0.5, ...
      'StopbandAttenuation2',1, ...
      'DesignMethod','butter','SampleRate', sf);

    ppg      = filtfilt(d, (ppg - mean(ppg))/std(ppg));

%     % Find the minimal rage within a window across the signal 
%     minRangeRed = inf;
%     for k = 1:signalSize - windowsSize
%         minRangeRed = min(minRangeRed,range(ppg(k:k+windowsSize)));
%     end
% 
%     % remove high amplitude located at the beginning and the end
%     beginingInd = 1;
%     endInd = signalSize;
%     for k = round(signalSize/2):-1:1
%         if(abs(ppg(k)) > 4*minRangeRed )
%             beginingInd = k + 1;
%             break;
%         end
%     end
% 
%     for k = round(signalSize/2):signalSize
%         if(abs(ppg(k)) > 4*minRangeRed ) 
%             endInd = k - 1;
%             break;
%         end
%     end
%     
%     inds        = beginingInd:endInd;
%     if(length(inds)/length(ppg) < 0.9)
%         ppg = nan;
%     else
%         %remove high amplitudes at the end and 
%         ppg   = ppg(inds);
%         %upsample by factor 2
%         ppg      = interp(ppg,  upsampleCoef);   
%         %normalize and store in a return variable
%         ppg   = (ppg - mean(ppg))/std(ppg);
%     end

end
% add detection if the noise due to finger adjustment occured in the middle
