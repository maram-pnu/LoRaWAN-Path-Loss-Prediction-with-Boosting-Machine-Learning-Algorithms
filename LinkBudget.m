function [ptx,ltx,gtx, lrx, grx, frequency, frame_length] = LinkBudget(data)
%LINKBUDGET Summary of this function goes here
% Link budget features
% ptx = 14;                             % Transmitter (EN) power (dBm)
% ltx = 1;                              % Transmitter (EN) losses (dB)
% gtx = 2;                              % Transmitter (EN) antenna gain (dBi)
% lrx = 1;                              % Receiver (GW) losses (dB)
% grx = 2;                              % Receiver (GW) antenna gain (dBi)
% frequency = 868e6;                    % Carrier frequency (Hz)
% frame_length = 50;                    % Frame length (bytes)

% Extract features directly from the dataset columns
ptx = data.ptx;                         % Transmitter (EN) power (dBm)
gtx = data.gtx;                         % Transmitter (EN) antenna gain (dBi)
ltx = data.ltx;                         % Transmitter (EN) losses (dB)
grx = data.grx;                         % Receiver (GW) antenna gain (dBi)
lrx = data.lrx;                         % Receiver (GW) losses (dB)
frequency = data.frequency;                    % Carrier frequency (Hz)
frame_length = data.frame_length;                    % Frame length (bytes)

end

