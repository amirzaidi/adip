% Progrmming assignment for AP3132-Advanced Digital Image Processing course
% Instructor: B. Rieger, F. Vos 
% Tutor: H. Heydarian
% Term: Q3-2021
%
% Labwork #2
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem #1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part a: dilation and erosion

% read the original input image
I = imread('trui.tif');
dipshow(mat2im(I));
title('original image')

% add proper noise to make the image the same as the one depicted in the 
% manual (top-right in Figure 1)
% TODO3
J = noise(mat2im(I), 'gaussian', 10.0);
dipshow(J)
title('noisy image')


F = anisotropic(J, 0.08, 30, 100);
dipshow(F)
title('filtered image')
