%% Postprocess output from neuronal network

%% plot feature matrix

m = inputSize;
nFeatu = 4;
labelString = {'mu ','sigma ','min ','max '};

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
ylabel('Pitch angle (°)')
legend('estimation','measured');
grid on
grid minor

%% Plot each test dataset
testData.Pitch = [];
for n = 1 : size(testData.StartStopFeautres,1)
    
    start = testData.Offset + testData.StartStopFeautres(n,1);
    stop = testData.Offset + testData.StartStopFeautres(n,2);
    
    testData.Pitch = [testData.Pitch;
                      [mean(nn_output(start:stop,1)),...
                      mean(output_features(start:stop,1)),...
                      mean(output_features(start:stop,1))-...
                      mean(nn_output(start:stop,1))]
                      ];
    
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
    ylabel('Pitch angle (°)')
   
end

%% Plot each validation dataset
testData.Pitch = [];
for n = 1 : size(valiData.StartStopFeautres,1)
    
    start = valiData.Offset + valiData.StartStopFeautres(n,1);
    stop = valiData.Offset + valiData.StartStopFeautres(n,2);
    
    valiData.Pitch = [testData.Pitch;
                      [mean(nn_output(start:stop,1)),...
                      mean(output_features(start:stop,1)),...
                      mean(output_features(start:stop,1))-...
                      mean(nn_output(start:stop,1))]
                      ];
    
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
    ylabel('Pitch angle (°)')
   
end

