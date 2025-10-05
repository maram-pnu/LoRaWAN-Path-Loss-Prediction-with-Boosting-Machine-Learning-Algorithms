% Clear workspace and command window
clear; clc;

addpath('\LoraWAN_PathLoss\ML'); %Add path to your ML folder
addpath('\LoraWAN_PathLoss\dataset'); %Add path to your dataset folder

% Load the CSV dataset
data = readtable("\dataset\LoRaWAN.csv"); % Replace with the path to your dataset

generation_rate = 1; % packets per second for each node
[numNodes,areaSize, initialEnergy, txEnergy, rxEnergy, simulationTime] = NetworkConfiguration();
[ptx,ltx,gtx, lrx, grx, frequency, frame_length] = LinkBudget(data);
[rssi,snr,toa] = InitializeSignalParameters(data);

[distance, ht, hr] = PhysicalGeometrical(data);
% Extract features and labels
X = table2array(data(:, {'distance', 'toa', 'snr','temperature', 'rh', 'bp', 'pm2_5'}));

% Initialize node positions and energy levels
%nodePositions = [rand(numNodes, 1) * areaSize(1), rand(numNodes, 1) * areaSize(2)];
nodeEnergy = ones(numNodes, 1) * initialEnergy;

% disp(nodePositions);
%Write2File("Node Position", "NodePosition.txt", nodePositions)
% disp(nodeEnergy);
%Write2File("Node Energy", "NodeEnergy.txt", nodeEnergy)

path_loss = ptx + gtx - ltx + grx - lrx - rssi;  % Path loss
%noise = randn(size(ptx)) * 0.05; % Add 5% random noise
%path_loss = path_loss + noise;
% disp(path_loss);
% disp(size(path_loss));

% Define a threshold for binary classification based on energy efficiency
%path_loss_threshold = median(ptx + gtx - ltx + grx - lrx - rssi);  % Using median as a threshold
% disp(path_loss_threshold);
% 
% % Create binary labels: 0 for low energy, 1 for high energy
%y = path_loss > path_loss_threshold;

y = path_loss; % RENAME y to avoid confusion

% Save performance metrics to a CSV file
metrics_table = table(data.temperature, data.rh, data.bp, data.pm2_5, y, 'VariableNames', ...
                      {'temperature', 'rh', 'bp', 'pm2_5', 'Class'});
writetable(metrics_table, './LoRaWanWithClass.csv');

%num_high_energy = sum(y);           % Number of 1s (high energy nodes)
%num_low_energy = sum(y == 0);       % Number of 0s (low energy nodes)

%fprintf('Number of nodes classified as high energy (1): %d\n', num_high_energy);
%Write2File("Binary Labels for Energy Efficiency (1 = high):", 'numberOfNodesClassified.txt', ['Number of nodes classified as high energy (1): %d\n', num_high_energy]);
%fprintf('Number of nodes classified as low energy (0): %d\n', num_low_energy);
%Write2File("Binary Labels for Energy Efficiency (0 = low):", 'numberOfNodesClassified.txt', ['Number of nodes classified as low energy (0): %d\n', num_low_energy]);
% Optionally, display y to confirm classification visually
disp('Binary Labels for Energy Efficiency (0 = low, 1 = high):');

% Number of cross-validation folds
k_fold = 5;

% Split the dataset into training and testing sets using hold-out cross-validation
cv = cvpartition(size(X, 1), 'HoldOut', 0.2);  % 80% training, 20% test split

% Initialize array to store cross-validation results for AdaBoost
%adaboost_rmse = zeros(5, 1);  % 5-fold cross-validation results

fprintf('\nTraining XGBoost for Path Loss REGRESSION...\n');
% Initialize array to store cross-validation results for XgBoost
xgboost_rmse = zeros(k_fold, 1);  % 5-fold cross-validation results

% Initialize array to store cross-validation results for LightGBM
%lgbm_rmse = zeros(5, 1);  % 5-fold cross-validation results 

