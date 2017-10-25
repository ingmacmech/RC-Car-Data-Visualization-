%% Timedelay Net
clc;
clear;
close all;
%% Load data prepareted by Visualize_Dynamic_Data.m

load('nn_data.mat');

%% Create Net
nInput = 10; 
nDelays = 8;

nHiddenLayer = 1;
sizeHiddenLayer = 10;

delayVector = 1:nDelays;
inputDelays = delayVector;

if nInput > 1
    for n = 2 : nInput 
        inputDelays = vertcat(inputDelays, delayVector);
    end
end

hiddenLayers = sizeHiddenLayer;

if nHiddenLayer > 1
   for n = 2 : nHiddenLayer
       hiddenLayers = vertcat(hiddenLayers, sizeHiddenLayer);
   end
end
 

net = timedelaynet(inputDelays,hiddenLayers);

