function [logitboostModel, y_pred_logitboost, logitboost_rmse, logitboost_mae, logitboost_r2, accuracy] = LogitBoost(cv, X, y, ~, ~)

    % Define Bayesian Optimization Variables
    optimVars = [
        optimizableVariable('LearnRate', [0.01, 1], 'Type', 'real', 'Transform', 'log');
        optimizableVariable('NumLearningCycles', [10, 200], 'Type', 'integer')];

    % Define Objective Function for Optimization
    objFcn = @(params) tuneLogitBoost(params, X, y, cv);

    % Run Bayesian Optimization
    results = bayesopt(objFcn, optimVars, 'MaxObjectiveEvaluations', 14, 'Verbose', 1);

    % Train Final Model with Optimized Parameters
    bestParams = results.XAtMinObjective;
    numCycles = bestParams.NumLearningCycles;
    learnRate = bestParams.LearnRate;

    % Split the data into training and testing sets
    numSamples = size(X, 1);
    randIndices = randperm(numSamples);
    X = X(randIndices, :);
    y = y(randIndices);

    X_train = X(training(cv), :);
    X_test = X(test(cv), :);
    y_train = y(training(cv), :);
    y_test = y(test(cv), :);

    % Train LogitBoost model with optimized parameters
    logitboostModel = fitcensemble(X_train, y_train, 'Method', 'LogitBoost', 'NumLearningCycles', numCycles, 'LearnRate', learnRate);

    % Predict on test data
    y_pred_logitboost = predict(logitboostModel, X_test);

    % Compute Evaluation Metrics
    mse = mean((y_test - y_pred_logitboost).^2);
    logitboost_rmse = sqrt(mse);
    logitboost_mae = mean(abs(y_test - y_pred_logitboost));
    y_mean = mean(y_test);
    ss_total = sum((y_test - y_mean).^2);
    ss_residual = sum((y_test - y_pred_logitboost).^2);
    logitboost_r2 = 1 - (ss_residual / ss_total);

    % Compute Accuracy
    confMat = confusionmat(y_test, y_pred_logitboost);
    accuracy = sum(diag(confMat)) / sum(confMat(:)) * 100;

    % Print and Save Metrics
    Write2File("LogitBoost Accuracy", "LogitBoostResults.txt", [num2str(accuracy), '%']);
    Write2File("Mean Squared Error", "LogitBoostResults.txt", num2str(mse));
    Write2File("RMSE", "LogitBoostResults.txt", num2str(logitboost_rmse));
    Write2File("MAE", "LogitBoostResults.txt", num2str(logitboost_mae));
    Write2File("R² Score", "LogitBoostResults.txt", num2str(logitboost_r2));
end