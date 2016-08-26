function [minLocs_, maxLocs_] = removeSmallRangePeaks(ppg, minLocs, maxLocs)
    removeMax = [];
    removeMin = [];
    minLocs_ = [];
    maxLocs_ = [];
    for k = 2:length(minLocs)-1
        dif_prev = ppg(maxLocs(k - 1)) - ppg(minLocs(k - 1));
        dif_cur = ppg(maxLocs(k)) - ppg(minLocs(k));
        dif_next = ppg(maxLocs(k + 1)) - ppg(minLocs(k + 1));
      
        if(dif_cur < 0.1*(dif_prev + dif_next))
            removeMax = [removeMax k];
            removeMin = [removeMin k];
        else
            minLocs_ = [minLocs_, minLocs(k)];
            maxLocs_ = [maxLocs_, maxLocs(k)];
        end
    end
    
    
end