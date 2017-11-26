%% Postprocess output from neuronal network


%% Plot predictet data to mesured data

figure('units','normalized','outerposition',[0 0 1 1])
                  
hold on
plot(nn_output)
plot(output)
hold off
xlabel('Samples (-)')
ylabel('Pitch angle (°)')
legend('estimation','measured');
grid on
grid minor

for n = 1 : size(testData.StartStopFeautres,1)
    
    start = testData.StartStopFeautres(n,1);
    stop = testData.StartStopFeautres(n,1);
    
    figure('units','normalized','outerposition',[0 0 1 1])

    hold on
    plot(testData.OutputFeautures(start:stop,1))
    plot(nn_output(start:stop,1))
    plot([1, size(testData.OutputFeautures(start:stop,1))],...
         [mean(testData.OutputFeautures(start:stop,1)) ,...
          mean(testData.OutputFeautures(start:stop,1))], '--r')
    plot([1, size(nn_output(start:stop,1))],...
         [mean(nn_output(start:stop,1)) ,...
          mean(nn_output(start:stop,1))], '--r')
   
    hold off
    
    
end

