function out = nlm(in, h, sigma_s)

    % input image dims
    [nx, ny] = size(in);
    out = zeros(nx, ny);
    outWeights = zeros(nx, ny);
    
    for y=14:ny-13
        for x=14:nx-13
            x1 = x - 3;
            x2 = x + 3;
            y1 = y - 3;
            y2 = y + 3;
            tile = in(x1:x2, y1:y2);
            
            for dy = -10:10
                for dx = -10:10
                    tile2 = in((x1:x2) + dx, (y1:y2) + dy);
                    tileDiffs = (double(tile2) - double(tile)) ./ 255;
                    tileDiffs = mean(tileDiffs .^ 2, 'all');
                    
                    value = in(x+dx, y+dy);
                    weight = exp(-tileDiffs ./ h^2);
                    out(x,y) = out(x,y) + weight * value;
                    outWeights(x,y) = outWeights(x,y) + weight;
                end
            end
        end
    end
    
    out = out ./ outWeights;
end