% Initialize array to store cross-validation results for GentleBoost
%gentleboost_rmse = zeros(5, 1);  % 5-fold cross-validation results 
% Initialize array to store cross-validation results for LogitBoost
%logitboost_rmse = zeros(5, 1);  % 5-fold cross-validation results 


% =====================================================================
% Training Models with Bayesian Optimization
% =====================================================================

fprintf('\nTraining XGBoost with Bayesian Optimization...\n');
[xgboostModel,~,xgboost_rmse, xgboost_mae, xgboost_r2, xgboost_accuracy] = XGBoost(cv, X, y, k_fold, xgboost_rmse);

%fprintf('\nTraining LightGBM with Bayesian Optimization...\n');
%[lgbmModel,~, lgbm_rmse, lgbm_mae, lgbm_r2, lgbm_accuracy] = LightGBM(cv, X, y, k_fold, lgbm_rmse);

%fprintf('\nTraining AdaBoost with Bayesian Optimization...\n');
%[adaboostModel, ~, adaboost_rmse, adaboost_mae, adaboost_r2, adaboost_accuracy] = AdaBoost(cv, X, y, k_fold, adaboost_rmse);

%fprintf('\nTraining GentleBoost with Bayesian Optimization...\n');
%[gentleBoostModel,~, gentleboost_rmse, gentleboost_mae, gentleboost_r2, gentleboost_accuracy] = GentleBoost(cv, X, y, k_fold, gentleboost_rmse);

%fprintf('\nTraining LogitBoost with Bayesian Optimization...\n');
%[logitBoostModel,~, logitboost_rmse, logitboost_mae, logitboost_r2, logitboost_accuracy] = LogitBoost(cv, X, y, k_fold, logitboost_rmse);

% =====================================================================
% Evaluation of Models
% =====================================================================

fprintf('\nXGBoost Regression Metrics:\n');
fprintf('  RMSE: %.4f dB\n', mean(xgboost_rmse)); % Assuming xgboost_rmse is a vector from k-fold, or a single value
fprintf('  MAE:  %.4f dB\n', mean(xgboost_mae));
fprintf('  R2:   %.4f\n', mean(xgboost_r2));

save('trained_pl_regressor_model.mat', 'xgboostModel', 'X', 'y');
disp('Trained XGBoost REGRESSION model saved to trained_pl_regressor_model.mat');


fprintf('\nXGBoost Regression Labels:\n');
%labels = {"XGBoost", "LGBM"};
%rme_data = [mean(xgboost_rmse), mean(lgbm_rmse)];
%CompareBars(rme_data, labels, "Mean Squared Error");
%accuracy = [xgboost_accuracy lgbm_accuracy];
%CompareBars(accuracy, labels, "Accuracy");
% Compare Mean Absolute Error (MAE)
%mae_data = [mean(xgboost_mae), mean(lgbm_mae)];
%CompareBars(mae_data, labels, "Mean Absolute Error");
% Compare R² Score
%r2_data = [mean(xgboost_r2), mean(lgbm_r2)];
%CompareBars(r2_data, labels, "R² Score");

%Calculate RMSE from MSE
%rmse_data = sqrt(rme_data);
%CompareBars(rmse_data, labels, "Root Mean Squared Error (RMSE)");

fprintf('\nPerformance Metrics:\n');
%fprintf('Mean Squared Error (MSE):\n'); disp(rme_data);
%fprintf('Root Mean Squared Error (RMSE):\n'); disp(rmse_data);
%fprintf('Mean Absolute Error (MAE):\n'); disp(mae_data);
%fprintf('R² Score:\n'); disp(r2_data);

% % Evaluate the Ada model 
%[nodeEnergy1, throughput1,latency1, jitter1, delay1, aliveNodes1] = ProcessSimulation(data,numNodes,adaboostModel, txEnergy, rxEnergy, simulationTime, nodeEnergy, 'AdaBoost');

%DrawGraph(nodeEnergy1,throughput1, latency1, jitter1, delay1, 'AdaBoost');

% % Evaluate the XG model 
[nodeEnergy2, throughput2,latency2, jitter2, delay2, aliveNodes2] = ProcessSimulation(data,numNodes,xgboostModel, txEnergy, rxEnergy, simulationTime, nodeEnergy, 'XGBoost');

