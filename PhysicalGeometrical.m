function [distance, ht, hr] = PhysicalGeometrical(data)
%PHYSICALGEOMETRICAL Summary of this function goes here
% Define physical/geometrical conditions
% distance = rand(numNodes, 1) * 5000;  % Distance between EN and GW (in meters)
% ht = 1.5;                             % Antenna height of the EN (in meters)
% hr = 15;                              % Antenna height of the GW (in meters)

distance = data.distance;  % Distance between EN and GW (in meters)
ht = data.ht;                             % Antenna height of the EN (in meters)
hr = data.hr;                              % Antenna height of the GW (in meters)
end

