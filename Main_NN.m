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

nnLearning = true;



trainDataName = 'nn_Test_2.mat';

%Preprocess Neuronal Network
run('Preprocessing_NN.m');

% Neuronal network learning
if(nnLearning == true)
    run('myTDL_NN_Script.m');
end

X = tonndata(input,false,false);
T = tonndata(output,false,false);
[xs,xis,ais,ts] = preparets(net,X,T);

% Procces data throu neuronal network
%nn_output = myTDL_NN_Function(input',initDelay')';
nn_output = myTDL_NN_Function(xs,xis);

% Postprocess output of Neuronal Network
run('Postprocess_NN.m');