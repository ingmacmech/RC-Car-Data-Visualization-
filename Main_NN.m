%% Main Skript for Neuronal network
clear
close all
clc

%% Controlls

trainDataName = 'nn_Train_2.mat';
testDataName = 'nn_Test_2.mat';
valiDataName = 'nn_Vali_2.mat';

crossDataName = 'nn_CrossTest_2.mat';

learning = true;
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

%% Allways compute the cross output with a neuronal net
if TDL == true
        X = tonndata(crossData.InputFeautures,false,false);
        T = tonndata(crossData.OutputFeautures,false,false);
        [x,xi,ai,t] = preparets(net,X,T);
        nn_cross_output = myTDL_Function_(x,xi)';
    else 
        nn_cross_output = myFF_Function_(crossData.InputFeautures')';
end  



% Postprocess output of Neuronal Network
run('Postprocess_NN.m');