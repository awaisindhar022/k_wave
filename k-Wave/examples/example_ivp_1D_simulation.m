% Simulations In One Dimension Example
%
% This example provides a simple demonstration of using k-Wave for the
% simulation and detection of the pressure field generated by an initial
% pressure distribution within a one-dimensional heterogeneous propagation
% medium. It builds on the Homogeneous Propagation Medium and Heterogeneous
% Propagation Medium examples.
%
% author: Bradley Treeby
% date: 14th July 2009
% last update: 13th April 2017
%  
% This function is part of the k-Wave Toolbox (http://www.k-wave.org)
% Copyright (C) 2009-2017 Bradley Treeby

% This file is part of k-Wave. k-Wave is free software: you can
% redistribute it and/or modify it under the terms of the GNU Lesser
% General Public License as published by the Free Software Foundation,
% either version 3 of the License, or (at your option) any later version.
% 
% k-Wave is distributed in the hope that it will be useful, but WITHOUT ANY
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
% more details. 
% 
% You should have received a copy of the GNU Lesser General Public License
% along with k-Wave. If not, see <http://www.gnu.org/licenses/>. 

clearvars;

% =========================================================================
% SIMULATION
% =========================================================================

% create the computational grid
Nx = 512;       % number of grid points in the x (row) direction
dx = 0.05e-3;   % grid point spacing in the x direction [m]
kgrid = kWaveGrid(Nx, dx);

% define the properties of the propagation medium
medium.sound_speed = 1500 * ones(Nx, 1);    % [m/s]
medium.sound_speed(1:round(Nx/3)) = 2000;	% [m/s]
medium.density = 1000 * ones(Nx, 1);        % [kg/m^3]
medium.density(round(4*Nx/5):end) = 1500;   % [kg/m^3]

% create initial pressure distribution using a smoothly shaped sinusoid
x_pos = 280;    % [grid points]
width = 100;    % [grid points]
height = 1;     % [au]
in = (0:pi/(width/2):2*pi).';
source.p0 = [zeros(x_pos, 1); ((height/2) * sin(in - pi/2) + (height/2)); zeros(Nx - x_pos  - width - 1, 1)];

% create a Cartesian sensor mask
sensor.mask = [-10e-3, 10e-3];  % [mm]

% set the simulation time to capture the reflections
t_end = 2.5 * kgrid.x_size / max(medium.sound_speed(:));

% define the time array
kgrid.makeTime(medium.sound_speed, [], t_end);

% run the simulation
sensor_data = kspaceFirstOrder1D(kgrid, medium, source, sensor, 'PlotLayout', true);

% =========================================================================
% VISUALISATION
% =========================================================================

% plot the recorded time signals
figure;
plot(sensor_data(1, :), 'b-');
hold on;
plot(sensor_data(2, :), 'r-');
axis tight;
set(gca, 'YLim', [-0.1, 0.7]);
ylabel('Pressure');
xlabel('Time Step');
legend('Sensor Position 1', 'Sensor Position 2');