function DrawCompare(X,X2, X3,X4,X5, tittle, numNodes)
%DRAWCOMPARE Summary of this function goes here  Delay
%   Detailed explanation goes here
figure('Position', [100, 100, 1400, 400]); % Adjust width (1200) and height (400) as needed
iterations = 1:numNodes;
plot(iterations, X, '-', 'LineWidth', 1.5); hold on;
plot(iterations, X2, '-', 'LineWidth', 1.5);
plot(iterations, X3, '-', 'LineWidth', 1.5);
plot(iterations, X4, '-', 'LineWidth', 1.5);
plot(iterations, X5, '-', 'LineWidth', 1.5);
grid on;

% Add labels and title
xlabel('Nodes');
ylabel(tittle);
title(tittle+" Comparison");
legend("AdaBoost", "XGBoost", "LGBM", "GentleBoost", "LogitBoost", 'Location', 'best');
% Save performance metrics linear graphs
saveas(gcf, "Compare_"+tittle+"_Performance.png");  % Save the figure
end

