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

columns = [11 5 7]; % Set witch columns to use
%columns = 1:11
inputSize = size(columns,2);

%% Limit for acceleration data
lim = 0.3;

%% cut away filter response in data
cut = 40;


%% get new vectors for input and output
for n = 1:inputSize
    tempTrainInput(:,n) = trainData.Input(:,columns(n));
    tempTestInput(:,n) = testData.Input(:,columns(n));
    tempValiInput(:,n) = valiData.Input(:,columns(n));
end
    
tempTrainOutput = trainData.Output; 
tempTestOutput = testData.Output;
tempValiOutput = valiData.Output;

%% get only values for x-Axis and z-Axis in a certain range and filter it
% Train-Data
nSamples = 0;
LP = axFilter();
for n = 1:size(trainData.StartStop,1)
    
    start = trainData.StartStop(n,1);
    stop = trainData.StartStop(n,2);
    
    [in,out,newLength] =... 
    limitData(tempTrainInput(start:stop,:),...
              tempTrainOutput(start:stop,:),lim);
          
    nSamples = nSamples + newLength-2*cut;
          
    if n == 1
        tempFilter = filter(LP,in,1);
    	tempFeatIn = tempFilter(cut:end-cut,:);
        
        tempFilter = filter(LP,out,1);
        tempFeatOut = tempFilter(cut:end-cut,:);
        
        tempStartStop = [1,nSamples];
    else
        tempFilter = filter(LP,in,1)
        tempFeatIn = [tempFeatIn ; tempFilter(cut:end-cut,:)];
        
        tempFilter = filter(LP,out,1);
        tempFeatOut = [tempFeatOut ; tempFilter(cut:end-cut,:)];
        
        tempStartStop = [tempStartStop;...
                      [tempStartStop(size(tempStartStop,1),2)+1,nSamples]];
    end
end

trainData.InputFeautures = tempFeatIn;
trainData.OutputFeautures = tempFeatOut;
trainData.StartStopFeautres = tempStartStop;

clear tempFeatIn tempFeatOut tempStartStop in out newLength tempFilter

% Test-Data
nSamples = 0;
for n = 1:size(testData.StartStop,1)
    
    start = testData.StartStop(n,1);
    stop = testData.StartStop(n,2);
    
    [in,out,newLength] =... 
    limitData(tempTestInput(start:stop,:),...
              tempTestOutput(start:stop,:),lim);
          
    nSamples = nSamples + newLength-2*cut;
          
    if n == 1
        tempFilter = filter(LP,in,1);
    	tempFeatIn = tempFilter(cut:end-cut,:);
        
        tempFilter = filter(LP,out,1);
        tempFeatOut = tempFilter(cut:end-cut,:);
        
        tempStartStop = [1,nSamples];
    else
        tempFilter = filter(LP,in,1);
        tempFeatIn = [tempFeatIn ; tempFilter(cut:end-cut,:)];
        
        tempFilter = filter(LP,out,1);
        tempFeatOut = [tempFeatOut ; tempFilter(cut:end-cut,:)];
        
        tempStartStop = [tempStartStop;...
                      [tempStartStop(size(tempStartStop,1),2)+1,nSamples]];
    end
end

testData.InputFeautures = tempFeatIn;
testData.OutputFeautures = tempFeatOut;
testData.StartStopFeautres = tempStartStop;

clear tempFeatIn tempFeatOut tempStartStop in out newLength tempFilter

% Validation-Data
nSamples = 0;
for n = 1:size(valiData.StartStop,1)
    
    start = valiData.StartStop(n,1);
    stop = valiData.StartStop(n,2);
    
    [in,out,newLength] =... 
    limitData(tempValiInput(start:stop,:),...
              tempValiOutput(start:stop,:),lim);
          
    nSamples = nSamples + newLength-2*cut;
          
    if n == 1
        tempFilter = filter(LP,in,1);
    	tempFeatIn = tempFilter(cut:end-cut,:);
        
        tempFilter = filter(LP,out,1);
        tempFeatOut = tempFilter(cut:end-cut,:);
        
        tempStartStop = [1,nSamples];
    else
        tempFilter = filter(LP,in,1);
        tempFeatIn = [tempFeatIn ; tempFilter(cut:end-cut,:)];
        
        tempFilter = filter(LP,out,1);
        tempFeatOut = [tempFeatOut ; tempFilter(cut:end-cut,:)];
        
        tempStartStop = [tempStartStop;...
                      [tempStartStop(size(tempStartStop,1),2)+1,nSamples]];
    end
end

valiData.InputFeautures = tempFeatIn;
valiData.OutputFeautures = tempFeatOut;
valiData.StartStopFeautres = tempStartStop;

clear tempFeatIn tempFeatOut tempStartStop in out newLength tempFilter

%% Filter all data

input = [trainData.InputFeautures;
         testData.InputFeautures;
         valiData.InputFeautures];

a = size(trainData.InputFeautures,1);
b = size(testData.InputFeautures,1);
c = size(valiData.InputFeautures,1);

trainInd_ = 1:a;
testInd_ = a+1:a+b;
valiInd_ = a+b+1:a+b+c;
    
output = [trainData.OutputFeautures;
          testData.OutputFeautures;
          valiData.OutputFeautures];



clear nn_input nn_output nn_loadLabel nn_slopeLabel tempFilter

[input_features,output_features] = featureExtraction(input,output,40,true);


