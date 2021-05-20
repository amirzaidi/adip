function out = bilateral(in, sigma_t, sigma_s)

    % input image dims
    [nx, ny] = size(in);

    % TODO 1
    totals = zeros(nx, ny);
    weights = zeros(nx, ny);
    
    coords_x = 1:nx;
    coords_y = 1:ny;
    radius = ceil(sigma_s * 3);
    for dy = -radius:radius
        cy = max(1, min(ny, coords_y + dy));
        for dx = -radius:radius
            cx = max(1, min(nx, coords_x + dx));
            
            in_shifted = in(cx, cy);
            weight_spatial = dx ^ 2 + dy ^ 2;
            weight_spatial = exp(-weight_spatial / (sigma_s ^ 2));
            weight_tonal = (in_shifted - in) .^ 2;
            weight_tonal = exp(-weight_tonal ./ (sigma_t ^ 2));
            weight = weight_spatial .* weight_tonal;
            
            totals = totals + weight .* in_shifted;
            weights = weights + weight;
        end
    end
    
    out = totals ./ weights;
    
end