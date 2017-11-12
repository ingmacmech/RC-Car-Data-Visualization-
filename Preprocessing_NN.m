%% Preprocessing for Neuronal Network

%% Load Data

load('nn_data.mat');

%% Choose witch sensordata to use as input
% Column 1: Throttle
% Column 2: Steering
% Column 3: Wheel speed front left
% Column 4: Wheel speed front right
% Column 5: Acceleration x-Axis
% Column 6: Acceleration y-Axis
% Column 7: Acceleration z-Axis
% Column 8: Gyroscope x-Axis
% Column 9: Gyroscope y-Axis
% Column 10: Gyroscope z-Axis
% Column 11: Vehicle acceleration

columns = [11 5 6 7 8 9 10]; % Set witch columns to use
%columns = 1:11
inputSize = size(columns,2);


%% Set together a new input matrix
input = zeros(size(nn_input,1),inputSize);
for n = 1:inputSize
    input(:,n) = nn_input(:,n);
end

%% Set output matrix
output = nn_output;
%% Set load label
loadLabel = nn_loadLabel;
%% Set slope label
slopeLabel = nn_slopeLabel;


clear nn_input nn_output nn_loadLabel nn_slopeLabel

