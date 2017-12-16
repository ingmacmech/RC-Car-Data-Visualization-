%% Preprocessing for Neuronal Network

%% Limit for acceleration data
lim = 0.2;

%% cut away filter response in data
cut = 10;

%% feautre extraktion window
window = 100;

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

%% Load Data

testData = load(testDataName);
valiData = load(valiDataName);
trainData = load(trainDataName);
crossData = load(crossDataName);

%% get new vectors for input and output
for n = 1:inputSize
    tempTrainInput(:,n) = trainData.Input(:,columns(n));
    tempTestInput(:,n) = testData.Input(:,columns(n));
    tempValiInput(:,n) = valiData.Input(:,columns(n));
    tempCrossInput(:,n) = crossData.Input(:,columns(n));
end
    
tempTrainOutput = trainData.Output; 
tempTestOutput = testData.Output;
tempValiOutput = valiData.Output;
tempCrossOutput = crossData.Output;

%% get only values for x-Axis and z-Axis in a certain range and filter it
% Train-Data
nSamples = 0;
LP = axFilter();
for n = 1:size(trainData.StartStop,1)
    
    start = trainData.StartStop(n,1);
    stop = trainData.StartStop(n,2);
    
    [in,out,~] =... 
    limitData(tempTrainInput(start:stop,:),...
              tempTrainOutput(start:stop,:),lim);
    
    if n == 1
        tempFilter = filter(LP,in,1);
    	tempFeatIn = tempFilter(cut:end-cut-1,:);
        
        tempFilter = filter(LP,out,1);
        tempFeatOut = tempFilter(cut:end-cut-1,:);
        
        [tempFeatIn,tempFeatOut] =...
        featureExtraction(tempFeatIn,tempFeatOut,window,false);
        
        nSamples = nSamples + size(tempFeatIn,1);
        tempStartStop = [1,nSamples];
    else
        tempFilterIn = filter(LP,in,1);
        tempFilterIn = tempFilterIn(cut:end-cut-1,:);
        
        tempFilterOut = filter(LP,out,1);
        tempFilterOut = tempFilterOut(cut:end-cut-1,:);
        
        [tempFilterIn,tempFilterOut] = ...
        featureExtraction(tempFilterIn,tempFilterOut,window,false);    
        
        tempFeatIn = [tempFeatIn ; tempFilterIn];
        tempFeatOut = [tempFeatOut ; tempFilterOut];
        
        nSamples = nSamples + size(tempFilterIn,1);
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
          
    if n == 1
        tempFilter = filter(LP,in,1);
    	tempFeatIn = tempFilter(cut:end-cut-1,:);
        
        tempFilter = filter(LP,out,1);
        tempFeatOut = tempFilter(cut:end-cut-1,:);
        
        [tempFeatIn,tempFeatOut] =...
        featureExtraction(tempFeatIn,tempFeatOut,window,false);
        
        nSamples = nSamples + size(tempFeatIn,1);
        tempStartStop = [1,nSamples];
    else
        tempFilterIn = filter(LP,in,1);
        tempFilterIn = tempFilterIn(cut:end-cut-1,:);
        
        tempFilterOut = filter(LP,out,1);
        tempFilterOut = tempFilterOut(cut:end-cut-1,:);
        
        [tempFilterIn,tempFilterOut] = ...
        featureExtraction(tempFilterIn,tempFilterOut,window,false);    
        
        tempFeatIn = [tempFeatIn ; tempFilterIn];
        tempFeatOut = [tempFeatOut ; tempFilterOut];
        
        nSamples = nSamples + size(tempFilterIn,1);
        tempStartStop = [tempStartStop;...
                      [tempStartStop(size(tempStartStop,1),2)+1,nSamples]];
    end
    
    if(plotInputFeautures == true)
        figure('units','normalized','outerposition',[0 0 1 1])
        
        subplot(4,1,1)
        hold on
        plot(tempFeatIn(:,1))
        hold off
        
        subplot(4,1,2)
        hold on
        plot(tempFeatIn(:,2))
        hold off
        
        subplot(4,1,3)
        hold on
        plot(tempFeatIn(:,3))
        hold off
        
        subplot(4,1,4)
        hold on
        plot(tempFeatIn(:,4))
        hold off
        
        figure('units','normalized','outerposition',[0 0 1 1])
        
        subplot(4,1,1)
        hold on
        plot(tempFeatIn(:,5))
        hold off
        
        subplot(4,1,2)
        hold on
        plot(tempFeatIn(:,6))
        hold off
        
        subplot(4,1,3)
        hold on
        plot(tempFeatIn(:,7))
        hold off
        
        subplot(4,1,4)
        hold on
        plot(tempFeatIn(:,8))
        hold off
        
        figure('units','normalized','outerposition',[0 0 1 1])
        
        subplot(4,1,1)
        hold on
        plot(tempFeatIn(:,9))
        hold off
        
        subplot(4,1,2)
        hold on
        plot(tempFeatIn(:,10))
        hold off
        
        subplot(4,1,3)
        hold on
        plot(tempFeatIn(:,11))
        hold off
        
        subplot(4,1,4)
        hold on
        plot(tempFeatIn(:,12))
        hold off
        
        
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
          
    if n == 1
        tempFilter = filter(LP,in,1);
    	tempFeatIn = tempFilter(cut:end-cut-1,:);
        
        tempFilter = filter(LP,out,1);
        tempFeatOut = tempFilter(cut:end-cut-1,:);
        
        [tempFeatIn,tempFeatOut] =...
        featureExtraction(tempFeatIn,tempFeatOut,window,false);
        
        nSamples = nSamples + size(tempFeatIn,1);
        tempStartStop = [1,nSamples];
    else
        tempFilterIn = filter(LP,in,1);
        tempFilterIn = tempFilterIn(cut:end-cut-1,:);
        
        tempFilterOut = filter(LP,out,1);
        tempFilterOut = tempFilterOut(cut:end-cut-1,:);
        
        [tempFilterIn,tempFilterOut] = ...
        featureExtraction(tempFilterIn,tempFilterOut,window,false);    
        
        tempFeatIn = [tempFeatIn ; tempFilterIn];
        tempFeatOut = [tempFeatOut ; tempFilterOut];
        
        nSamples = nSamples + size(tempFilterIn,1);
        tempStartStop = [tempStartStop;...
                      [tempStartStop(size(tempStartStop,1),2)+1,nSamples]];
    end
