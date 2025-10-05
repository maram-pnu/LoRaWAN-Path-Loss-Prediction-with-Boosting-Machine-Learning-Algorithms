function FeatureImportance(X, y, model, data, modelName)
  
    numFeatures = size(X, 2);
    baseAccuracy = ModelAccuracy(model, X, y); % Compute original accuracy
    importances = zeros(numFeatures, 1);

    % Extract feature names dynamically
    featureNames = data.Properties.VariableNames({'temperature', 'rh', 'bp', 'pm2_5'});

    % Permutation Importance Calculation
    for i = 1:numFeatures
        X_permuted = X;
        X_permuted(:, i) = X(randperm(size(X, 1)), i); % Shuffle one feature

        permutedAccuracy = ModelAccuracy(model, X_permuted, y);
        importances(i) = baseAccuracy - permutedAccuracy; % Importance = Accuracy Drop
    end

    % Display Feature Importance
    fprintf('\nPermutation Importance for %s Model:\n', modelName);
    for i = 1:numFeatures
        fprintf('Parameter: %s, ImpactScore: %.4f\n', featureNames{i}, importances(i));
    end

    % Plot Feature Importance
    figure;
    bar(importances);
    xticklabels(featureNames);
    xlabel('Parameter');
    ylabel('Impact Score');
    title(['Feature Importance using Permutation - ', modelName]);
    grid on;
    saveas(gcf, ['FeatureImportance_' modelName '.png']); % Save figure

    % Save results to a file
    fileID = fopen(['FeatureImportance_' modelName '.txt'], 'w');
    for i = 1:numFeatures
        fprintf(fileID, 'Feature: %s, Importance: %.4f\n', featureNames{i}, importances(i));
    end
    fclose(fileID);
end

function accuracy = ModelAccuracy(model, X, y)
    % MODELACCURACY - Computes model accuracy on given data
    predictions = predict(model, X);

    % Convert `y` and `predictions` to the same type
    if iscategorical(y)
        predictions = categorical(round(predictions));  % Convert predictions to categorical
    elseif isa(y, 'double') || isa(y, 'single')
        y = double(y);  % Ensure y is double
        predictions = double(round(predictions));  % Round predictions for regression models
    end

    % Ensure values are in the same format for confusion matrix
    y = round(y);  %Round y for fair comparison (if regression model)
    predictions = round(predictions);  % Round predictions

    % Compute confusion matrix
    confMat = confusionmat(y, predictions);

    % Compute accuracy
    accuracy = sum(diag(confMat)) / sum(confMat(:)) * 100;
end