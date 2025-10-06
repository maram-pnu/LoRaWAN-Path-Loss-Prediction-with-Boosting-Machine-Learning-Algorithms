function [ptx,ltx,gtx, lrx, grx, frequency, frame_length] = LinkBudget(data)
% Extract features directly from the dataset columns
ptx = data.ptx;                         % Transmitter (EN) power (dBm)
gtx = data.gtx;                         % Transmitter (EN) antenna gain (dBi)
ltx = data.ltx;                         % Transmitter (EN) losses (dB)
grx = data.grx;                         % Receiver (GW) antenna gain (dBi)
lrx = data.lrx;                         % Receiver (GW) losses (dB)
frequency = data.frequency;                    % Carrier frequency (Hz)
frame_length = data.frame_length;                    % Frame length (bytes)

end

