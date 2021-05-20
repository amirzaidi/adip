function out = mirroredges(in, mirrorsize)
    out = padarray(in, [mirrorsize+1 mirrorsize+1], 'both', 'symmetric');
    out(end-mirrorsize, :) = [];
    out(:, end-mirrorsize) = [];
    out(:, mirrorsize+1) = [];
    out(mirrorsize+1, :) = [];
end