%DrawGraph(nodeEnergy2, throughput2, latency2, jitter2, delay2, 'XGBoost');

% % Evaluate the LGBM model 
%[nodeEnergy3, throughput3,latency3, jitter3, delay3, aliveNodes3] = ProcessSimulation(data,numNodes,lgbmModel, txEnergy, rxEnergy, simulationTime, nodeEnergy, 'LGBM');

%DrawGraph(nodeEnergy3, throughput3, latency3, jitter3, delay3, 'LGBM');

% Evaluate the Gentle model 
%[nodeEnergy4, throughput4,latency4, jitter4, delay4, aliveNodes4] = ProcessSimulation(data,numNodes,gentleBoostModel, txEnergy, rxEnergy, simulationTime, nodeEnergy, 'GentleBoost');

%DrawGraph(nodeEnergy4,throughput4, latency4, jitter4, delay4, 'GentleBoost');

% Evaluate the model
%[nodeEnergy5, throughput5,latency5, jitter5, delay5, aliveNodes5] = ProcessSimulation(data,numNodes,logitBoostModel, txEnergy, rxEnergy, simulationTime, nodeEnergy, 'LogitBoost');

%DrawGraph(nodeEnergy5,throughput5, latency5, jitter5, delay5, 'LogitBoost');

% =====================================================================
% Permutation Importance for Each Environmental Condition
% =====================================================================

%FeatureImportance(X, y, adaboostModel, data, 'AdaBoost');
%FeatureImportance(X, y, xgboostModel, data, 'XGBoost');
%FeatureImportance(X, y, lgbmModel, data, 'LightGBM');
%FeatureImportance(X, y, gentleBoostModel, data, 'GentleBoost');
%FeatureImportance(X, y, logitBoostModel, data, 'LogitBoost');

% =====================================================================
% Performance vs Complexity Analysis
% =====================================================================
models = {'XGBoost', 'LightGBM'};
model = {'XGBoost'};
trainTimes = zeros(1,5);
inferenceTimes = zeros(1,5);
modelSizes = zeros(1,5);
energyConsumption = zeros(1,5);
accuracy = zeros(1,5);

fprintf('\nComputing Performance vs. Complexity Analysis...\n');
X_train = X(training(cv), :);
X_test = X(test(cv), :);
y_train = y(training(cv), :);
y_test = y(test(cv), :);

for i = 1:length(models)
    modelName = models{i};
    fprintf('Measuring computational cost for %s...\n', modelName);

    % Start Timer for Training
    tic;
 %   switch modelName
%        case 'AdaBoost'
 %           [model, ~, ~, ~, ~, accuracy(i)] = AdaBoost(cv, X, y, k_fold, adaboost_rmse);
  %          nodeEnergy = nodeEnergy1;
  %      case 'XGBoost'
           [model, ~, ~, ~, ~, accuracy(i)] = XGBoost(cv, X, y, k_fold, xgboost_rmse);
    %        nodeEnergy = nodeEnergy2;
   %     case 'LightGBM'
    %        [model, ~, ~, ~, ~, accuracy(i)] = LightGBM(cv, X, y, k_fold, lgbm_rmse);
     %       nodeEnergy = nodeEnergy3;
      %  case 'GentleBoost'
       %     [model, ~, ~, ~, ~, accuracy(i)] = GentleBoost(cv, X, y, k_fold, gentleboost_rmse);
        %    nodeEnergy = nodeEnergy4;
    %    case 'LogitBoost'
     %       [model, ~, ~, ~, ~, accuracy(i)] = LogitBoost(cv, X, y, k_fold, logitboost_rmse);
      %      nodeEnergy = nodeEnergy5;
    %end
    %trainTimes(i) = toc; % Save Training Time

    % Start Timer for Inference (Measure on 100 samples)
    %tic;
    for j = 1:100
        predict(model, X_test);
        
    end
    %inferenceTimes(i) = toc / 100; % Average Inference Time per Sample

     % Store Energy Consumption (Joules)
    energyConsumption(i) = sum(nodeEnergy);

    % Compute Model Size in MB
    modelSizes(i) = whos('model').bytes / (1024 * 1024); % Convert Bytes to MB
