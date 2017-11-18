%% Preprocessing for Neuronal Network

%% Load Data

load(trainDataName);

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

columns = [11 5 7]; % Set witch columns to use
%columns = 1:11
inputSize = size(columns,2);


%% Set together a new input matrix


%% Set output matrix
output = nn_output;
if (nnLearning == false)
    switch(nnType)
        case 'NARX'
            input = zeros(size(nn_input,1)-nDelays,inputSize);
            initDelay = nn_input(1:nDelays,:);
            for n = 1:inputSize
                input(:,n) = nn_input(nDelays+1:end,n);
            end

        case 'TDL'
            input = zeros(size(nn_input,1)-nDelays,inputSize);
            initDelay = nn_input(1:nDelays,inputSize);
            for n = 1:inputSize
                input(:,n) = nn_input(nDelays+1:end,n);
                initDelay(:,n) = nn_input(1:nDelays,n);
            end
            

        case 'FF'
            input = zeros(size(nn_input,1),inputSize);
            for n = 1:inputSize
                input(:,n) = nn_input(:,n);
            end    
    end
else
    input = zeros(size(nn_input,1),inputSize);
    for n = 1:inputSize
        input(:,n) = nn_input(:,n);
    end
end
%% Set load label
loadLabel = nn_loadLabel;
%% Set slope label
slopeLabel = nn_slopeLabel;


clear nn_input nn_output nn_loadLabel nn_slopeLabel

