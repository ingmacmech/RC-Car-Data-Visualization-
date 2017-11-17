%% Main Skript for Neuronal network
% clear
% close all
% clc

%% Controlls
% witch Type of a NN to use
% 'NARX'
% 'TDL'
% 'FF'
nnType = 'FF';
nDelays = 10;

nnLearning = false;



trainDataName = 'nn_Test_1.mat';

%Preprocess Neuronal Network
run('Preprocessing_NN.m');

% Neuronal network learning
if(nnLearning == true)
    run('NN_Skript.m');
end

% Procces data throu neuronal network
%nn_output = myTDL_NN_Function(input',initDelay')';
nn_output = myNeuralNetworkFunction(input');

% Postprocess output of Neuronal Network
run('Postprocess_NN.m');