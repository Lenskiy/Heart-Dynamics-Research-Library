subject{1} = ExtractColorFluctuationsAdapt('/Users/artemlenskiy/Documents/Research/Data/Heart_phone_video/artem_lg4.mp4', 8);   % 34 m
subject{2} = ExtractColorFluctuationsAdapt('/Users/artemlenskiy/Documents/Research/Data/Heart_phone_video/jaejin2_lg4.mp4', 8); % 28 m 
subject{3} = ExtractColorFluctuationsAdapt('/Users/artemlenskiy/Documents/Research/Data/Heart_phone_video/jangwon_lg4.mp4', 8); % 24 m
subject{4} = ExtractColorFluctuationsAdapt('/Users/artemlenskiy/Documents/Research/Data/Heart_phone_video/maxim_lg4.mp4', 8);   % 24 m
subject{5} = ExtractColorFluctuationsAdapt('/Users/artemlenskiy/Documents/Research/Data/Heart_phone_video/suyon_lg4.mp4', 8);   % 22 f
subject{6} = ExtractColorFluctuationsAdapt('/Users/artemlenskiy/Documents/Research/Data/Heart_phone_video/leeeunyoung_lg4.mp4', 8); %42 f
subject{7} = ExtractColorFluctuationsAdapt('/Users/artemlenskiy/Documents/Research/Data/Heart_phone_video/kimseunghyon_lg4.mp4', 8); %28 m
subject{8} = ExtractColorFluctuationsAdapt('/Users/artemlenskiy/Documents/Research/Data/Heart_phone_video/nikolay_lg4.mp4', 8); %26 m

for i = 1:size(subject,2)
    i
    PPG = formPPG(subject{i});
    PPG_ = cleanupPPG(PPG);
    PPG_ = PPG_(1:8968);
    [ibli maxtab] = extract_hrv_from_ppg(PPG_);
    hrv_filtered = removePeaksinHRV(ibli);
    subject_hrv{i} = hrv_filtered;
    [power_vlf power_lf power_hf] = estimatePowerOfHRV(hrv_filtered);
    subject_powers(i,:) = [power_vlf power_lf power_hf];
    variation(i) = std(subject_hrv{i});
end

figure(10), hold on;
set(gca, 'YTick', []);
axis([0 600 + 30 0 15]);
title('Inter-blink interval dynamics extracted while memory testing')
plot_step = 1.8;

for i = 1:size(subject_hrv,2);
	color = [rand rand rand];
        figure(10), line([0 600],[(i-1)*plot_step (i-1)*plot_step], 'Color', [0.2 0.2 0.2]);
        figure(10), plot(subject_hrv{i} + (i-1)*plot_step, 'color', color);
        figure(10), text(-20, (i-1)*plot_step + 1, num2str(i), 'color', color);
end

figure,  hold on;
for i = 1:8
    plot3(subject_powers(i, 1), subject_powers(i, 2), subject_powers(i, 3), '.');
end


% plot_range = 2200:3600;
% figure('Position', [100, 100, 540, 257]), hold on; title('');
% xlabel('Intensity'); ylabel('Frames');
% plot(plot_range, PPG(plot_range));
% figure('Position', [100, 100, 540, 257]), hold on; title('');
% xlabel('Intensity'); ylabel('Frames');
% plot(plot_range, PPG_(plot_range));
% figure('Position', [100, 100, 540, 257]), hold on; title('');
% xlabel('Intensity'); ylabel('Frames');
% plot(plot_range, PPG_(plot_range));
% figure('Position', [100, 100, 540, 257]), hold on; title('Heart Rate Variability');
% xlabel('Length of intevals'); ylabel('Intervals');
% plot(ibli);
% figure('Position', [100, 100, 540, 257]), hold on; title('Corrected Heart Rate Variability');
% xlabel('Length of intevals'); ylabel('Intervals');
% plot(hrv_filtered);

mintab = findMins(PPG, maxtab);

figure('Position', [100, 100, 540, 257]), plot((1:length(PPG(1,:)))/30,PPG(1,:)), hold on;
plot(maxtab(1,:)/30, maxtab(2,:), '.r')
plot(mintab(1,:)/30, mintab(2,:), '.g');
 
hrv_filtered = removePeaksinHRV(ibli);
figure, plot(hrv_filtered)

[power_vlf power_lf power_hf] = estimatePowerOfHRV(hrv_filtered);