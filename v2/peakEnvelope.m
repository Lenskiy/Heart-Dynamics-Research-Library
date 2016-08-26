function env = peakEnvelope(signal, windowSize)

    windowSize = round(windowSize);
    env = zeros(length(signal),2);
    for k = 1:length(signal) - windowSize
        env(k + round(windowSize/2) , 1) = max(signal(k:k+windowSize));
        env(k + round(windowSize/2) , 2) = min(signal(k:k+windowSize));
    end
    env(1: round(windowSize/2), 1) = env(round(windowSize/2) +1, 1);
    env(length(signal) - round(windowSize/2) + 1: length(signal), 1)...
         = env(length(signal) - round(windowSize/2), 1);
    env(1: round(windowSize/2), 2) = env(round(windowSize/2) +1, 2);
    env(length(signal) - round(windowSize/2) + 1: length(signal), 2)...
         = env(length(signal) - round(windowSize/2), 2);  
%     
% figure, hold on;
% plot(signal)
% plot(env);

    coeffMA = ones(1, windowSize)/windowSize;
    env = filter(coeffMA, 1, env);
    env(1:end - round(windowSize/2), 1) = env(round(windowSize/2)+1:end, 1);
    env(1:end - round(windowSize/2), 2) = env(round(windowSize/2)+1:end, 2);
    env(end - round(windowSize/2): end, 1) = env(end - round(windowSize/2), 1);
    env(end - round(windowSize/2): end, 2) = env(end - round(windowSize/2), 2);
    
end