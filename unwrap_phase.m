%% 2D unwrapping algorithm

clear
clc
close all

% The base unwrapping algorithm is presented in the following article.
% M. A. Herraez, D. R. Burton, M. J. Lalor, and M. A. Gdeisat, *"Fast
% two-dimensional phase-unwrapping algorithm based on sorting by reliability
% following a noncontinuous path"*, Applied Optics, Vol. 41, Issue 35, pp. 7437-7444 (2002).

%% Pre-processing
img_name = '2K_mod.bmp';
X = imread(img_name);   % Image reader
img = im2double(X);     % Convert to double precision
colormap(gray(256));    % Set gray intensity map to 0-255        
img = (img*2*pi)- pi;   % Convert to [-pi pi]

% Print the number pixels in row and column
num_row = size(img,1);
num_col = size(img,2);

% Wrapping
wimg = wrapTo2Pi(img); % wrap angles in radians to [0 2pi]

% Unwrapping
unwrap_img = unwrap_phase(wimg); % Call unwrap function


%% Post processing
figure;

% Find offset intensity values to make Mn = 0
temporary = unwrap_img*(255/(2*pi));
temporary_Mx = max(max(temporary));    
temporary_Mn = min(min(temporary));    
offset = temporary_Mn;

% Convert phase to intensity values with offset applied
unwrap_img = unwrap_img*(255/(2*pi)) - offset; % Convert phase to internsity values
Mx = max(max(unwrap_img));    % Find maximum intensity
Mn = min(min(unwrap_img));    % Find minimum intensity

% Temperature profile
Th = 37;
Tc = 35;
T = (((Tc-Th)/(Mx-Mn))*unwrap_img) + Th;
imagesc(T);
title('Temperature profile');
colorbar;
axis off

% Normalised temperature profile
figure
Tm = (Th + Tc)/2;
T_norm = (T - Tm)/(Th - Tc);
imagesc(T_norm);
title('Normalised temperature profile');
colorbar;
axis off
