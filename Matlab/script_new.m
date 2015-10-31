[red_ch green_ch blue_ch] = ExtractColorFluctuationsAdapt('/Users/artemlenskiy/Documents/Research/Data/Heart_phone_video/artem_lg4.mp4');
ppg_red = squeeze(sum(sum(red_ch)));
ppg_green = squeeze(sum(sum(green_ch)));
ppg_blue = squeeze(sum(sum(blue_ch)));

ppg = cleanupPPG(ppg_red, ppg_blue);

[ibli maxtab] = extract_hrv_from_ppg(ppg(:,1));


% figure, plot((1:length(ppg(:,1)))/30,ppg(:,1)), hold on;
% plot(maxtab/30, maxtab, '.r')

figure, plot(ibli)