function [outputX, sampled_data] = TestSample(data, numNodes)
% TestSample - This function samples the dataset for the specified number of nodes
% and extracts features required for the ProcessSimulation function.

% Sample the first 'numNodes' rows from the dataset (or randomly sample if needed)
sampled_data = data(1:numNodes, :);

% Extract features for simulation
% Use only the columns needed in ProcessSimulation for energy prediction
outputX = table2array(sampled_data(:, {'temperature', 'rh', 'bp', 'pm2_5'}));

% The fields in `sampled_data` should match those expected by ProcessSimulation:
% distance, snr, frame_length, frequency, toa, etc., are assumed to be in `data`.

end