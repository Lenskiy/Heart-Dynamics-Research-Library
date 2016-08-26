%% Extracting PPG from a video
% Set the path to videos
%video_path = '/Users/artemlenskiy/Documents/Research/Data/Heart_phone_video/';
% Load the videos
%[subject{1}, framerate] = readVideo([video_path 'subject1.avi']);

% Default frame rate
framerate = 30;
% Visualize video
% playVideo(subject{1}, framerate);

% videoToPPG

% Extract PPG for all subject from Red, Green and Blue channels
for k = 1:size(subject,2)
    ppgs{k}{1} = videoToPPG(subject{k}{1}, framerate);
    ppgs{k}{2} = videoToPPG(subject{k}{2}, framerate);
    ppgs{k}{3} = videoToPPG(subject{k}{3}, framerate);
end


% Go over all PPGs
for k = 1:size(ppgs, 2)
    ppg = ppgs{k}{1}; % take only red channel
    [maxLocs, avgInterval] = localizeMaxima(ppg, framerate);
    minLocs = localizeMinima(ppg, maxLocs);
    env = peakEnvelopeGivenPeaks(ppg, minLocs, maxLocs);
    eqPpg = equalizeSignal(ppg, env);
    beats = segmentBeats(ppg, minLocs, 30);
    [bestShape, beatCentroids_, goodBeatsIndx, hist] = findBestBeatShape(beats, 3);
    beatShapeVotes{k} = hist; 
    beatCentroids{k} = beatCentroids_;
    bestShapes{k} = bestShape;
    beatsLocs = adjustBeats(ppg, maxLocs(goodBeatsIndx), framerate);
    hrv = diff(beatsLocs)/framerate;
    hrv_filtered{k} = postprocessHRV(hrv);
    [power_vlf(k) power_lf(k) power_hf(k)] = estimatePowerOfHRV( hrv_filtered{k} );
end

figure, hold on;
plot3(power_vlf, power_lf, power_hf, '.', 'Markersize', 25);

