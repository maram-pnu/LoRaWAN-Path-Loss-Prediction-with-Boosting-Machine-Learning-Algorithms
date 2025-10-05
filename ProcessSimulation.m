function [nodeEnergy, throughput, latency, jitter, delay, aliveNodes] = ProcessSimulation(data, numNodes, model, txEnergy, rxEnergy, simulationTime, nodeEnergy, graphTitle)
    % Initialize performance metrics
    throughput = zeros(numNodes, 1);
    latency = zeros(numNodes, 1);
    jitter = zeros(numNodes, 1);
    delay = zeros(numNodes, 1);

    % Transmission intervals for each node
    transmissionInterval = randi([1, 10], numNodes, 1); % Random interval between 1 to 10 seconds

    % Simulate communication for each node
    for i = 1:numNodes
        proc = 0.002; % Processing delay in seconds
        queue = 0.005; % Queuing delay in seconds
        
        % Sampled node parameters
        packet_size = data.frame_length(i);
        throughput(i) = rand() * 100 + 100; % Use a base throughput for simulation
        propagation_speed = 3e8; 
        distance_i = data.distance(i);

        % Compute delay
        delay(i) = (packet_size / throughput(i)) + rand() * 0.02;

        % Compute latency
        latency(i) = delay(i) + (distance_i / propagation_speed) + proc + queue + rand() * 0.03;

        % Compute jitter
        if i > 1
            jitter(i) = abs(delay(i) - delay(i-1)) + rand() * 0.01;
        else
            jitter(i) = rand() * 0.01;
        end

        % Simulate node energy consumption
        for t = 1:simulationTime
            if mod(t, transmissionInterval(i)) == 0
                % Energy consumption based on distance
                distanceFactor = distance_i / max(data.distance);
                totalEnergyCost = (txEnergy * distanceFactor) + rxEnergy;
                nodeEnergy(i) = nodeEnergy(i) - totalEnergyCost;

                if nodeEnergy(i) <= 0
                    nodeEnergy(i) = 0; % Node dies
                    break;
                end
            end
        end
    end

    % Save metrics for specific model
    metrics_table = table(throughput, latency, jitter, delay, 'VariableNames', ...
                          {'Throughput', 'Latency', 'Jitter', 'Delay'});
    writetable(metrics_table, graphTitle + "_PerformanceMetrics.csv");

    % Calculate the number of alive nodes
    aliveNodes = sum(nodeEnergy > 0);
    disp(['Number of alive nodes after simulation (' graphTitle '): ' num2str(aliveNodes)]);

    % Save alive nodes and remaining energy to files
    Write2File("Alive Nodes", graphTitle + "_AliveNodes.txt", aliveNodes);
    Write2File("Remaining Energy", graphTitle + "_RemainingEnergy.txt", nodeEnergy);
end
