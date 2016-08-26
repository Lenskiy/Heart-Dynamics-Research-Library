function [hrv, beats] = eqPPGtoHRV(eqPPG, fs)
    
     
        [peaks, locs] = findpeaks_ext(eqPPG,'MaxPeakWidth', round(2*fs),...
                                          'MinPeakWidth', round(fs/10),...
                                          'MinPeakHeight',0.5,...
                                          'MinPeakDistance', round(fs/10));%,...
                                          %'NonConstantThreshold', th);
                                      
          %add beat adjustment here using polynomial approximation 
         beatLocs = adjustBeats(eqPPG, locs, fs);
         
         beats =  beatLocs;                         
         hrv = diff(beatLocs);    
         
        figure, hold on;
        plot(eqPPG);
        plot(locs, eqPPG(locs),'.', 'MarkerSize', 25);         
    


    

end