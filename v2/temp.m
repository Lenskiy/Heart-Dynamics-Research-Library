ppgRed = squeeze(sum(sum(color_channels{1})));
ppgGreen = squeeze(sum(sum(color_channels{2})));
ppgBlue = squeeze(sum(sum(color_channels{3})));

signalSize = length(ppgBlue);
windowsSize = round(framerate * 5); % five seconds;

Fstop1 = 1;
Fpass1 = 2;
Fpass2 = 14;
Fstop2 = 15;
Astop1 = 15;
Apass  = 0.5;
Astop2 = 15;
Fs = 30;

% remove trends and high-frequency noise
d = designfilt('bandpassiir', ...
  'StopbandFrequency1',Fstop1,'PassbandFrequency1', Fpass1, ...
  'PassbandFrequency2',Fpass2,'StopbandFrequency2', Fstop2, ...
  'StopbandAttenuation1',Astop1,'PassbandRipple', Apass, ...
  'StopbandAttenuation2',Astop2, ...
  'DesignMethod','butter','SampleRate', Fs);

ppgRed = filter(d, (ppgRed - mean(ppgRed))/std(ppgRed));
ppgGreen = filter(d, (ppgGreen - mean(ppgGreen))/std(ppgGreen));
ppgBlue = filter(d, (ppgBlue - mean(ppgBlue))/std(ppgBlue));

minRangRed = inf;
minppgGreen = inf;
minppgBlue = inf;
for k = 1:signalSize - windowsSize
    minRangRed = min(minRangRed,range(ppgRed(k:k+windowsSize)));
    minppgGreen = min(minppgGreen,range(ppgGreen(k:k+windowsSize)));
    minppgBlue = min(minppgBlue,range(ppgBlue(k:k+windowsSize)));
end

% remove high amplitude fluctuations
beginingInd = 1;
endInd = signalSize;
for k = round(signalSize/2):-1:1
    if(ppgRed(k) > 2*minRangRed || ppgGreen(k) > 2*minppgGreen || ppgBlue(k) > 2*minppgBlue)
        beginingInd = k + 1;
        break;
    end
end

for k = round(signalSize/2):signalSize
    if(ppgRed(k) > 2*minRangRed || ppgGreen(k) > 2*minppgGreen || ppgBlue(k) > 2*minppgBlue)
        endInd = k - 1;
        break;
    end
end

ppgRed = ppgRed(beginingInd:endInd);
ppgGreen = ppgGreen(beginingInd:endInd);
ppgBlue = ppgBlue(beginingInd:endInd);
ppgRed = (ppgRed - mean(ppgRed))/std(ppgRed);
ppgGreen = (ppgGreen - mean(ppgGreen))/std(ppgGreen);
ppgBlue = (ppgBlue - mean(ppgBlue))/std(ppgBlue);
ppgGray = (ppgRed + ppgGreen + ppgBlue)/3;

framerate = 30;
ppgBlue = interp(ppgBlue,4);
framerate = 4*framerate;

