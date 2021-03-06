function [bestShape, beatCentroids, goodBeatsIndx, bestShapeHist] = findBestBeatShape(beats, num)
    maxErr = 0.5;
    %In case if num is 1, no clustering is performed;
    if nargin == 1 || num == 1
        num = 1; 
        totalBeats = size(beats,2);
        sizeSubSet = round(0.5*totalBeats);
        error = inf*ones(1, totalBeats);
        for beat_ind = 1:totalBeats
            for k = 1:10
                subset = datasample(beats',sizeSubSet,'Replace',false);
                e = mean(sqrt(sum(bsxfun(@minus, beats(:,beat_ind), subset').^2)));
                error(beat_ind) = min(e, error(beat_ind));
            end
        end
        
        [errors, inds]= sort(error);
        bestShape = beats(:, inds(1:num));
        goodBeatsIndx = find(error < maxErr);
        bestShapeHist = size(beats,2);
    else
        [idx, beatCentroidsAll, sumD, D] = kmeans(beats', num, 'Distance', 'correlation',...
                                       'Start', 'sample',...
                                       'EmptyAction', 'singleton',...
                                       'OnlinePhase' , 'on');
                                   
        bestShapeHist = sum(full(ind2vec(idx'))');
        counter = 1;
        for k = 1:num
            [mval mind]= min(D(:,k));
            if(bestShapeHist(k) > 0.1*sum(bestShapeHist))
                bestShape(:, counter) = beats(:, mind);
                beatCentroids(:, counter) = beatCentroidsAll(k, :);
                counter = counter + 1;
            end
        end
        goodBeatsIndx = find(min(D') < maxErr);                                
    end


end
% figure,
% subplot(1,2,1),plot3(1*ones(30,1),1:30, beats(:, idx==1)','b'), hold on;
% subplot(1,2,1),plot3(2*ones(30,1),1:30, beats(:, idx==2)','r')
% subplot(1,2,1),plot3(3*ones(30,1),1:30, beats(:, idx==3)','g')
% hold off
% xlabel('clusters')
% grid on
% ylabel('samples')
% subplot(1,2,2), bar(bestShapeHist)
% subplot(1,2,2), xlabel('clusters')
% subplot(1,2,2), ylabel('times')
% figure, hold on;
% plot(mean(bestShape'));
% plot(beats(:, goodBeatsIndx(3)));
% 
% x1 = bestShape;
% x2 = beats(:, 364);
% % Euclidian
% sqrt(sum((x1 - x2).^2))
% % Correlation distance
% 1 - (x1 - mean(x1))' * (x2 - mean(x2)) /(norm(x1 - mean(x1)) * norm(x2 - mean(x2)))

 