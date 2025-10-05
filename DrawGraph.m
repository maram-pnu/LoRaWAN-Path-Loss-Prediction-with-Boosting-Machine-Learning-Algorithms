function DrawGraph(nodeEnergy,throughput, latency, jitter, delay, graphTitle)
%DRAWGRAPH Summary of this function goes here
%   Detailed explanation goes here   [outputArg1,outputArg2] =

% Plot the remaining energy of nodes
figure;
bar(nodeEnergy);
xlabel('Node');
ylabel('Remaining Energy (Joules)');
% finalTitle = sprintf('Remaining Energy of Nodes After 10-Minute Simulation %s', title);
title("Remaining Energy of Nodes After Simulation "+graphTitle);
grid on;
filename = sprintf('%s_Remaining_Energy_Nodes.png', graphTitle);
saveas(gcf, filename);  % Save the figure

% Plot performance metrics as bar charts
figure;
subplot(2, 2, 1);
bar(throughput);
title("Throughput per Node ("+graphTitle+")");
ylabel('Throughput');

subplot(2, 2, 2);
bar(latency);
title("Latency per Node ("+graphTitle+")");
ylabel('Latency (seconds)');

subplot(2, 2, 3);
bar(jitter);
title("Jitter per Node ("+graphTitle+")");
ylabel('Jitter (seconds)');

subplot(2, 2, 4);
bar(delay);
title("Delay per Node ("+graphTitle+")");
ylabel('Delay (seconds)');

% Save performance metrics bar charts
% saveas(gcf, graphTitle+'_PerformanceMetricsBarCharts.png');  % Save the figure
filename = sprintf('%s_PerformanceMetricsBarCharts.png', graphTitle);
saveas(gcf, filename);  % Save the figure

% Plot performance metrics as linear graphs
figure;
subplot(2, 2, 1);
plot(throughput, '-');
title("Throughput per Node ("+graphTitle+")");
xlabel('Node');
ylabel('Throughput ');
grid on;

subplot(2, 2, 2);
plot(latency, '-');
title("Latency per Node ("+graphTitle+")");
xlabel('Node');
ylabel('Latency (seconds)');
grid on;

subplot(2, 2, 3);
plot(jitter, '-');
title("Jitter per Node ("+graphTitle+")");
xlabel('Node');
ylabel('Jitter (seconds)');
grid on;

subplot(2, 2, 4);
plot(delay, '-');
title("Delay per Node ("+graphTitle+")");
xlabel('Node');
ylabel('Delay (seconds)');
grid on;

% Save performance metrics linear graphs
% saveas(gcf, graphTitle+'_PerformanceMetricsLinearGraphs.png');  % Save the figure
filename = sprintf('%s_PerformanceMetricsLinearGraphs.png', graphTitle);
saveas(gcf, filename);  % Save the figure

end

