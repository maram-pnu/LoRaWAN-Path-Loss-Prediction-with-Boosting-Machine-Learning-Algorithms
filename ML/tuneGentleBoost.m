function objValue = tuneGentleBoost(params, X_train, y_train, X_test, y_test)

    % Extract hyperparameters
    numCycles = params.NumLearningCycles;
    learnRate = params.LearnRate;

    % Ensure labels are numeric
    y_train = double(y_train);
    y_test = double(y_test);

    % Train GentleBoost model
    model = fitcensemble(X_train, y_train, 'Method', 'GentleBoost', ...
        'NumLearningCycles', numCycles, 'LearnRate', learnRate);

    % Predict on test data
    y_pred = predict(model, X_test);

    % Ensure matching dimensions
    y_test = y_test(:);
    y_pred = y_pred(:);

    % Compute RMSE
    mse = mean((y_test - y_pred).^2);
    rmse = sqrt(mse);

    % Return RMSE as the objective function value (lower is better)
    objValue = rmse;
end