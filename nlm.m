function out = nlm(in, h, s)
    % Basically a tile-based bilateral filter.
    [nx, ny] = size(in);
    out = zeros(nx, ny);
    
    inDouble = double(in);
    inPadded = mirroredges(inDouble, 10 + 3);
    inPaddedMid = inPadded(11:(16+nx), 11:(16+ny));
    diffs = zeros(21, 21, nx + 6, ny + 6);
    weightDistPerShift = zeros(21, 21);
    for dy = -10:10
        y1 = 11 + dy;
        y2 = (16 + ny) + dy;
        for dx = -10:10
            x1 = 11 + dx;
            x2 = (16 + nx) + dx;
            inPaddedShift = inPadded(x1:x2, y1:y2);
            diffs(dx+11, dy+11, :, :) = inPaddedShift - inPaddedMid;
            weightDistPerShift(dx+11, dy+11) = exp(-(dx .^ 2 + dy .^ 2) / (s^2));
        end
    end
            
    for y = 1:ny
        for x = 1:nx
            shiftDiffs = diffs(:, :, (0:6)+x, (0:6)+y) ./ 255;
            weightValuePerShift = exp(-sum(shiftDiffs .^ 2, [3 4]) ./ (h^2));
            weightPerShift = weightDistPerShift .* weightValuePerShift;
            valuePerShift = inPadded((-10:10)+x+13, (-10:10)+y+13);
            out(x, y) = sum(weightPerShift .* valuePerShift, 'all') / sum(weightPerShift, 'all');
        end
    end
end