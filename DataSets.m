%% Set different data sets
clc;
clear;
close all

%% Test data file

dataName = {'Test31_900g_H_Steigung3_Dyn_1'};

loadMatrix = [1];

save('Poti_Test.mat','dataName','loadMatrix');
clear dataName loadMatrix

%% First data set recorded
dataName = {'Test1_0g_HV_0grad_1' , 'Test1_0g_HV_0grad_2' , 'Test1_0g_HV_0grad_3' , 'Test1_0g_HV_0grad_4';
            'Test2_900gH_0grad_1' , 'Test2_900gH_0grad_2' , 'Test2_900gH_0grad_3' , 'Test2_900gH_0grad_4';
            'Test1_0g_HV_0grad_1' , 'Test2_900gH_0grad_1' , 'Test1_0g_HV_0grad_2' , 'Test2_900gH_0grad_2';
            'Test1_0g_HV_0grad_3' , 'Test2_900gH_0grad_3' , 'Test1_0g_HV_0grad_4' , 'Test2_900gH_0grad_4'
            };
        
loadMatrix = [      0             ,          0            ,             0         ,           0;
                    900           ,          900          ,             900       ,           900; 
                    0             ,          900          ,             0         ,           900;
                    0             ,          900          ,             0         ,           900];

save('dataSet_1.mat','dataName','loadMatrix');
clear dataName loadMatrix

%% data set with slope 

dataName = {'Test17_0g_Steigung1_Dyn_1' , 'Test17_0g_Steigung1_Dyn_2' , 'Test17_0g_Steigung1_Dyn_3' ;
            'Test18_0g_Steigung2_Dyn_1' , 'Test18_0g_Steigung2_Dyn_2' , 'Test18_0g_Steigung2_Dyn_4' ;
            'Test19_900g_Steigung1_Dyn_1' , 'Test19_900g_Steigung1_Dyn_2' , 'Test19_900g_Steigung1_Dyn_3' ;
            'Test20_900g_Steigung2_Dyn_1' , 'Test20_900g_Steigung2_Dyn_2' , 'Test20_900g_Steigung2_Dyn_3' 
            };
        
loadMatrix = [      0             ,          0            ,             0 ;
                    0             ,          0            ,             0 ; 
                    900           ,          900          ,             900 ;
                    900           ,          900          ,             900 ];
                
save('dataSet_2.mat','dataName','loadMatrix');
clear dataName loadMatrix


%% Train data for NN

dataName = {'Test51_0g_TiefGarageLuzern_1';
            'Test51_0g_TiefGarageLuzern_2';
            'Test51_0g_TiefGarageLuzern_3';
            'Test51_0g_TiefGarageLuzern_4';
            'Test51_0g_TiefGarageLuzern_5';
            'Test51_0g_TiefGarageLuzern_6';
            'Test50_200g_TiefGarageLuzern_1';
            'Test50_200g_TiefGarageLuzern_2';
            'Test50_200g_TiefGarageLuzern_3';
            'Test50_200g_TiefGarageLuzern_4';
            'Test50_200g_TiefGarageLuzern_5';
            'Test50_200g_TiefGarageLuzern_6';
            'Test49_400g_TiefGarageLuzern_1';
            'Test49_400g_TiefGarageLuzern_2';
            'Test49_400g_TiefGarageLuzern_3';
            'Test49_400g_TiefGarageLuzern_4';
            'Test49_400g_TiefGarageLuzern_5';
            'Test49_400g_TiefGarageLuzern_6';
            'Test48_600g_TiefGarageLuzern_1';
            'Test48_600g_TiefGarageLuzern_2';
            'Test48_600g_TiefGarageLuzern_3';
            'Test48_600g_TiefGarageLuzern_4';
            'Test48_600g_TiefGarageLuzern_5';
            'Test48_600g_TiefGarageLuzern_6';
            'Test46_800g_TiefGarageLuzern_1';
            'Test46_800g_TiefGarageLuzern_2';
            'Test46_800g_TiefGarageLuzern_3';
            'Test46_800g_TiefGarageLuzern_4';
            'Test46_800g_TiefGarageLuzern_5';
            'Test46_800g_TiefGarageLuzern_6';
            'Test47_1000g_TiefGarageLuzern_1';
            'Test47_1000g_TiefGarageLuzern_2';
            'Test47_1000g_TiefGarageLuzern_3';
            'Test47_1000g_TiefGarageLuzern_4';
            'Test47_1000g_TiefGarageLuzern_5';
            'Test47_1000g_TiefGarageLuzern_6'
            };
        
loadMatrix = [ 0;
               0;
               0;
               0;
               0;
               0;
               200;
               200;
               200;
               200;
               200;
               200;
               400;
               400;
               400;
               400;
               400;
               400;
               600;
               600;
               600;
               600;
               600;
               600;
               800;
               800;
               800;
               800;
               800;
               800;
               1000;
               1000;
               1000;
               1000;
               1000;
               1000
               ];
   
