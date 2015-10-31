function PPG_filtered = cleanupPPG(PPG)

    b = fir1(128,[0.05 0.4]);
    PPG_filtered = filtfilt(b,1,PPG); % filter
    PPG_filtered = (PPG_filtered - mean(PPG_filtered))/std(PPG_filtered); % normalize
%     b = fir1(128,[0.05 0.4]); % filter
%     blue_ch_filtered = filtfilt(b,1,blue_ch); % normalize
%     blue_ch_filtered = (blue_ch_filtered - mean(blue_ch_filtered))/std(blue_ch_filtered);
%     
    
% 	norm_input_signals = [red_ch_filtered, blue_ch_filtered];
% 	plotArrayOfTS(norm_input_signals(:,:)', 'Original signals','time(s)', 'electorde pairs', 30);
% 	[result, W, A] = ica(norm_input_signals, 'kurt');
% 	plotArrayOfTS(result(1000:2000,:)', 'Independent components','time(s)', 'components', 30);
%    cleanPPG = norm_input_signals;
end