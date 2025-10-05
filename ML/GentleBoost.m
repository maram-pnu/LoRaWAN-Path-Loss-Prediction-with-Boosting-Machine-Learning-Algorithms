function [gentleBoostModel, y_pred_gentle, gentleboost_rmse, gentleboost_mae, gentleboost_r2, accuracy] = GentleBoost(cv, X, y, ~, ~)

    % Ensure labels are numeric
    y = double(y);

    % Split data into training and testing sets
    X_train = X(training(cv), :);
    X_test = X(test(cv), :);
    y_train = y(training(cv), :);
    y_test = y(test(cv), :); 

    % Define Bayesian Optimization Variables
    optimVars = [
        optimizableVariable('LearnRate', [0.01, 1], 'Type', 'real', 'Transform', 'log');
        optimizableVariable('NumLearningCycles', [10, 200], 'Type', 'integer')];

    % Define Objective Function for Optimization
    objFcn = @(params) tuneGentleBoost(params, X_train, y_train, X_test, y_test);

    % Run Bayesian Optimization
    results = bayesopt(objFcn, optimVars, 'MaxObjectiveEvaluations', 14, 'Verbose', 1);

    % Train Final Model with Optimized Parameters
    bestParams = results.XAtMinObjective;
    gentleBoostModel = fitcensemble(X_train, y_train, 'Method', 'GentleBoost', ...
        'NumLearningCycles', bestParams.NumLearningCycles, ...
        'LearnRate', bestParams.LearnRate);

    % Predict on test data
    y_pred_gentle = predict(gentleBoostModel, X_test);

    % Ensure matching dimensions
    y_test = y_test(:);
    y_pred_gentle = y_pred_gentle(:);

    % Compute Evaluation Metrics
    mse = mean((y_test - y_pred_gentle).^2);
    gentleboost_rmse = sqrt(mse);
    gentleboost_mae = mean(abs(y_test - y_pred_gentle));
    y_mean = mean(y_test);
    ss_total = sum((y_test - y_mean).^2);
    ss_residual = sum((y_test - y_pred_gentle).^2);
    gentleboost_r2 = 1 - (ss_residual / ss_total);

    % Compute Accuracy
    confMat = confusionmat(y_test, y_pred_gentle);
    accuracy = sum(diag(confMat)) / sum(confMat(:)) * 100;

    % Print and Save Metrics
    Write2File("GentleBoost Accuracy", "GentleBoostResults.txt", [num2str(accuracy), '%']);
    Write2File("Mean Squared Error", "GentleBoostResults.txt", num2str(mse));
    Write2File("RMSE", "GentleBoostResults.txt", num2str(gentleboost_rmse));
    Write2File("MAE", "GentleBoostResults.txt", num2str(gentleboost_mae));
    Write2File("R² Score", "GentleBoostResults.txt", num2str(gentleboost_r2));

end