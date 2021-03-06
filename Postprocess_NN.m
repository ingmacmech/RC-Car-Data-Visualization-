%% Postprocess output from neuronal network

%% plot feature matrix

m = inputSize;
nFeatu = 4;
labelString = {'mu ','sigma ','min ','max '};
loadFaktor = 0.003592727272727^(-1);

if(TDL == true)
    delay = size(inputDelays,2);
else
    delay = 0;
end

figure('units','normalized','outerposition',[0 0 1 1])
    [~,ax] = plotmatrix(input_features);
    
    for i = 0 : m - 1
        for k = 0:nFeatu-1
            ax(i*nFeatu+1+k,1).YLabel.String = strcat(labelString{k+1},...
                                                      num2str(i+1));
            ax(nFeatu*m,i*nFeatu+1+k).XLabel.String = ...
                 strcat(labelString{k+1},num2str(i+1));
        end
    end

%% Plot predictet data to mesured data

figure('units','normalized','outerposition',[0 0 1 1])
                  
hold on
plot(nn_output,'r')
plot(output_features,'b')
hold off
xlabel('Samples (-)')
ylabel('Pitch angle (�)')
legend('estimation','measured');
grid on
grid minor

%% Plot each test dataset
testData.Pitch.Estimated = [];
testData.Pitch.Measured = [];
for n = 1 : size(testData.StartStopFeautres,1)
    
    start = testData.Offset + testData.StartStopFeautres(n,1); 
    stop = testData.Offset + testData.StartStopFeautres(n,2)- delay;
    
    muMes = mean(output_features(start:stop,1));
    stdMes = std(output_features(start:stop,1));
    muEst = mean(nn_output(start:stop,1));
    stdEst = std(nn_output(start:stop,1));
    
    testData.Pitch.Estimated = [testData.Pitch.Estimated;
                      [muEst,stdEst] ];
    testData.Pitch.Measured = [testData.Pitch.Measured;
                      [muMes,stdMes] ];
    
    figure('units','normalized','outerposition',[0 0 1 1])

    hold on
    plot(nn_output(start:stop,1),'r')
    plot(output_features(start:stop,1),'b')
    
    plot([1, size(nn_output(start:stop,1),1)],...
         [mean(nn_output(start:stop,1)) ,...
          mean(nn_output(start:stop,1))], '--r')
    plot([1, size(output_features(start:stop,1),1)],...
         [mean(output_features(start:stop,1)) ,...
          mean(output_features(start:stop,1))], '--b')
   
    hold off
    title(strcat('Test Data-Set:',testData.Name{n}),'Interpreter','none');
    legend('estimated','measured','mean estimated','mean measured');
    xlabel('Samples (-)')
    ylabel('Pitch angle (�)')
    grid on
    grid minor
   
end

%% Plot each validation dataset
valiData.Pitch.Estimated = [];
valiData.Pitch.Measured = [];
for n = 1 : size(valiData.StartStopFeautres,1)
    
    start = valiData.Offset + valiData.StartStopFeautres(n,1);
    stop = valiData.Offset + valiData.StartStopFeautres(n,2)- delay;
    
    muMes = mean(output_features(start:stop,1));
    stdMes = std(output_features(start:stop,1));
    muEst = mean(nn_output(start:stop,1));
    stdEst = std(nn_output(start:stop,1));
    
    valiData.Pitch.Estimated = [valiData.Pitch.Estimated;
                      [muEst,stdEst] ];
    valiData.Pitch.Measured = [valiData.Pitch.Measured;
                      [muMes,stdMes] ];
    
    figure('units','normalized','outerposition',[0 0 1 1])

    hold on
    plot(nn_output(start:stop,1),'r')
    plot(output_features(start:stop,1),'b')
    
    plot([1, size(nn_output(start:stop,1),1)],...
         [mean(nn_output(start:stop,1)) ,...
          mean(nn_output(start:stop,1))], '--r')
    plot([1, size(output_features(start:stop,1),1)],...
         [mean(output_features(start:stop,1)) ,...
          mean(output_features(start:stop,1))], '--b')
   
    hold off
    title(strcat('Test Validation-Set:',valiData.Name{n}),'Interpreter','none');
    legend('estimated','measured','mean estimated','mean measured');
    xlabel('Samples (-)')
    ylabel('Pitch angle (�)')
    grid on
    grid minor
   
