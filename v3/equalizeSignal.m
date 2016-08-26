function eqPpg = equalizeSignal(ppg, env)

    signal_avg = mean(ppg);
    
    
    posInds = find(ppg > signal_avg);
    negInds = find(ppg < signal_avg);
    
    
    eqPpg(posInds) = ppg(posInds) ./  env(posInds, 1);
    eqPpg(negInds) = ppg(negInds) ./  -env(negInds, 2);
    
    
%     figure, hold on;
%     plot(psignal);
end