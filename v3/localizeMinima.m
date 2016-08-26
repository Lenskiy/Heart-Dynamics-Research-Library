function min_locs = localizeMinima(ppg, locs)

        [~, mpos] = min(ppg(1:locs(1)));
        min_locs(1) = mpos;
        for j = 2:length(locs)
            [~, mpos] = min(ppg(locs(j-1):locs(j)));
            min_locs(j) = locs(j-1) + mpos - 1;
        end
end