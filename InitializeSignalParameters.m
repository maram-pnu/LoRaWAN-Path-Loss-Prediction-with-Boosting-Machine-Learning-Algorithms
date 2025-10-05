function [rssi,snr,toa] = InitializeSignalParameters(data)
%INITIALIZESIGNALPARAMETERS Summary of this function goes here
% Initialize signal parameters
% rssi = -120 + randn(numNodes, 1) * 10;      % Received Signal Strength (dBm)
% snr = 10 + randn(numNodes, 1) * 2;          % Signal-to-Noise Ratio (dB)
% toa = rand(numNodes, 1) * 2;                % Time on Air (seconds)

rssi = data.rssi;      % Received Signal Strength (dBm)
snr = data.snr;          % Signal-to-Noise Ratio (dB)
toa = data.toa;                % Time on Air (seconds)

end

