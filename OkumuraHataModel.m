function pathLoss = OkumuraHataModel(d, f, htx, hrx, env)
    % OKUMURAHATAMODEL - Computes path loss using the Okumura-Hata Model
    % INPUTS:
    %   d   - Distance in km
    %   f   - Frequency in MHz
    %   htx - Transmitter height in meters
    %   hrx - Receiver height in meters
    %   env - Environment ('urban', 'suburban', 'rural')
    % OUTPUT:
    %   pathLoss - Computed path loss

    % Correction Factor for Mobile Station Antenna Height
    if f >= 150 && f <= 1500
        ahm = (1.1 * log10(f) - 0.7) * hrx - (1.56 * log10(f) - 0.8);
    else
        ahm = 3.2 * (log10(11.75 * hrx))^2 - 4.97;
    end

    % Compute Path Loss
    pathLoss = 69.55 + 26.16 * log10(f) - 13.82 * log10(htx) - ahm + (44.9 - 6.55 * log10(htx)) * log10(d);

    % Apply Environment Correction Factor
    if strcmp(env, 'suburban')
        pathLoss = pathLoss - 2 * (log10(f / 28))^2 - 5.4;
    elseif strcmp(env, 'rural')
        pathLoss = pathLoss - 4.78 * (log10(f))^2 + 18.33 * log10(f) - 40.94;
    end
end