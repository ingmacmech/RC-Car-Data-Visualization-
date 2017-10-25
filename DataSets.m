%% Set different data sets


% First data set recorded
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

% data set with slope 

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