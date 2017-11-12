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