end

valiData.InputFeautures = tempFeatIn;
valiData.OutputFeautures = tempFeatOut;
valiData.StartStopFeautres = tempStartStop;

clear tempFeatIn tempFeatOut tempStartStop in out newLength tempFilter

% Cross-Data
nSamples = 0;
LP = axFilter();
for n = 1:size(crossData.StartStop,1)
    
    start = crossData.StartStop(n,1);
    stop = crossData.StartStop(n,2);
    
    [in,out,~] =... 
    limitData(tempCrossInput(start:stop,:),...
              tempCrossOutput(start:stop,:),lim);
    
    if n == 1
        tempFilter = filter(LP,in,1);
    	tempFeatIn = tempFilter(cut:end-cut-1,:);
        
        tempFilter = filter(LP,out,1);
        tempFeatOut = tempFilter(cut:end-cut-1,:);
        
        [tempFeatIn,tempFeatOut] =...
        featureExtraction(tempFeatIn,tempFeatOut,window,false);
        
        nSamples = nSamples + size(tempFeatIn,1);
        tempStartStop = [1,nSamples];
    else
        tempFilterIn = filter(LP,in,1);
        tempFilterIn = tempFilterIn(cut:end-cut-1,:);
        
        tempFilterOut = filter(LP,out,1);
        tempFilterOut = tempFilterOut(cut:end-cut-1,:);
        
        [tempFilterIn,tempFilterOut] = ...
        featureExtraction(tempFilterIn,tempFilterOut,window,false);    
        
        tempFeatIn = [tempFeatIn ; tempFilterIn];
        tempFeatOut = [tempFeatOut ; tempFilterOut];
        
        nSamples = nSamples + size(tempFilterIn,1);
        tempStartStop = [tempStartStop;...
                      [tempStartStop(size(tempStartStop,1),2)+1,nSamples]];
    end
end

crossData.InputFeautures = tempFeatIn;
crossData.OutputFeautures = tempFeatOut;
crossData.StartStopFeautres = tempStartStop;

clear tempFeatIn tempFeatOut tempStartStop in out newLength tempFilter
%% Put togeter all data for training

input_features = [trainData.InputFeautures;
                  testData.InputFeautures;
                  valiData.InputFeautures];

a = size(trainData.InputFeautures,1);
b = size(testData.InputFeautures,1);
c = size(valiData.InputFeautures,1);

trainInd_ = 1:a;
testInd_ = a+1:a+b;
valiInd_ = a+b+1:a+b+c;

trainData.Offset = 0;
testData.Offset = a;
valiData.Offset = a+b;

output_features = [trainData.OutputFeautures;
                   testData.OutputFeautures;
                   valiData.OutputFeautures];



clear nn_input nn_output nn_loadLabel nn_slopeLabel tempFilter



