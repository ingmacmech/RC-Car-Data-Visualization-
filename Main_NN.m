%% Main Skript for Neuronal network
clear
close all
clc

%% Controlls

trainDataName = 'nn_Train_1.mat';
testDataName = 'nn_Test_1.mat';
valiDataName = 'nn_Vali_1.mat';

learning = false;
TDL = false;
plotInputFeautures = false;

%Preprocess Neuronal Network
run('Preprocessing_NN.m');

% Neuronal network learning
if (learning == true)
    if TDL == true
        run('myTDL_NN_Script.m');
    else 
        run('myNN_Script.m');
    end  
else
    if TDL == true
        X = tonndata(input_features,false,false);
        T = tonndata(output_features,false,false);
        [x,xi,ai,t] = preparets(net,X,T);
        nn_output = myTDL_Function_(x,xi)';
    else 
        nn_output = myFF_Function_(input_features')';
    end  
    
end


% Postprocess output of Neuronal Network
run('Postprocess_NN.m');