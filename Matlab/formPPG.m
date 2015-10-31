function PPG = formPPG(color_channels)
    ppg_red = squeeze(sum(sum(color_channels{1})));
    ppg_green = squeeze(sum(sum(color_channels{2})));
    ppg_blue = squeeze(sum(sum(color_channels{3})));
    PPG = ppg_red;
end