end

%% Errorbar plot for test and validation data
figure('units','normalized','outerposition',[0 0 1 1])
valiDataInfo = {''};
testDataInfo = {''};

subplot(1,2,1)
hold on
for n = 1 : size(valiData.StartStopFeautres,1)
    
    start = valiData.Offset + valiData.StartStopFeautres(n,1);
    stop = valiData.Offset + valiData.StartStopFeautres(n,2)- delay;
    
    valiDataInfo = [valiDataInfo;
                num2str(valiData.Load(n))];
    
    if(n == 1)
         
         errorbar(n,valiData.Pitch.Estimated(n,1),...
                  valiData.Pitch.Estimated(n,2),...
                  'or',...
                  'HandleVisibility','on')
              
         errorbar(n,valiData.Pitch.Measured(n,1),...
               valiData.Pitch.Measured(n,2),...
               'ob',...
               'HandleVisibility','on')
           
    else
        errorbar(n,valiData.Pitch.Estimated(n,1),...
                   valiData.Pitch.Estimated(n,2),...
                  'or',...
                  'HandleVisibility','off')
        errorbar(n,valiData.Pitch.Measured(n,1),...
                   valiData.Pitch.Measured(n,2),...
                   'ob',...
                   'HandleVisibility','off')
    end
   
end
hold off

xticks(0:n+1)
set(gca,'XtickLabel',valiDataInfo)
xlim([0 n+1])
grid minor
grid on
xlabel('Load Condition')
ylabel('Pitch angle (�)')
legend('NN Estimation','Target Value')
title('Validation-Data Results')
ylim([-1 7])

subplot(1,2,2)
hold on
for n = 1 : size(testData.StartStopFeautres,1)
    
    start = testData.Offset + testData.StartStopFeautres(n,1);
    stop = testData.Offset + testData.StartStopFeautres(n,2)- delay;
    
    testDataInfo = [testDataInfo;
                    num2str(testData.Load(n))];
    
    if(n == 1)
        errorbar(n,testData.Pitch.Estimated(n,1),...
                  testData.Pitch.Estimated(n,2),...
                  'or',...
                  'HandleVisibility','on')
         errorbar(n,testData.Pitch.Measured(n,1),...
               testData.Pitch.Measured(n,2),...
               'ob',...
               'HandleVisibility','on')
    else
        
        errorbar(n,testData.Pitch.Estimated(n,1),...
                  testData.Pitch.Estimated(n,2),...
                  'or',...
                  'HandleVisibility','off')
        errorbar(n,testData.Pitch.Measured(n,1),...
                   testData.Pitch.Measured(n,2),...
                   'ob',...
                   'HandleVisibility','off')
    end
   
end
hold off

xticks(0:n+1)
set(gca,'XtickLabel',testDataInfo)
xlim([0 n+1])
grid minor
grid on
xlabel('Load Condition')
ylabel('Pitch angle (�)')
legend('NN Estimation','Target Value')
title('Test-Data Results')
ylim([-1 7])


%% Errorbar plot for test and validation data converted in mass
figure('units','normalized','outerposition',[0 0 1 1])
valiDataInfo = {''};
testDataInfo = {''};

subplot(1,2,1)
hold on
for n = 1 : size(valiData.StartStopFeautres,1)
    
    start = valiData.Offset + valiData.StartStopFeautres(n,1);
    stop = valiData.Offset + valiData.StartStopFeautres(n,2)- delay;
    
    valiDataInfo = [valiDataInfo;
                num2str(valiData.Load(n))];
    
    if(n == 1)
         
         errorbar(n,valiData.Pitch.Estimated(n,1)*loadFaktor,...
                  valiData.Pitch.Estimated(n,2)*loadFaktor,...
                  'or',...
                  'HandleVisibility','on')
              
         errorbar(n,valiData.Pitch.Measured(n,1)*loadFaktor,...
               valiData.Pitch.Measured(n,2)*loadFaktor,...
               'ob',...
               'HandleVisibility','on')
           
    else
        errorbar(n,valiData.Pitch.Estimated(n,1)*loadFaktor,...
                   valiData.Pitch.Estimated(n,2)*loadFaktor,...
                  'or',...
                  'HandleVisibility','off')
        errorbar(n,valiData.Pitch.Measured(n,1)*loadFaktor,...
                   valiData.Pitch.Measured(n,2)*loadFaktor,...
                   'ob',...
                   'HandleVisibility','off')
    end
   
