%% Extracting PPG from a video
% Set the path to videos
%video_path = '/Users/artemlenskiy/Documents/Research/Data/Heart_phone_video/';
% Load the videos
%[subject{1}, framerate] = readVideo([video_path 'subject1.avi']);
%[subject{1}, framerate] = readVideo([video_path 'subject2.avi']);

subjects = ['34 m'; '28 m'; '24 m';'24 m' ;'22 f' ;'42 f' ;'28 m' ;'26 m' ;'21 m' ;'25 m' ]; 
% artem_lg4.mp4   % 34 m
% jaejin2_lg4.mp4 % 28 m 
% jangwon_lg4.mp4 % 24 m
% maxim_lg4.mp4 % 24 m
% suyon_lg4.mp4 % 22 f
% leeeunyoung_lg4.mp4 %42 f
% kimseunghyon_lg4.mp4 %28 m
% nikolay_lg4.mp4 %26 m
% Joshua_z3.mp4 % 21 m
% amir_z3_25.mp4 % 25 m

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
for k = 1:size(ppgs,2);
    plot3(power_vlf(k), power_lf(k), power_hf(k), '.', 'Markersize', 25, 'color', [rand rand rand]);
end
xlabel('vlf');
ylabel('lf');
zlabel('hf');
legend(subjects);

figure, 
subplot(1,2,1), hold on;
subplot(1,2,2), hold on;
for k = 1:size(ppgs, 2)
    color = [rand rand rand];
    [mval, mind] = max(beatShapeVotes{k});
    if(rand < 0.5)
        subplot(1,2,1), plot(beatCentroids{k}(:, mind),'--', 'color', color, 'Linewidth', 2);
        subplot(1,2,2), plot(bestShapes{k}(:, mind),'--', 'color', color, 'Linewidth', 2);
    else
        subplot(1,2,1), plot(beatCentroids{k}(:, mind), 'color', color, 'Linewidth', 2);
        subplot(1,2,2), plot(bestShapes{k}(:, mind), 'color', color, 'Linewidth', 2);
    end
end
legend(subjects);


figure, hold on;
plot(hrv)
plot(hrv_filtered{k})

figure, hold on;
plot(ppg);
plot(beatsLocs, ppg(maxLocs(goodBeatsIndx)), '.', 'MarkerSize', 25);

figure, plot(hrv{k} )
X = beats(:,goodBeatsIndx)';
figure, hold on;
plot3(1*ones(30,1),1:30, X(idx==1,:)','b')
plot3(2*ones(30,1),1:30, X(idx==2,:)','r')
plot3(3*ones(30,1),1:30, X(idx==3,:)','g')
plot3(4*ones(30,1),1:30, X(idx==4,:)','k')
plot3(5*ones(30,1),1:30, X(idx==5,:)','m')
hold off

figure, plot(bestShape)
% authentication
% age
% height
% weight

figure, hold on;
plot(eqPpg)
plot(max_locs(goodBeatsIndx), eqPpg(max_locs(goodBeatsIndx)), '.', 'Markersize', 30);
for j = 1:length(goodBeatsIndx)
    text(max_locs(goodBeatsIndx(j)), eqPpg(max_locs(goodBeatsIndx(j))), num2str(j));
end

figure, hold on;
plot(ppg);
plot(env);
plot(maxLocs, ppg(maxLocs, 1), '.', 'Markersize', 30);
plot(minLocs, ppg(minLocs, 1), '.', 'Markersize', 30);


figure, hold on;
plot(ppg);
plot(max_locs, ppg(max_locs), '.', 'Markersize', 30);
plot(min_locs, ppg(min_locs), '.', 'Markersize', 30);





% Use hr as approxiamte step between the beats;
val = peakProminancy(PPG(:,3), locs{3});






figure, hold on;
plot(PPG(:,1));
plot(iPk, PPG(iPk,1),'.','MarkerSize', 30);



[hr locs] = estimateHR(PPG(:, 3), fs);
figure, plot(diff(locs));

%try adding aloo color channels
PPG(:,4) = (PPG(:,1) + PPG(:,2) + PPG(:,3))/3;
[hrv, beats] = PPG2HRV(PPG, fs);

figure, hold on;
 plot(hrv{1}/fs)
 plot(hrv{2}/fs)
 plot(hrv{3}/fs)
 plot(hrv{4}/fs, '--')

env = peakEnvelope(PPG(:,1), fs);
figure, hold on;
plot(PPG(:,1))
plot(env);



ind = 1;
figure, hold on;
plot(PPG(:,ind));
plot(beats{ind},PPG(beats{ind},ind),'.', 'markersize', 15);

figure, hold on;
for k = 1:size(hrv,2)
    plot(hrv{k})
end
plot((hrv{1} + hrv{2} + hrv{3})/3, 'linewidth', 2);