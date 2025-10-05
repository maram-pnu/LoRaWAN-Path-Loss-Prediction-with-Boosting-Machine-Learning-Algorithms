function [xgboostModel, y_pred_xgboost, xgboost_rmse, xgboost_mae, xgboost_r2, accuracy] = XGBoost(cv, X, y, ~, ~)

    numSamples = size(X, 1);
    randIndices = randperm(numSamples);
    X = X(randIndices, :);
    y = y(randIndices);

    X_train = X(training(cv), :);
    X_test = X(test(cv), :);
    y_train = double(y(training(cv), :));  
    y_test = double(y(test(cv), :));  

    % Define Bayesian Optimization Variables
    optimVars = [
        optimizableVariable('NumLearningCycles', [10, 200], 'Type', 'integer');
        optimizableVariable('LearnRate', [0.01, 1], 'Type', 'real', 'Transform', 'log');
        optimizableVariable('MaxDepth', [2, 10], 'Type', 'integer')
    ];

    % Objective Function for Optimization
    objFcn = @(params) tuneXGBoost(params, X, y, cv);

    % Run Bayesian Optimization
    results = bayesopt(objFcn, optimVars, 'MaxObjectiveEvaluations', 14, 'Verbose', 1);

    % Train Final Model with Optimized Parameters
    bestParams = results.XAtMinObjective;
    xgboostModel = fitrensemble(X_train, y_train, 'Method', 'LSBoost', ...
        'NumLearningCycles', bestParams.NumLearningCycles, ...
        'LearnRate', bestParams.LearnRate, ...
        'Learners', templateTree('MaxNumSplits', bestParams.MaxDepth));

    % Predict on test data
    y_pred_xgboost = predict(xgboostModel, X_test);

    % Compute Evaluation Metrics
    mse = mean((y_test - y_pred_xgboost).^2);
    xgboost_rmse = sqrt(mse);
    xgboost_mae = mean(abs(y_test - y_pred_xgboost));
    y_mean = mean(y_test);
    ss_total = sum((y_test - y_mean).^2);
    ss_residual = sum((y_test - y_pred_xgboost).^2);
    xgboost_r2 = 1 - (ss_residual / ss_total);

    % Compute Accuracy
    confMat = confusionmat(round(y_test), round(y_pred_xgboost));  
    accuracy = sum(diag(confMat)) / sum(confMat(:)) * 100;

    % Print and Save Metrics
    Write2File("XGBoost Accuracy", "XGBoostResults.txt", [num2str(accuracy), '%']);
    Write2File("Mean Squared Error", "XGBoostResults.txt", num2str(mse));
    Write2File("RMSE", "XGBoostResults.txt", num2str(xgboost_rmse));
    Write2File("MAE", "XGBoostResults.txt", num2str(xgboost_mae));
    Write2File("R² Score", "XGBoostResults.txt", num2str(xgboost_r2));

end