end
hold off

xticks(0:n+1)
set(gca,'XtickLabel',valiDataInfo)
xlim([0 n+1])
grid minor
grid on
xlabel('Load Condition(gr)')
ylabel('Estimated mass (gr)')
legend('NN Estimation','Target Value')
title('Validation-Data Results')
ylim([0 1600])

subplot(1,2,2)
hold on
for n = 1 : size(testData.StartStopFeautres,1)
    
    start = testData.Offset + testData.StartStopFeautres(n,1);
    stop = testData.Offset + testData.StartStopFeautres(n,2)- delay;
    
    testDataInfo = [testDataInfo;
                    num2str(testData.Load(n))];
    
    if(n == 1)
        errorbar(n,testData.Pitch.Estimated(n,1)*loadFaktor,...
                  testData.Pitch.Estimated(n,2)*loadFaktor,...
                  'or',...
                  'HandleVisibility','on')
         errorbar(n,testData.Pitch.Measured(n,1)*loadFaktor,...
               testData.Pitch.Measured(n,2)*loadFaktor,...
               'ob',...
               'HandleVisibility','on')
    else
        
        errorbar(n,testData.Pitch.Estimated(n,1)*loadFaktor,...
                  testData.Pitch.Estimated(n,2)*loadFaktor,...
                  'or',...
                  'HandleVisibility','off')
        errorbar(n,testData.Pitch.Measured(n,1)*loadFaktor,...
                   testData.Pitch.Measured(n,2)*loadFaktor,...
                   'ob',...
                   'HandleVisibility','off')
    end
   
end
hold off

xticks(0:n+1)
set(gca,'XtickLabel',testDataInfo)
xlim([0 n+1])
grid minor
grid on
xlabel('Load Condition (gr)')
ylabel('Estimated Load (gr)')
legend('NN Estimation','Target Value')
title('Test-Data Results')
ylim([0 1600])

%% Errorbar plot for cross data 
figure('units','normalized','outerposition',[0 0 1 1])
crossDataInfo = {''};
crossData.Pitch.Estimated = [];
crossData.Pitch.Measured = [];
hold on
for n = 1 : size(crossData.StartStopFeautres,1)
    
    start = crossData.StartStopFeautres(n,1);
    stop = crossData.StartStopFeautres(n,2)- delay;
    
    muMes = mean(crossData.OutputFeautures(start:stop,1));
    stdMes = std(crossData.OutputFeautures(start:stop,1));
    muEst = mean(nn_cross_output(start:stop,1));
    stdEst = std(nn_cross_output(start:stop,1));
    
    crossData.Pitch.Estimated = [crossData.Pitch.Estimated;
                      [muEst,stdEst] ];
    crossData.Pitch.Measured = [crossData.Pitch.Measured;
                      [muMes,stdMes] ];
    
    crossDataInfo = [crossDataInfo;
                num2str(crossData.Load(n))];
    
    if(n == 1)
         
         errorbar(n,crossData.Pitch.Estimated(n,1),...
                  crossData.Pitch.Estimated(n,2),...
                  'or',...
                  'HandleVisibility','on')
              
         errorbar(n,crossData.Pitch.Measured(n,1),...
               crossData.Pitch.Measured(n,2),...
               'ob',...
               'HandleVisibility','on')
           
    else
        errorbar(n,crossData.Pitch.Estimated(n,1),...
                   crossData.Pitch.Estimated(n,2),...
                  'or',...
                  'HandleVisibility','off')
        errorbar(n,crossData.Pitch.Measured(n,1),...
                   crossData.Pitch.Measured(n,2),...
                   'ob',...
                   'HandleVisibility','off')
    end
   
end
hold off

xticks(0:n+1)
set(gca,'XtickLabel',crossDataInfo)
xlim([0 n+1])
grid minor
grid on
xlabel('Load Condition')
ylabel('Pitch angle (�)')
legend('NN Estimation','Target Value')
title('Cross-Data Results')
ylim([-1 7])
