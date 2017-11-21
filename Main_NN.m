%% Main Skript for Neuronal network
clear
close all
clc

%% Controlls

trainDataName = 'nn_Test_1.mat';

%Preprocess Neuronal Network
run('Preprocessing_NN.m');

% Neuronal network learning

run('myTDL_NN_Script.m');



% Postprocess output of Neuronal Network
run('Postprocess_NN.m');