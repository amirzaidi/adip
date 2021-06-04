function out = diffCoef(grad, K)
    out = 1 ./ (1 + (abs(grad) ./ K) .^ 2);
end