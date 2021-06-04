function out = anisotropic(in, sigma, K, iter)

    % input image dims
    [nx, ny] = size(in);
    in = im2mat(in);
    % TODO 1  
    newIm = in;
    
    for it = 1:iter
    % Loop through every pixel i,j
    for iy=2:ny-2
        for ix=2:nx-2
            e = in(iy,ix-1);
            w = in(iy,ix+1);
            s = in(iy+1,ix);
            n = in(iy-1,ix);
            east = diffCoef(e - in(iy,ix),K) * (e - in(iy,ix));
            west = diffCoef(w - in(iy,ix),K) * (w - in(iy,ix));
            south = diffCoef(s - in(iy,ix),K) * (s - in(iy,ix));
            north = diffCoef(n - in(iy,ix),K) * (n - in(iy,ix));
            pde = (sigma/4)*(east + west + south + north);
            newIm(iy,ix) = newIm(iy,ix) + (0.25 * pde);
        end
    end
    end
    out = newIm;
end