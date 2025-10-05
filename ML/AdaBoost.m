function [adaboostModel, y_pred_adaboost, adaboost_rmse, adaboost_mae, adaboost_r2, accuracy] = AdaBoost(cv, X, y, ~, ~)

    fprintf('\nTest 1...\n');

    % Shuffle dataset for randomized cross-validation
    numSamples = size(X, 1);
    randIndices = randperm(numSamples);
    X = X(randIndices, :);
    y = y(randIndices); 

    fprintf('\nTest 2...\n');

    X_train = X(training(cv), :);
    X_test = X(test(cv), :);
    y_train = y(training(cv), :);
    y_test = y(test(cv), :);

    fprintf('\nTest 3...\n');

    % Define Bayesian Optimization Variables
    optimVars = [
    optimizableVariable('LearnRate', [0.01, 1], 'Type', 'real', 'Transform', 'log');
    optimizableVariable('NumLearningCycles', [10, 200], 'Type', 'integer')];

    % Objective Function for Optimization
    objFcn = @(params) tuneAdaBoost(params, X, y, cv);

    % Run Bayesian Optimization
    results = bayesopt(objFcn, optimVars, 'MaxObjectiveEvaluations', 14, 'Verbose', 1);

    % Train Final Model with Optimized Parameters
    bestParams = results.XAtMinObjective;
    adaboostModel = fitrensemble(X_train, y_train, 'Method', 'AdaBoostM1', ...
        'NumLearningCycles', bestParams.NumLearningCycles, ...
        'LearnRate', bestParams.LearnRate);

    fprintf('\nTest 4...\n');

    % Predict on test data
    y_pred_adaboost = predict(adaboostModel, X_test);

    % Compute Evaluation Metrics
    mse = mean((y_test - y_pred_adaboost).^2);
    adaboost_rmse = sqrt(mse);
    adaboost_mae = mean(abs(y_test - y_pred_adaboost));
    y_mean = mean(y_test);
    ss_total = sum((y_test - y_mean).^2);
    ss_residual = sum((y_test - y_pred_adaboost).^2);
    adaboost_r2 = 1 - (ss_residual / ss_total);

    % Compute Accuracy
    confMat = confusionmat(y_test, y_pred_adaboost);
    accuracy = sum(diag(confMat)) / sum(confMat(:)) * 100;

    % Print and Save Metrics
    Write2File("AdaBoost Accuracy", "AdaBoostResults.txt", [num2str(accuracy), '%']);
    Write2File("Mean Squared Error", "AdaBoostResults.txt", num2str(mse));
    Write2File("RMSE", "AdaBoostResults.txt", num2str(adaboost_rmse));
    Write2File("MAE", "AdaBoostResults.txt", num2str(adaboost_mae));
    Write2File("R² Score", "AdaBoostResults.txt", num2str(adaboost_r2));

end