end

% Save Performance Complexity Results
resultTable = table(models', accuracy', trainTimes', inferenceTimes', energyConsumption', modelSizes', ...
    'VariableNames', {'Model', 'Accuracy (%)', 'Training Time (s)', 'Inference Time (ms)', 'Total Energy Consumption (J)', 'Model Size (MB)'});
writetable(resultTable, fullfile(pwd, 'PerformanceComplexityAnalysis.csv'));
disp(resultTable);

DrawCompare(nodeEnergy2, nodeEnergy3, "Node Energy", numNodes);
DrawCompare(throughput2, throughput3, "Throughput", numNodes);
DrawCompare(latency2, latency3, "Latency", numNodes);
DrawCompare(jitter2, jitter3, "Jitter", numNodes);
DrawCompare(delay2, delay3, "Delay", numNodes);



% ===================================================================== 
% Define Path Loss Computation for Okumura Hata and Log Distance Models
% =====================================================================

hrx = 5;             % Receiver height in meters
htx = 40;            % Transmitter height in meters
frequencyhl = 905;     % Frequency in MHz
distancehl = 2.14;     % Distance in km
actual_path_loss = 95.00; % Measured path loss (dB)
d0 = 1; % Reference Path Loss at d0 (Assumption Based on IEEE Standard Urban Model)
PL0 = 86; % Path loss at 1 m reference distance

A = 69.55 + 26.16*log10(frequencyhl) - 13.82*log10(htx);
B = 44.9 - 6.55*log10(htx);
a_hrx = 3.2*(log10(11.75*hrx_theo))^2 - 4.97;
% =====================================================================
% Compute Log-Distance Path Loss Model
% =====================================================================

% Path loss exponent for urban areas
n = 3.5; 

% Log-Distance Model Formula
logDistanceLoss = PL0 + 10 * n * log10(distancehl / d0);

% =====================================================================
% Compute Okumura-Hata Path Loss Model
% =====================================================================

% Compute correction factor for receiver height (Urban scenario)
%c_hr = 3.2 * (log10(hrx))^2 - 4.97;

% Okumura-Hata Model Formula (Urban)
okumuraHataLoss = A + B*log10(distancehl) - a_hrx;

% =====================================================================
% Compute RMSE for Theoretical Models
% =====================================================================

ml_rmse = rmse_data;

% RMSE for Log-Distance Model
logDistance_rmse = sqrt(mean(actual_path_loss - logDistanceLoss)^2);

% RMSE for Okumura-Hata Model
okumuraHata_rmse = sqrt(mean(actual_path_loss - okumuraHataLoss)^2);

% Print Comparisom of MM Models with Log-distance and Okumura Hata models in RMSE 
fprintf('\nRMSE Comparison:\n');
%fprintf('AdaBoost RMSE: %.4f\n', ml_rmse(1));
fprintf('XGBoost RMSE: %.4f\n', ml_rmse(2));
%fprintf('LightGBM RMSE: %.4f\n', ml_rmse(3));
%fprintf('GentleBoost RMSE: %.4f\n', ml_rmse(4));
%fprintf('LogitBoost RMSE: %.4f\n', ml_rmse(5));
fprintf('Log-Distance Model RMSE: %.4f\n', logDistance_rmse);
fprintf('Okumura-Hata Model RMSE: %.4f\n', okumuraHata_rmse);

% Generate Comparison Graph

%figure;
%bar([ml_rmse logDistance_rmse okumuraHata_rmse]);
%xticklabels({'AdaBoost', 'XGBoost', 'LightGBM', 'GentleBoost', 'LogitBoost', 'Log-Distance', 'Okumura-Hata'});
%xlabel('Model');
%ylabel('RMSE');
%title('Comparison of ML Predictions with Log-Distance & Okumura-Hata Models');
%grid on;
%saveas(gcf, 'ML_vs_TheoreticalModels.png');