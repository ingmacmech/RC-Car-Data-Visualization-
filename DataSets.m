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
            'Test47_1000g_TiefGarageLuzern_6';%
            'Test47_1000g_TiefGarageLuzern_11';
            'Test49_400g_TiefGarageLuzern_11';
            'Test49_400g_TiefGarageLuzern_12';
            'Test49_400g_TiefGarageLuzern_13';
            'Test50_200g_TiefGarageLuzern_11';
            'Test50_200g_TiefGarageLuzern_12';
            'Test51_0g_TiefGarageLuzern_11';
            'Test51_0g_TiefGarageLuzern_12';
            'Test51_0g_TiefGarageLuzern_13'
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
               1000;
               1000;
               400;
               400;
               400;
               200;
               200;
               0;
               0;
               0;
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
            'Test47_1000g_TiefGarageLuzern_7';
            'Test47_1000g_TiefGarageLuzern_10';
            'Test48_600g_TiefGarageLuzern_10';
            'Test49_400g_TiefGarageLuzern_10';
            'Test50_200g_TiefGarageLuzern_10';
            'Test51_0g_TiefGarageLuzern_10'
            };
       
loadMatrix = [ 0;
               200;
               400;
               600;
               800;
               1000;
               1000;
               600;
               400;
               200;
               0
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
            'Test47_1000g_TiefGarageLuzern_8';
            'Test47_1000g_TiefGarageLuzern_9';
            'Test48_600g_TiefGarageLuzern_9';
            'Test49_400g_TiefGarageLuzern_9';
            'Test50_200g_TiefGarageLuzern_9';
            'Test51_0g_TiefGarageLuzern_9'
            };
       
