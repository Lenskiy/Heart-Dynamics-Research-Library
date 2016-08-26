function playVideo(video, frameRate)

    maxR = squeeze(max(max(video{1})));
    minR = squeeze(min(min(video{1})));
    maxG = squeeze(max(max(video{2})));
    minG = squeeze(min(min(video{2})));
    maxB = squeeze(max(max(video{3})));
    minB = squeeze(min(min(video{3})));
    
    meanR = squeeze(mean(mean(video{1})));
    meanG = squeeze(mean(mean(video{2})));
    meanB = squeeze(mean(mean(video{3})));

    
    maxRavg = mean(maxR);
    minRavg = mean(minR);
    maxGavg = mean(maxG);
    minGavg = mean(minG);
    maxBavg = mean(maxB);
    minBavg = mean(minB);
    
    minRmin = min(minR);
    minGmin = min(minG);
    minBmin = min(minB);
    maxRmax = max(maxR);
    maxGmax = max(maxG);
    maxBmax = max(maxB);
    
    normR = 255/(maxRavg - minRavg);
    normG = 255/(maxGavg - minGavg);
    normB = 255/(maxBavg - minBavg);
    w = size(video{1}, 2);
    h = size(video{1}, 1);
    numberFrames = size(video{1},3);
    for k = 1:numberFrames
        	subplot(3,2, 1); 
                surf(video{1}(:,:,k)); axis([1, w, 1, h, minRavg, maxRavg]);
                title('Red channel');
            subplot(3,2, 2);
                surf(video{2}(:,:,k)); axis([1, w, 1, h, minGavg, maxGavg]);
                title('Green channel');
            subplot(3,2, 3);
                surf(video{3}(:,:,k)); axis([1, w, 1, h, minBavg, maxBavg]);
                title('Blue channel');
            subplot(3,2, 4);
                image(cat(3, uint8(normR*(video{1}(:,:,k) - minRavg)),...
                                          uint8(normG*(video{2}(:,:,k) - minGavg)),...
                                          uint8(normB*(video{3}(:,:,k) - minBavg))));
                title('Normalized video');
            segmentToPlot = (meanR(max(1, k-100):k) - double(minRmin))./std(meanR); 
            subplot(3,2, 5:6), title('Statistics per frame'); 
            axis([max(1, k-100), k+1, min(segmentToPlot)-0.01, max(segmentToPlot)+0.01 ]);
            hold on;
            ax = plot(max(1, k-100):k, segmentToPlot, 'b'); 
            hold off;
            axis off
            pause(0.1/frameRate);
            delete(ax)
            
    end
end
