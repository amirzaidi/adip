function out = nlm(in, valueSigma, distSigma, tileRadius, searchRadius)
    % Basically a tile-based bilateral filter.
    [nx, ny] = size(in);
    out = zeros(nx, ny);
    
    % Some useful intermediates.
    valueSigmaSqr = valueSigma ^ 2;
    distSigmaSqr = distSigma ^ 2;
    searchRange = -searchRadius:searchRadius;
    searchSize = 2 * searchRadius + 1;
    tileSearchRadius = tileRadius + searchRadius;
    
    inDouble = double(in);
    inPadded = mirroredges(inDouble, tileSearchRadius);
    
    % This is the area we will compare every shift with.
    inPaddedMid = inPadded( ...
        searchRadius + (1:(2 * tileRadius + nx)), ...
        searchRadius + (1:(2 * tileRadius + ny)) ...
    );
    
    diffs = zeros(searchSize, searchSize, nx + 2 * tileRadius, ny + 2 * tileRadius);
    weightDistPerShift = zeros(searchSize, searchSize);
    
    % For each search offset in [-searchRadius, searchRadius], calculate
    % the per-pixel difference with the unshifted version.
    for dy = -searchRange
        y1 = searchRadius + 1 + dy;
        y2 = (searchRadius + 2 * tileRadius + ny) + dy;
        for dx = -searchRange
            x1 = searchRadius + 1 + dx;
            x2 = (searchRadius + 2 * tileRadius + nx) + dx;
            
            % The shifted window.
            inPaddedShift = inPadded(x1:x2, y1:y2);
            
            diffs(dx+searchRadius+1, dy+searchRadius+1, :, :) = (inPaddedShift - inPaddedMid) .^ 2;
            
            % Pre-calculate euclidian distance table here.
            weightDistPerShift(dx+11, dy+11) = exp(-(dx .^ 2 + dy .^ 2) / distSigmaSqr);
        end
    end
    
    % For every output pixel, take a tile of differences around every shift.
    for y = 1:ny
        for x = 1:nx
            shiftDiffs = diffs(:, :, (0:6)+x, (0:6)+y) ./ 255;
            
            % Weights similar to a bilateral filter, gaussian distributions
            % for values and distances.
            weightValuePerShift = exp(-sum(shiftDiffs, [3 4]) ./ valueSigmaSqr);
            weightPerShift = weightDistPerShift .* weightValuePerShift;
            
            valuePerShift = inPadded(searchRange + x + tileSearchRadius, searchRange + y + tileSearchRadius);
            out(x, y) = sum(weightPerShift .* valuePerShift, 'all') / sum(weightPerShift, 'all');
        end
    end
end