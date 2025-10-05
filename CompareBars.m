function CompareBars(values, labels, graphTitle)
%COMPAREBARS Summary of this function goes here
%   Detailed explanation goes here
% Data values
% values = [89, 90, 54, 78, 67];
% 
% % Labels for each bar
% labels = {'A', 'B', 'C', 'D', 'E'};

% Create a bar chart
figure;
bar(values);

% Add labels to the x-axis
set(gca, 'XTickLabel', labels);

% Add titles and labels
xlabel('Categories');
ylabel('Values');
title(graphTitle+" Comparism");

% Display grid for better readability
filename = sprintf('%s_Remaining_Energy_Nodes.png', graphTitle);
saveas(gcf, filename);  % Save the figure
end

