color_ch = ExtractColorFluctuationsAdapt('/Users/artemlenskiy/Documents/Research/Data/Heart_phone_video/artem_lg4.mp4', 8);
PPG = formPPG(color_ch);
PPG = cleanupPPG(PPG);
[ibli maxtab] = extract_hrv_from_ppg(PPG);


 figure, plot((1:length(PPG(:,1)))/30,PPG(:,1)), hold on;
 plot(maxtab(:,1)/30, maxtab(:,2), '.r')

figure, plot(ibli)