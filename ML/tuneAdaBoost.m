function objValue = tuneAdaBoost(params, X, y, cv)

    % Extract hyperparameters from Bayesian Optimization
    numCycles = params.NumLearningCycles;
    learnRate = params.LearnRate;

    % Perform cross-validation
    mseValues = zeros(cv.NumTestSets, 1);
    
    for i = 1:cv.NumTestSets
        % Split the data into training and testing sets using cross-validation
        trainIdx = training(cv, i);
        testIdx = test(cv, i);

        X_train = X(trainIdx, :);
        X_test = X(testIdx, :);
        y_train = y(trainIdx);
        y_test = y(testIdx);

        % Train AdaBoost model with the given hyperparameters
        model = fitcensemble(X_train, y_train, 'Method', 'AdaBoostM1', ...
            'NumLearningCycles', numCycles, 'LearnRate', learnRate);

        % Predict on test data
        y_pred = predict(model, X_test);

        % Compute RMSE
        mseValues(i) = mean((y_test - y_pred).^2);
    end

    % Compute average RMSE across folds
    objValue = sqrt(mean(mseValues));

end