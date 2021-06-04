function out = anisotropic(in, lambda, K, iter)

    % input image dims
    [nx, ny] = size(in);
    
    % TODO 1  
    newIm = mirroredges(in, 1);
    shifts = zeros(nx, ny, 8);
    
    for it = 1:iter
        in = newIm(2:(end-1), 2:(end-1));
        shifts(:, :, 1) = newIm((2:end-1) - 1, (2:end-1) - 1) - in; %NW
        shifts(:, :, 2) = newIm((2:end-1), (2:end-1) - 1) - in; %N
        shifts(:, :, 3) = newIm((2:end-1) + 1, (2:end-1) - 1) - in; %NE
        shifts(:, :, 4) = newIm((2:end-1) - 1, (2:end-1)) - in; %W
        shifts(:, :, 5) = newIm((2:end-1) + 1, (2:end-1)) - in; %E
        shifts(:, :, 6) = newIm((2:end-1) - 1, (2:end-1) + 1) - in; %SW
        shifts(:, :, 7) = newIm((2:end-1), (2:end-1) + 1) - in; %S
        shifts(:, :, 8) = newIm((2:end-1) + 1, (2:end-1) + 1) - in; %SE
        
        shifts = diffCoef(shifts, K) .* shifts;
        pde = lambda .* mean(shifts, 3);
        newIm(2:(end-1), 2:(end-1)) = in + (0.25 .* pde);
        
%         % Loop through every pixel i,j
%         for iy=2:ny-2
%             for ix=2:nx-2
%                 e = in(iy, ix+1);
%                 w = in(iy, ix-1);
%                 s = in(iy+1, ix);
%                 n = in(iy-1, ix);
% 
%                 eg = e - in(iy, ix);
%                 wg = w - in(iy, ix);
%                 sg = s - in(iy, ix);
%                 ng = n - in(iy, ix);
% 
%                 east = diffCoef(eg, K) * eg;
%                 west = diffCoef(wg, K) * wg;
%                 south = diffCoef(sg, K) * sg;
%                 north = diffCoef(ng, K) * ng;
% 
%                 pde = lambda * (east + west + south + north)/4;
%                 newIm(iy,ix) = newIm(iy,ix) + (0.25 * pde);
%             end
%         end
    end
    out = newIm(2:(end-1), 2:(end-1));
end