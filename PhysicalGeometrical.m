function [distance, ht, hr] = PhysicalGeometrical(data)

distance = data.distance;  % Distance between EN and GW (in meters)
ht = data.ht;                             % Antenna height of the EN (in meters)
hr = data.hr;                              % Antenna height of the GW (in meters)
end

