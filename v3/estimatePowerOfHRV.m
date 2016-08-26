function [power_vlf power_lf power_hf] = estimatePowerOfHRV(hrv)
    % 1     ~ 33 Hz
    % 1/825 ~ 0.04 Hz
    % 1/220 ~ 0.15 Hz
    % 1/82  ~ 0.40 Hz 
    vlf_coef =fir1(64,[0.001 0.04]);
    lf_coef = fir1(64, [0.04 0.15]); 
    hf_coef = fir1(64, [0.16 0.4]);
    vlf = filtfilt(vlf_coef,1,hrv);
    lf = filtfilt(lf_coef,1,hrv);
    hf = filtfilt(hf_coef,1,hrv);

    power_vlf = sum((vlf-mean(vlf)).^2);
    power_lf = sum(lf.^2);
    power_hf = sum(hf.^2);
end