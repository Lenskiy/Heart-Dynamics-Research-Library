function beats = segmentBeats(ppg, minima, beatLength)
    xq = 1:beatLength;
    for k = 1:length(minima) - 1
        beat = ppg(minima(k)+1:minima(k+1));
        sp = (length(beat) - 1)/beatLength;
        xq = 1:sp:(length(beat) - sp);
        beats(:, k) = interp1(1:length(beat),beat,xq, 'linaer');
    end
    
end