slopeMatrix = [0;
               0;  
               0; 
               0; 
               0; 
               0;
               0;
               0;  
               0; 
               0; 
               0; 
               0;
               0;
               0;  
               0; 
               0; 
               0; 
               0;
               0;
               0;  
               0; 
               0; 
               0; 
               0;
               0;
               0;  
               0; 
               0; 
               0; 
               0;
               0;
               0;  
               0; 
               0; 
               0; 
               0;
               ];
                
save('dataSet_Train_1.mat','dataName','loadMatrix','slopeMatrix');
clear dataName loadMatrix

%% Train data for NN

dataName = {'Test51_0g_TiefGarageLuzern_1','Test50_200g_TiefGarageLuzern_1','Test49_400g_TiefGarageLuzern_1','Test48_600g_TiefGarageLuzern_1','Test46_800g_TiefGarageLuzern_1','Test47_1000g_TiefGarageLuzern_1';
            'Test51_0g_TiefGarageLuzern_2','Test50_200g_TiefGarageLuzern_2','Test49_400g_TiefGarageLuzern_2','Test48_600g_TiefGarageLuzern_2','Test46_800g_TiefGarageLuzern_2','Test47_1000g_TiefGarageLuzern_2';
            'Test51_0g_TiefGarageLuzern_3','Test50_200g_TiefGarageLuzern_3','Test49_400g_TiefGarageLuzern_3','Test48_600g_TiefGarageLuzern_3','Test46_800g_TiefGarageLuzern_3','Test47_1000g_TiefGarageLuzern_3';
            'Test51_0g_TiefGarageLuzern_4','Test50_200g_TiefGarageLuzern_4','Test49_400g_TiefGarageLuzern_4','Test48_600g_TiefGarageLuzern_4','Test46_800g_TiefGarageLuzern_4','Test47_1000g_TiefGarageLuzern_4';
            
            };
        
loadMatrix = [ 0 200 400 600 800 1000;
               0 200 400 600 800 1000;
               0 200 400 600 800 1000;
               0 200 400 600 800 1000;
               
               ];
   
slopeMatrix = [0 0 0 0 0 0;
               0 0 0 0 0 0; 
               0 0 0 0 0 0;
               0 0 0 0 0 0;
                 
               ];
                
save('dataSet_Train_2.mat','dataName','loadMatrix','slopeMatrix');
clear dataName loadMatrix



%% Test data for NN

dataName = {'Test51_0g_TiefGarageLuzern_7';
            'Test50_200g_TiefGarageLuzern_7';
            'Test49_400g_TiefGarageLuzern_7';
            'Test48_600g_TiefGarageLuzern_7';
            'Test46_800g_TiefGarageLuzern_7';
            'Test47_1000g_TiefGarageLuzern_7'
            };
       
loadMatrix = [ 0;
               200;
               400;
               600;
               800;
               1000
               ];
   
slopeMatrix = [0;
               0;
               0;
               0;
               0;
               0 
               ];
                
save('dataSet_Test_1.mat','dataName','loadMatrix','slopeMatrix');
clear dataName loadMatrix

%% Validation data for NN

dataName = {'Test51_0g_TiefGarageLuzern_8';
            'Test50_200g_TiefGarageLuzern_8';
            'Test49_400g_TiefGarageLuzern_8';
            'Test48_600g_TiefGarageLuzern_8';
            'Test46_800g_TiefGarageLuzern_8';
            'Test47_1000g_TiefGarageLuzern_8'
            };
       
loadMatrix = [ 0;
               200;
               400;
               600;
               800;
               1000
               ];
   
slopeMatrix = [0;
               0;
               0;
               0;
               0;
               0 
               ];
                
save('dataSet_Vali_1.mat','dataName','loadMatrix','slopeMatrix');
clear dataName loadMatrix


%% Laax data set with potis

dataName = {'Test26_0g_X_Steigung1_Dyn_1','Test26_0g_X_Steigung1_Dyn_2';
            'Test27_0g_X_Steigung2_Dyn_1','Test27_0g_X_Steigung2_Dyn_2';
            'Test28_0g_X_Steigung3_Dyn_1','Test28_0g_X_Steigung3_Dyn_2';
            'Test29_900g_H_Steigung1_Dyn_1','Test29_900g_H_Steigung1_Dyn_2';
            'Test30_900g_H_Steigung2_Dyn_1','Test30_900g_H_Steigung2_Dyn_2';
            'Test31_900g_H_Steigung3_Dyn_1','Test31_900g_H_Steigung3_Dyn_2';
            };
        
loadMatrix = [ 0 0;
               0 0;
               0 0;
               900 900;
               900 900;
               900 900];
           
slopeMatrix = [10.7 10.7;
               17.9 17.9;
               20.1 20.1;
               10.7 10.7;
               17.9 17.9;
               20.1 20.1
               ];
                
save('dataSet_LaaxPoti.mat','dataName','loadMatrix','slopeMatrix');
clear dataName loadMatrix slopeMatrix
