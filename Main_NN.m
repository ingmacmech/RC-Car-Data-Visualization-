%% Main Skript for Neuronal network
clear
close all
clc

%% Controlls
nn_learning = false; 

trainDataName = 'nn_Test_1.mat';

%Preprocess Neuronal Network
run('Preprocessing_NN.m');

% Neuronal network learning
if(nn_learning == true)
    run('NN_Skript.m');
end

% Procces data throu neuronal network
nn_output = myNeuralNetworkFunction(input')';

% Postprocess output of Neuronal Network
run('Postprocess_NN.m');