function pathLoss = LogDistanceModel(d, f, htx, hrx, PL0, n)
    % LOGDISTANCEMODEL - Computes path loss using the Log-Distance Model
    % INPUTS:
    %   d   - Distance in meters
    %   f   - Frequency in MHz
    %   htx - Transmitter height in meters
    %   hrx - Receiver height in meters
    %   PL0 - Path loss at reference distance (1m)
    %   n   - Path loss exponent (2-6)
    % OUTPUT:
    %   pathLoss - Computed path loss

    d0 = 1; % Reference distance in meters
    pathLoss = PL0 + 10 * n * log10(d/d0); % Log-Distance Model Equation
end
