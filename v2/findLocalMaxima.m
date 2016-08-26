%--------------------------------------------------------------------------
function [iPk, iInflect] = findLocalMaxima(yTemp)
    % bookend Y by NaN and make index vector
    yTemp = [NaN; yTemp; NaN];
    iTemp = (1:numel(yTemp)).';

    % keep only the first of any adjacent pairs of equal values (including NaN).
    yFinite = ~isnan(yTemp);
    iNeq = [1; 1 + find((yTemp(1:end-1) ~= yTemp(2:end)) & ...
                        (yFinite(1:end-1) | yFinite(2:end)))];
    iTemp = iTemp(iNeq);

    % take the sign of the first sample derivative
    s = sign(diff(yTemp(iTemp)));

    % find local maxima
    iMax = 1 + find(diff(s)<0);

    % find all transitions from rising to falling or to NaN
    iAny = 1 + find(s(1:end-1)~=s(2:end));

    % index into the original index vector without the NaN bookend.
    iInflect = iTemp(iAny)-1;
    iPk = iTemp(iMax)-1;
end