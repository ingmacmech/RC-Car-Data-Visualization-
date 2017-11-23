%% Preprocessing for Neuronal Network

%% Load Data

trainData = load(trainDataName);
testData = load(testDataName);
valiData = load(valiDataName);

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

columns = [11 5 6 7]; % Set witch columns to use
%columns = 1:11
inputSize = size(columns,2);


%% Set together a new input matrix


    for n = 1:inputSize
        tempTrainInput(:,n) = trainData.nn_input(:,n);
        tempTestInput(:,n) = testData.nn_input(:,n);
        tempValiInput(:,n) = valiData.nn_input(:,n);
    end
input = [tempTrainInput;
         tempTestInput;
         tempValiInput];

a = size(tempTrainInput,1);
b = size(tempTestInput,1);
c = size(tempValiInput,1);

trainInd_ = 1:a;
testInd_ = a+1:a+b;
valiInd_ = a+b+1:a+b+c;
    
output = [trainData.nn_output;
          testData.nn_output;
          valiData.nn_output];


clear nn_input nn_output nn_loadLabel nn_slopeLabel