loadMatrix = [ 0;
               200;
               400;
               600;
               800;
               1000;
               1000;
               600;
               400;
               200;
               0
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


%% Laax data set with potis

dataName = {'Test51_0g_TiefGarageLuzern_1';
            'Test50_200g_TiefGarageLuzern_1'
            };
        
loadMatrix = [ 0;200];
           
slopeMatrix = [0;2];
                
save('dataSet_Test.mat','dataName','loadMatrix','slopeMatrix');
clear dataName loadMatrix slopeMatrix

%% Test data for NN

dataName = {'Test26_0g_X_Steigung1_Dyn_1';
            'Test27_0g_X_Steigung2_Dyn_1';
            'Test28_0g_X_Steigung3_Dyn_1';
            'Test29_900g_H_Steigung1_Dyn_1';
            'Test30_900g_H_Steigung2_Dyn_1';
            'Test31_900g_H_Steigung3_Dyn_1'
            };
       
loadMatrix = [ 0;
               0;
               0;
               900;
               900;
               900
               ];
   
slopeMatrix = [1;
               2;
               3;
               1;
               2;
               3 
               ];
                
save('dataSet_Test_Laax.mat','dataName','loadMatrix','slopeMatrix');
clear dataName loadMatrix

%% Cross Test data Burgdorf for NN

dataName = {'Test52_0g_Burgdorf_1';
            'Test52_0g_Burgdorf_2';
            'Test52_0g_Burgdorf_3';
            'Test53_200g_Burgdorf_1';
            'Test53_200g_Burgdorf_2';
            'Test53_200g_Burgdorf_3';
            'Test54_400g_Burgdorf_1';
            'Test54_400g_Burgdorf_2';
            'Test54_400g_Burgdorf_3';
            'Test55_600g_Burgdorf_1';
            'Test55_600g_Burgdorf_2';
            'Test55_600g_Burgdorf_3';
            'Test56_800g_Burgdorf_1';
            'Test56_800g_Burgdorf_2';
            'Test56_800g_Burgdorf_3';
            
            };
       
loadMatrix = [ 0;
               0;
               0;
               200;
               200;
               200;
               400;
               400;
               400;
               600;
               600;
               600;
               800;
               800;
               800;
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
               0
               ];
                
save('dataSet_CrossTest_1.mat','dataName','loadMatrix','slopeMatrix');
clear dataName loadMatrix

%% Train data 2 for NN

dataName = {'Test52_0g_Burgdorf_1';
            'Test52_0g_Burgdorf_2';
            'Test52_0g_Burgdorf_3';
            'Test52_0g_Burgdorf_4';
            'Test58_0g_Steigung2_1';
            'Test58_0g_Steigung2_2';
            'Test58_0g_Steigung2_3';
            'Test58_0g_Steigung2_4';
            'Test53_200g_Burgdorf_1';
            'Test53_200g_Burgdorf_2';
            'Test53_200g_Burgdorf_3';
            'Test53_200g_Burgdorf_4';
            'Test59_200g_Steigung2_1';
            'Test59_200g_Steigung2_2';
            'Test59_200g_Steigung2_3';
            'Test59_200g_Steigung2_4';
            'Test54_400g_Burgdorf_1';
            'Test54_400g_Burgdorf_2';
            'Test54_400g_Burgdorf_3';
            'Test54_400g_Burgdorf_4';
            'Test60_400g_Steigung2_1';
            'Test60_400g_Steigung2_2';
            'Test60_400g_Steigung2_3';
            'Test60_400g_Steigung2_4';
            'Test55_600g_Burgdorf_1';
            'Test55_600g_Burgdorf_2';
            'Test55_600g_Burgdorf_3';
            'Test55_600g_Burgdorf_4';
            'Test61_600g_Steigung2_1';
            'Test61_600g_Steigung2_2';
            'Test61_600g_Steigung2_3';
            'Test61_600g_Steigung2_4';
            'Test56_800g_Burgdorf_1';
            'Test56_800g_Burgdorf_2';
            'Test56_800g_Burgdorf_3';
            'Test56_800g_Burgdorf_4';
            'Test62_800g_Steigung2_1';
            'Test62_800g_Steigung2_2';
            'Test62_800g_Steigung2_3';
            'Test62_800g_Steigung2_4';
            'Test57_1000g_Burgdorf_1';
            'Test57_1000g_Burgdorf_2';
            'Test57_1000g_Burgdorf_3';
            'Test57_1000g_Burgdorf_4';
            'Test63_1000g_Steigung2_1';
            'Test63_1000g_Steigung2_2';
            'Test63_1000g_Steigung2_3';
            'Test63_1000g_Steigung2_4';
            };
        
loadMatrix = [ 0;
               0;
               0;
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
               200;
               200;
               400;
               400;
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
               600;
               600;
               800;
               800;
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
               1000;
               1000;
               1000;
               ];
   
slopeMatrix = [0;
               0;
               0;
               0;
               2;
               2;
               2;
               2;
               0;
               0;
               0;
               0;
               2;
               2;
               2;
               2;
               0;
               0;
               0;
               0;
               2;
               2;
               2;
               2;
               0;
               0;
               0;
               0;
               2;
               2;
               2;
               2;
               0;
               0;
               0;
               0;
               2;
               2;
               2;
               2;
               0;
               0;
               0;
               0;
               2;
               2;
               2;
               2;
               0;
               0;
               0;
               0;
               2;
               2;
               2;
               2;
               ];
                
save('dataSet_Train_2.mat','dataName','loadMatrix','slopeMatrix');
clear dataName loadMatrix

%% Test data 2 for NN

dataName = {'Test52_0g_Burgdorf_5';
            'Test52_0g_Burgdorf_6';
            'Test58_0g_Steigung2_5';
            'Test58_0g_Steigung2_6';
            'Test53_200g_Burgdorf_5';
            'Test53_200g_Burgdorf_6';
            'Test59_200g_Steigung2_5';
            'Test59_200g_Steigung2_6';
            'Test54_400g_Burgdorf_5';
            'Test54_400g_Burgdorf_6';
            'Test60_400g_Steigung2_11';
            'Test60_400g_Steigung2_6';
            'Test55_600g_Burgdorf_5';
            'Test55_600g_Burgdorf_6';
            'Test61_600g_Steigung2_5';
            'Test61_600g_Steigung2_6';
            'Test56_800g_Burgdorf_5';
            'Test56_800g_Burgdorf_6';
            'Test62_800g_Steigung2_5';
            'Test62_800g_Steigung2_6';
            'Test57_1000g_Burgdorf_5';
            'Test57_1000g_Burgdorf_6';
            'Test63_1000g_Steigung2_5';
            'Test63_1000g_Steigung2_6';
            };
       
loadMatrix = [ 0;
               0;
               0;
               0;
               200;
               200;
               200;
               200;
               400;
               400;
               400;
               400;
               600;
               600;
               600;
               600;
               800;
               800;
               800;
               800;
               1000;
               1000;
               1000;
               1000;
               ];
   
slopeMatrix = [0;
               0;
               2;
               2;
               0;
               0;
               2;
               2;
               0;
               0;
               2;
               2;
               0;
               0;
               2;
               2;
               0;
               0;
               2;
               2;
               0;
               0;
               2;
               2;
               ];
                
save('dataSet_Test_2.mat','dataName','loadMatrix','slopeMatrix');
clear dataName loadMatrix

%% Validation data 2 for NN

dataName = {'Test52_0g_Burgdorf_7';
            'Test52_0g_Burgdorf_8';
            'Test58_0g_Steigung2_7';
            'Test58_0g_Steigung2_8';
            'Test53_200g_Burgdorf_7';
            'Test53_200g_Burgdorf_8';
            'Test59_200g_Steigung2_9';
            'Test59_200g_Steigung2_8';
            'Test54_400g_Burgdorf_7';
            'Test54_400g_Burgdorf_8';
            'Test60_400g_Steigung2_7';
            'Test60_400g_Steigung2_8';
            'Test55_600g_Burgdorf_7';
            'Test55_600g_Burgdorf_8';
            'Test61_600g_Steigung2_7';
            'Test61_600g_Steigung2_8';
            'Test56_800g_Burgdorf_7';
            'Test56_800g_Burgdorf_8';
            'Test62_800g_Steigung2_7';
            'Test62_800g_Steigung2_8';
            'Test57_1000g_Burgdorf_7';
            'Test57_1000g_Burgdorf_8';
            'Test63_1000g_Steigung2_7';
            'Test63_1000g_Steigung2_8';
            };
       
loadMatrix = [ 0;
               0;
               0;
               0;
               200;
               200;
               200;
               200;
               400;
               400;
               400;
               400;
               600;
               600;
               600;
               600;
               800;
               800;
               800;
               800;
               1000;
               1000;
               1000;
               1000;
               ];
   
slopeMatrix = [0;
               0;
               2;
               2;
               0;
               0;
               2;
               2;
               0;
               0;
               2;
               2;
               0;
               0;
               2;
               2;
               0;
               0;
               2;
               2;
               0;
               0;
               2;
               2;
               ];
                
save('dataSet_Vali_2.mat','dataName','loadMatrix','slopeMatrix');
clear dataName loadMatrix

%% Cross Test data Burgdorf for NN

dataName = {'Test52_0g_Burgdorf_9';
            'Test52_0g_Burgdorf_10';
            'Test58_0g_Steigung2_9';
            'Test58_0g_Steigung2_10';
            'Test53_200g_Burgdorf_9';
            'Test53_200g_Burgdorf_8';
            'Test59_200g_Steigung2_9';
            'Test59_200g_Steigung2_10';
            'Test54_400g_Burgdorf_9';
            'Test54_400g_Burgdorf_10';
            'Test60_400g_Steigung2_9';
            'Test60_400g_Steigung2_10';
            'Test55_600g_Burgdorf_9';
            'Test55_600g_Burgdorf_10';
            'Test61_600g_Steigung2_9';
            'Test61_600g_Steigung2_10';
            'Test56_800g_Burgdorf_9';
            'Test56_800g_Burgdorf_10';
            'Test62_800g_Steigung2_9';
            'Test62_800g_Steigung2_10';
            'Test57_1000g_Burgdorf_9';
            'Test57_1000g_Burgdorf_10';
            'Test63_1000g_Steigung2_9';
            'Test63_1000g_Steigung2_10';
            };
       
loadMatrix = [ 0;
               0;
               0;
               0;
               200;
               200;
               200;
               200;
               400;
               400;
               400;
               400;
               600;
               600;
               600;
               600;
               800;
               800;
               800;
               800;
               1000;
               1000;
               1000;
               1000;
               ];
   
slopeMatrix = [0;
               0;
               2;
               2;
               0;
               0;
               2;
               2;
               0;
               0;
               2;
               2;
               0;
               0;
               2;
               2;
               0;
               0;
               2;
               2;
               0;
               0;
               2;
               2;
               ];
                
save('dataSet_CrossTest_2.mat','dataName','loadMatrix','slopeMatrix');
clear dataName loadMatrix
