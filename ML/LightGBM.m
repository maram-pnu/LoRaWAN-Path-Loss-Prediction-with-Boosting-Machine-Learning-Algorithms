% --- MODIFIED: Updated function signature to return train and test metrics ---
function [lgbmModel, y_pred_lgbm, test_rmse, test_mae, test_r2, train_rmse, train_mae, train_r2] = LightGBM(cv, X, y, ~, ~)

    y = double(y);
    
    % --- NEW: Added data splitting logic from XGBoost.m ---
    % This ensures we have separate training and testing sets.
    numSamples = size(X, 1);
    randIndices = randperm(numSamples);
    X = X(randIndices, :);
    y = y(randIndices);

    X_train = X(training(cv), :);
    X_test = X(test(cv), :);
    y_train = y(training(cv), :);  
    y_test = y(test(cv), :);  

    % Define Bayesian Optimization Variables (unchanged)
    optimVars = [
        optimizableVariable('LearnRate', [0.01, 1], 'Type', 'real', 'Transform', 'log');
        optimizableVariable('NumLearningCycles', [10, 200], 'Type', 'integer')];

    % Define Objective Function for Optimization
    % NOTE: The underlying 'tuneLightGBM' function must use cross-validation correctly.
    objFcn = @(params) tuneLightGBM(params, X, y, cv);

    % Run Bayesian Optimization (unchanged)
    results = bayesopt(objFcn, optimVars, 'MaxObjectiveEvaluations', 14, 'UseParallel', true, 'Verbose', 1);

    % --- MODIFIED: Train the final model ONLY on the training data ---
    bestParams = results.XAtMinObjective;
    lgbmModel = fitrensemble(X_train, y_train, 'Method', 'LSBoost', 'NumLearningCycles', bestParams.NumLearningCycles, ...
        'LearnRate', bestParams.LearnRate);

    % --- MODIFIED: Replaced the entire metric calculation block ---
    
    % Part A: Calculate metrics on the TEST set
    y_pred_lgbm = predict(lgbmModel, X_test); % This is now the prediction on the test set
    mse_test = mean((y_test - y_pred_lgbm).^2);
    test_rmse = sqrt(mse_test);
    test_mae = mean(abs(y_test - y_pred_lgbm));
    ss_total_test = sum((y_test - mean(y_test)).^2);
    ss_residual_test = sum((y_test - y_pred_lgbm).^2);
    test_r2 = 1 - (ss_residual_test / ss_total_test);

    % Part B: Calculate metrics on the TRAINING set to check for overfitting
    y_pred_train = predict(lgbmModel, X_train);
    mse_train = mean((y_train - y_pred_train).^2);
    train_rmse = sqrt(mse_train);
    train_mae = mean(abs(y_train - y_pred_train));
    ss_total_train = sum((y_train - mean(y_train)).^2);
    ss_residual_train = sum((y_train - y_pred_train).^2);
    train_r2 = 1 - (ss_residual_train / ss_total_train);

end