% Define the parameters
n = 5; % number of isotropic point sources
d = 0.5; % inter-element spacing in wavelengths
delta = pi/4; % phase difference in radians
freq = 2.5e9; % frequency in Hz
c = 3e8; % speed of light in m/s
lambda = c/freq; % wavelength in m
k = 2*pi/lambda; % wave number in rad/m

% Define the angles for plotting
theta = -pi/2:0.01:pi/2; % elevation angle in radians
phi = 0; % azimuth angle in radians

% Calculate the array factor
AF = zeros(size(theta)); % initialize the array factor
for n = 1:n
    AF = AF + exp(1i*(k*d*cos(theta) + delta)*(n-1)); % add the contribution of each element
end
AF = abs(AF); % take the magnitude of the array factor

% Plot the radiation pattern
polarplot(theta,AF); % plot the array factor in polar coordinates
rlim([0 n]); % set the radial limit
rticks(0:n); % set the radial ticks
thetaticks(-170:10:180); % set the angular ticks
title("Radiation pattern of n isotropic point sources");% add a title