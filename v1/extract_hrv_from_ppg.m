function [ibli maxtab] = extract_hrv_from_ppg(original_ppg)
    samplingrate = 30;
    signal_length = length(original_ppg);
    length_threshold = 4;
    minimum_beat_range = samplingrate/10;
    plot_range = 2200:3600;
    %plot_range = 0*samplingrate+1:length(original_ppg);%10*samplingrate;
    %corrected fi= filtered_signal;
    beat_threshold = std(original_ppg)/4;
    zero_ind = find(original_ppg < beat_threshold);
    ppg = original_ppg;
    ppg(zero_ind) = 0;
    %figure('Position', [100, 100, 540, 257]), hold on, plot(plot_range/samplingrate, original_ppg(plot_range)); title('Detected beats');
    %%  ( 1 )  Detect the beginning and the end of the range of a beat candidate 
    % (3, a) Find the beginning of each beat 
    
    nzi = find(ppg ~= 0);
    j = 1;
    beat_width(j) = 0;
    beat_begins(j) = nzi(1);
    counter = 0;
    for i = 2:length(nzi)
        beat_width;
        if nzi(i) - nzi(i-1) == 1
            counter = counter + 1;
            beat_width(j) = counter;
        else
            j = j + 1;
            beat_begins(j) = nzi(i);
            counter = 0;
        end
    end
    % (3, c) if the width of a beat candidate is small, skip it
    beats_ind = find(beat_width >= minimum_beat_range);
    for i = 1:length(beats_ind)
        [val pos] =  max(ppg(beat_begins(beats_ind(i)):beat_begins(beats_ind(i))+beat_width(beats_ind(i))));
        peaks(i) = beat_begins(beats_ind(i)) + pos - 1; 
    end
    
    %% (4) Approximate every blink range with a polynomial function, and check that 
    % the function is concave 
    %figure, plot(plot_range,ppg(plot_range)), hold on;
    sel_peaks = beat_begins;
    sel_peaks = [];
    for i = 1:length(peaks)
        Y = ppg(beat_begins(beats_ind(i)) : beat_begins(beats_ind(i)) + beat_width(beats_ind(i)));
        X = (0:length(Y) - 1);
        X_ = (0:1/4:length(Y) - 1); % 1/4 is a coefficient for upsampling to improve beat detection 
        P = polyfit(X,Y,3);
        %Y_approx = P(1)*X_.*X_ + P(2)*X_ + P(3);
        Y_approx = P(1)*X_.*X_.*X_ + P(2)*X_.*X_ + P(3)*X_ + P(4);
        [max_val max_pos] = max(Y_approx);
        [min_val min_pos] = min(Y_approx);
        
        if((Y_approx(1) < max_val && Y_approx(end) < max_val) && ...
               (atan2((max_val - Y_approx(1)),   (max_pos/250)) * 180/pi) > 70 &&...
               sum(sqrt(diff(Y).^2 + 1)) > length_threshold);% &&  ... 
               % min_val == min(Y_approx(1), Y_approx(end)))
               
            sel_peaks(length(sel_peaks) + 1) = beat_begins(beats_ind(i)) + max_pos/4;
            blink_range = X + beat_begins(beats_ind(i));
%               if(plot_range(1) < blink_range(1) && blink_range(end) < plot_range(end)) % Just for plotting
%                   plot((blink_range(1):1/4:blink_range(end))/samplingrate, Y_approx, 'k:', 'LineWidth', 2);
%                   plot((blink_range(1))/samplingrate, Y_approx(1), 'ro', 'MarkerSize', 5);
%                   plot((blink_range(end))/samplingrate, Y_approx(end), 'ro', 'MarkerSize', 5);
%                   plot((blink_range(1) + (max_pos-1)/4)/samplingrate, max_val, 'ro', 'MarkerSize', 5);
%               end
        end
    end

   ibli = diff(sel_peaks)/samplingrate; 
   maxtab = [round(sel_peaks); original_ppg(round(sel_peaks))];
   maxtab(:, 1) = uint32(maxtab(:,1));
%    plot(maxtab(:,1), maxtab(:,2),'r.');
%     ibli = diff(max_loc)/250; 
        
%      figure, hold on,
%      plot((1:length(original_ppg))/samplingrate,original_ppg)    
%      plot(maxtab(:,1)/samplingrate, maxtab(:,2), 'r.');
%      axis([0 length(original_ppg)/samplingrate min(original_ppg) - abs(0.05*min(original_ppg)) max(original_ppg) + abs(0.05*max(original_ppg))]);
 %    figure, plot(ibli);        
end