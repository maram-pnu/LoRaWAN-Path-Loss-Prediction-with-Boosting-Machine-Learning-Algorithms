function objValue = tuneLogitBoost(params, X, y, cv)

    % Extract hyperparameters
    numCycles = params.NumLearningCycles;
    learnRate = params.LearnRate;

    % Split the data using cross-validation
    X_train = X(training(cv), :);
    X_test = X(test(cv), :);
    y_train = y(training(cv), :);
    y_test = y(test(cv), :);

    % Train LogitBoost model
    model = fitcensemble(X_train, y_train, 'Method', 'LogitBoost', ...
        'NumLearningCycles', numCycles, 'LearnRate', learnRate);

    % Predict on test data
    y_pred = predict(model, X_test);

    % Compute RMSE
    mse = mean((y_test - y_pred).^2);
    rmse = sqrt(mse);

    % Return RMSE as the objective function value (lower is better)
    objValue = rmse;
end