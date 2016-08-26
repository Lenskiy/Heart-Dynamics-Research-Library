function PPG_filtered_ = cleanupPPG(PPG)
    num_bins = 500;
    b = fir1(128,[0.05 0.4]);
    PPG_filtered = filtfilt(b,1,PPG); % filter
    
    mn = min(PPG_filtered);
    mx = max(PPG_filtered);
    
    pmf_est = hist(PPG_filtered,[mn:(mx - mn)/num_bins:mx]);
    pmf_est = pmf_est/sum(pmf_est);
    cmf_est = cumsum(pmf_est);
    q1 = find((cmf_est < 0.01) ~= 0);
    min_ampl = mn + (mx - mn) * q1(end) / num_bins;
    q2 = find((cmf_est < 0.99) ~= 0);
    max_ampl = mn + (mx - mn) * q2(end) / num_bins;
    PPG_filtered(find(min_ampl > PPG_filtered)) = min_ampl;
    PPG_filtered(find(max_ampl < PPG_filtered)) = max_ampl;
    PPG_filtered_ = PPG_filtered;
%     sampling_rate = 30;
%     window = sampling_rate;
%     for i = window + 1:length(PPG_filtered) 
%        std_i(i) = std(PPG_filtered(i-window:i));
%     end
%     std_i(1:window) = std_i(window + 1);
%     n = 10; % avergaing window
%     for i = n + 1:length(std_i)
%         std_i_m(i) = sum(std_i(i-n:i))/n;
%     end
%     std_i_m(1:n) = std_i(n + 1);
% 
%     for i = 1:length(PPG_filtered) 
%        PPG_filtered_(i) = PPG_filtered(i) / std_i_m(i);
%     end
    %PPG_filtered = filtfilt(b,1,PPG); % filter
    %PPG_filtered = (PPG_filtered - mean(PPG_filtered))/std(PPG_filtered); % normalize
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