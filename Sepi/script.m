clear all;

load('ppgs.mat');
for j=1:3
    signal(:,j) = ppgs{1,1}{1,j};
end
clear peaks vals;
[peaks, vals] = findm(signal(:,1));

clear peaks2 vals2;
j = 1;
%cut fake peaks under lowest value real peak, 0.02 is a safe number but an
%optimal one could be found for all sets. this step can be skipped but i
%like the idea if it`s possible to execute.
for k = 1:length(vals)
    if (vals(k,1) > 0.02) 
       peaks2(j, 1) = peaks(k, 1);
       vals2(j,1) = vals(k,1);
       j = j + 1;
    end
end

clear peaks3 vals3;
peaks3 = peaks2;
vals3 = vals2;
%find fake peaks and replace them with zeros. all the the fake pings were
%very close to a real peak. the real peaks are farther away from each other
%so it is easy to find the places by checking if peaks are too close to
%each other or not and then selecting the maximum between them. for the
%first set nothing else was needed here so i just did this. i believe we
%can make an algorithm based on the statistics of indivdual signals.
for j=1:1
    for t = 1:14
        for k = 1:length(vals2)-j
            if((peaks2(k,1)-peaks2(k+j,1)) == (-t))
                if(vals2(k,1) >= vals2(k+j,1))
                    peaks3(k,1) = peaks2(k,1);
                    peaks3(k+j,1) = 0;
                    vals3(k,1) = vals2(k,1);
                    vals3(k+j,1) = 0;
                else
                    peaks3(k+j,1) = peaks2(k+j,1);
                    peaks3(k,1) = 0;
                    vals3(k+j,1) = vals2(k+j,1);
                    vals3(k,1) = 0;
                end                
            end
        end
    end
end

%checking for fake peaks in a backwards direction
for j=1:2
    for t = 1:14
        for k = 1:length(vals2)-j
            if (k>j)
                    if((peaks2(k,1)-peaks2(k-j,1)) == t)
                        if(vals2(k,1) >= vals2(k-j,1))
                            peaks3(k-j,1) = 0;
                            vals3(k-j,1) = 0;
                        else
                            peaks3(k,1) = 0;
                            vals3(k,1) = 0;
                        end
                    end
            end
        end
    end
end

%remake peaks array without zeros. now it probably has all the real peaks
clear peaks4 vals4;
j = 0;
for k=1:length(peaks3)
    if(peaks3(k,1) ~= 0)
       j = j + 1;
       peaks4(j,1) = peaks3(k,1);
       vals4(j,1) = vals3(k,1);
    end
end

%final plot
figure, hold on;
plot(signal(:,1));
plot(peaks4(:,1), signal(peaks4,1),'.','markerSize',25);

% figure, hold on;
% plot(signal(:,1));
% plot(peaks, signal(peaks,1),'.','markerSize',25);
% 
% figure, hold on;
% plot(signal(:,1));
% plot(peaks2, signal(peaks2,1),'.','markerSize',25);

% figure, hold on;
% plot(signal);
% plot(peaks3, signal(peaks3),'.','markerSize',25);

