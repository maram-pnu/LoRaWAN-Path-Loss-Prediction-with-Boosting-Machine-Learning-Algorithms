function [numNodes,areaSize, initialEnergy, txEnergy, rxEnergy, simulationTime] = NetworkConfiguration()
%NETWORKCONFIGURATION Summary of this function goes here
% Network Configuration
numNodes = 500;                       % Number of nodes
areaSize = [5000, 5000];              % Area in meters (5000x5000)
initialEnergy = 10;                   % Initial energy in joules
txEnergy = 0.05;                      % Energy required to transmit data (in joules)
rxEnergy = 0.02;                      % Energy required to receive data (in joules)
simulationTime = 10 * 60;             % Simulation time in seconds (10 minutes)

end

