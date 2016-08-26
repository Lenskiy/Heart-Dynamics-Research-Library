function beatsLocs = adjustBeats(org_signal, peaks, sf)
    leftOffset = round(sf/10);
    rightOffset = round(sf/10);
    xdata_m = -leftOffset:rightOffset;
    polynomDegree = 5;
    %Highest polynom degeree
    %approximate over
    upsampleCoef = 4;
    upSamplePeriod = 1/upsampleCoef;
    xFitting = -leftOffset:upSamplePeriod:(rightOffset);
    beatsLocs(length(peaks)) = 0;
    % Visualize
%     figure, hold on
%     plot(org_signal);
%     plot(peaks, org_signal(peaks), '.r', 'markersize', 25);
    
    for k = 1:length(peaks)
        % add a out of boundary test later
        peakShape = org_signal(peaks(k) + xdata_m);
        %reconBeatShape = fitting(xdata_m, peakShape', xFitting, polynomDegree);
        reconBeatShape = interp1(xdata_m, peakShape', xFitting, 'spline');
        [mval, ind] = max(reconBeatShape);
        beatsLocs(k) = peaks(k) + ind / upsampleCoef - leftOffset - upSamplePeriod;
        
%         % Visualize
%         plot(peaks(k) + ind / upsampleCoef  - leftOffset - upSamplePeriod, mval, 'xk', 'markersize', 10);
%         plot(peaks(k) + xFitting, reconBeatShape,'m:', 'linewidth', 2);
    end
    
    

    
% function yFitted = fitting(xdata_m, ydata_m, xFitting, polyDegree)
% 
%     %Find coefficients of the polynom with the highest degree n
%     %First we build Vandermonde matrix, that will invert later to solve SLE
%     vand = zeros(length(xdata_m), polyDegree);
%     for i = 1:length(xdata_m)
%         vand(i,polyDegree + 1) = 1; 
%         for j = 1:polyDegree
%             vand(i,j) = xdata_m(i)^(polyDegree - j + 1);
%         end
%     end
%     
%     %to solve SLE use least mean squares becase the SLE is overdetermined, the
%     %solution would be coef_ = inv(vand'*vand)*vand'*ydata_m(:);
%     %but we will use QR decomposiiton because inv(vand'*vand) may lead to 
%     %unacceptable rounding errors
%     %QR decomposition (for Java for example here http://la4j.org)
%     [Q,R] = qr(vand,0); 
%     % coeffs of the polynom, http://la4j.org also have matrix inversion
%     coef = inv(R) * Q'*ydata_m;
%     
%     %Approximating using estimated coefficients
%     yFitted = zeros(1, length(xFitting));
%     for i = 1:length(xFitting)
%         for j = 1:polyDegree+1
%             yFitted(i) = yFitted(i) + coef(j) * xFitting(i)^(polyDegree - (j-1));
%         end
%     end
