function hrv_filtered = postprocessHRV(hrv)
    %make sure that hrv is in seconds
    %peak detection parameter that is multiplier of Standard deviation
    PEAK_DET_PAR = 4;
    
    mean_org = mean(hrv);
    %remove slow varaying components
    b = fir1(12,[0.001 0.1]);
    filteredSig = filtfilt(b,1,hrv);    
    removed_trend = hrv - filteredSig;
    mean_val = mean(removed_trend);
    std_val = std(removed_trend);
    %counter = 1;
    for i = 1:length(removed_trend) - 1
        if((removed_trend(i) < (mean_val - 3*std_val)) &&  ((mean_val +3*std_val) < removed_trend(i + 1)))
            %sp_noise_pos(counter) = (i + 1);
            %counter = counter + 1;
            hrv(i:i+1) = (hrv(i) + hrv(i+1))/2;
            removed_trend(i:i+1) = (removed_trend(i) + removed_trend(i+1))/2;
        end
        %removed_trend_sum2(i - 1) = abs(removed_trend(i) - mean_val)  + abs(removed_trend(i-1) - mean_val);
    end
    %detect peaks
    
    sp_noise_pos_sel = find(removed_trend > PEAK_DET_PAR*std(removed_trend));


    hrv_filtered = hrv;
    total_inds = 0;
    % replace with a local mean calucated for samples that are not outliers
    for i = 1 : length(sp_noise_pos_sel)
        num_repl = round(hrv_filtered(sp_noise_pos_sel(i) + total_inds - i + 1) / mean_org);
        replace_interval = hrv_filtered(sp_noise_pos_sel(i) + total_inds - i + 1) / num_repl;
            hrv_filtered = [...
                hrv_filtered(1: (sp_noise_pos_sel(i) + total_inds - i))...
                replace_interval * ones(1, num_repl)...
                hrv_filtered(sp_noise_pos_sel(i) + total_inds + 2 - i :...
                length(hrv_filtered))];
        total_inds = total_inds + num_repl;
    end

    %remove samples with duration close to zero
    zero_duration_pos = find(hrv_filtered < ((mean(hrv_filtered) - 5*std(hrv_filtered))));
    
    %figure, plot(hrv_filtered), hold on;
    %plot(zero_duration_pos, hrv_filtered(zero_duration_pos), 'r.', 'MarkerSize', 10)   
    
    for i = 1 : length(zero_duration_pos)
        if(zero_duration_pos(i) - i + 2 < length(hrv_filtered))
            hrv_filtered(zero_duration_pos(i) - i + 2) = hrv_filtered(zero_duration_pos(i) - i + 2) + hrv_filtered(zero_duration_pos(i) - i + 1);
            hrv_filtered = [hrv_filtered(1:zero_duration_pos(i) - i) hrv_filtered(zero_duration_pos(i)-i+2:length(hrv_filtered))];   
        end
    end
end