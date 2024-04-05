% Define the parameters
n = 13; % number of sources
d = 0.5; % distance between sources in wavelengths
delta = pi/4; % phase difference in radians
theta = 0:0.01:2*pi; % angle range in radians

% Calculate the array factor
AF = sin(n*pi*d*(cos(theta)-1)+n*delta/2)./sin(pi*d*(cos(theta)-1)+delta/2);

% Plot the radiation pattern in polar coordinates
polarplot(theta,abs(AF))
title('Radiation pattern of n=13 isotropic point sources')