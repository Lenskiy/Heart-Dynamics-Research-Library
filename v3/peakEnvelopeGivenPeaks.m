function env = peakEnvelopeGivenPeaks(ppg, minima, maxima)
    xq = 1:length(ppg);
    bottomEvelope = interp1(minima, ppg(minima),xq,'spline');
    topEvelope = interp1(maxima, ppg(maxima),xq,'spline');
    
    topEvelope(1: maxima(1)) = ppg(maxima(1));
    bottomEvelope(1: minima(1)) = ppg(minima(1));

    topEvelope(maxima(end): end) = ppg(maxima(end));
    bottomEvelope(minima(end): end) = ppg(minima(end));
    
    env = [topEvelope; bottomEvelope]';
end