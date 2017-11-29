%% Main Skript for Neuronal network
clear
close all
clc

%% Controlls

trainDataName = 'nn_Train_1.mat';
testDataName = 'nn_Test_1.mat';
valiDataName = 'nn_Vali_1.mat';

learning = true;

%Preprocess Neuronal Network
run('Preprocessing_NN.m');

% Neuronal network learning
if (learning == true)
    run('myNN_Script.m');
else
    nn_output = myFF_Function_(input_features')';
end


% Postprocess output of Neuronal Network
run('Postprocess_NN.m');