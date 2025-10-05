function [temperature,rh,bp,pm2_5] = EnvironmentalVariables(numNodes)
%ENVIRONMENTALVARIABLES Summary of this function goes here
% Environmental variables
temperature = 25 + randn(numNodes, 1) * 2;  % Temperature in °C
rh = 50 + randn(numNodes, 1) * 5;           % Relative humidity in %
bp = 1013 + randn(numNodes, 1) * 10;        % Barometric pressure in hPa
pm2_5 = 12 + randn(numNodes, 1) * 3;        % Particulate matter (ug/m3)
end

