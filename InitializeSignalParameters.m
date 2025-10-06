function [rssi,snr,toa] = InitializeSignalParameters(data)
%INITIALIZESIGNALPARAMETERS Summary of this function goes here
% Initialize signal parameters

rssi = data.rssi;      % Received Signal Strength (dBm)
snr = data.snr;          % Signal-to-Noise Ratio (dB)
toa = data.toa;                % Time on Air (seconds)

end

