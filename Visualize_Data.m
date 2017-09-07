clear;
clc;
close all;
%% Add path to sub folders
currentPath = pwd;
addpath(genpath(currentPath));
clear currentPath;

%% Set converting factors for sensor data 

nullPostThrottle = 4555;% Null position value throttle
nullPosSteering = 4648; % Null position value steering
accMult = 1 / 16384;    % Conversion factor between int and g
gyroMult = 1/ 65.5;     % Converstion factor between int and �/s
timerFreq = 18e6;       % Timer frequency for wheel speed
samplingFreq = 20;      % Sampling frequency in Hz

%% List of data to open and data ending
dataType = {'.txt'};

dataName = {'Test_900g_1';
            'Test_900g_2';
            'Test_900g_3'};
           
nFiles = length(dataName);
nColumns = 11;              % The number of columns in the data file + 1


%% Load data
for n = 1 : nFiles
    data.raw.(dataName{n}) = load(char(strcat(dataName(n),dataType)));
end

%% Add a time vector to the raw data
for n = 1 : nFiles
    time =...
    (0 : 1/samplingFreq :(length(data.raw.(dataName{n}))-1) * 1/samplingFreq)';
    
    data.raw.(dataName{n}) = [time , data.raw.(dataName{n})];
    clear time;    
end

%% Convert raw data to ing units
for n = 1 : nFiles
    for m = 1 : nColumns
        switch(m)
            case 1
                % Copy time vektor
                data.ing.(dataName{n}) = data.raw.(dataName{n})(:,1);
            case 2
                % Convert throttle data
                temp = data.raw.(dataName{n})(:,2) - nullPostThrottle;
                data.ing.(dataName{n}) = [data.ing.(dataName{n}), temp];
                clear temp;
            case 3
                % Convert steering data
                temp = data.raw.(dataName{n})(:,3) - nullPosSteering;
                data.ing.(dataName{n}) = [data.ing.(dataName{n}), temp];
                clear temp;
            case 4
                % Convert wheel speed front left data from int to 1/min
                temp = ((data.raw.(dataName{n})(:,4)/timerFreq).^(-1))*60;
                data.ing.(dataName{n}) = [data.ing.(dataName{n}), temp];
                clear temp;
            case 5
                % Convert wheel speed front right data from int to 1/min
                temp = ((data.raw.(dataName{n})(:,5)/timerFreq).^(-1))*60;
                data.ing.(dataName{n}) = [data.ing.(dataName{n}), temp];
                clear temp;
            case 6
                % Convert acceleration data x-axis from int to g
                temp = data.raw.(dataName{n})(:,6) * accMult;
                data.ing.(dataName{n}) = [data.ing.(dataName{n}), temp];
                clear temp;
            case 7
                % Convert acceleration data y-axis from int to g
                temp = data.raw.(dataName{n})(:,7) * accMult;
                data.ing.(dataName{n}) = [data.ing.(dataName{n}), temp];
                clear temp;
            case 8
                % Convert acceleration data z-axis from int to g
                temp = data.raw.(dataName{n})(:,8) * accMult;
                data.ing.(dataName{n}) = [data.ing.(dataName{n}), temp];
                clear temp;
            case 9
                % Convert gyroscope data x-axis from int to g
                temp = data.raw.(dataName{n})(:,9) * gyroMult;
                data.ing.(dataName{n}) = [data.ing.(dataName{n}), temp];
                clear temp;
            case 10
                % Convert gyroscope data y-axis from int to g
                temp = data.raw.(dataName{n})(:,10) * gyroMult;
                data.ing.(dataName{n}) = [data.ing.(dataName{n}), temp];
                clear temp;
            case 11
                % Convert gyroscope data z-axis from int to g
                temp = data.raw.(dataName{n})(:,11) * gyroMult;
                data.ing.(dataName{n}) = [data.ing.(dataName{n}), temp];
                clear temp;
        end         
    end
end


%% Plot data vs time
for n = 1 : nFiles
    figure('units','normalized','outerposition',[0 0 1 1])
            annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            strcat({''},dataName{n},{' - Time Domain'}),...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
    
    subplot(4,1,1)
        hold on
        plot(data.ing.(dataName{n})(:,1), data.ing.(dataName{n})(:,2))
        plot(data.ing.(dataName{n})(:,1), data.ing.(dataName{n})(:,3))
        title('Steering and Throttle')
        xlabel('Time s')
        ylabel('-')
        legend('Throttle', 'Steering')
        grid minor
        hold off
    
    subplot(4,1,2)
        hold on
        plot(data.ing.(dataName{n})(:,1), data.ing.(dataName{n})(:,4))
        plot(data.ing.(dataName{n})(:,1), data.ing.(dataName{n})(:,5))
        title('Wheel Speed')
        xlabel('Time s')
        ylabel('Revolutions 1/min')
        legend('Front left','Front right')
        grid minor
        hold off
        
     subplot(4,1,3)
        hold on
        plot(data.ing.(dataName{n})(:,1), data.ing.(dataName{n})(:,6))
        plot(data.ing.(dataName{n})(:,1), data.ing.(dataName{n})(:,7))
        plot(data.ing.(dataName{n})(:,1), data.ing.(dataName{n})(:,8))
        title('Acceleration')
        xlabel('Time s')
        ylabel('g')
        legend('x-Axis','y-Axis','z-Axis')
        grid minor
        hold off
        
     subplot(4,1,4)
        hold on
        plot(data.ing.(dataName{n})(:,1), data.ing.(dataName{n})(:,9))
        plot(data.ing.(dataName{n})(:,1), data.ing.(dataName{n})(:,10))
        plot(data.ing.(dataName{n})(:,1), data.ing.(dataName{n})(:,11))
        title('Gyroscope')
        xlabel('Time s')
        ylabel('Turn rate �/s')
        legend('x-Axis','y-Axis','z-Axis')
        grid minor
        hold off
end

%% Plot g-force data scatter 
for n = 1 : nFiles
    figure('units','normalized','outerposition',[0 0 1 1])
            annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            strcat({''},dataName{n},{' g-Force'}),...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
    hold on
        scatter(data.ing.(dataName{n})(:,7),...
                data.ing.(dataName{n})(:,6), 12,...
                data.ing.(dataName{n})(:,8),'filled')
            
        xlabel('y-Axis g')
        ylabel('x-Axis g')
        grid minor
        
        colorbar;       % Set color bar 
        colormap jet;   % Set colormap to red and blue
        
        axis square;
        axis([-2 2 -2 2]);
        caxis([-2 2]);
        viscircles([0 0], 2, 'Color', 'k', 'LineWidth', 1);
        viscircles([0 0], 1.5, 'Color', 'k', 'LineWidth', 1,...
                             'LineStyle', ':')
        viscircles([0 0], 1, 'Color', 'k', 'LineWidth', 1,...
                             'LineStyle', ':')
        viscircles([0 0], 0.5, 'Color', 'k', 'LineWidth', 1,...
                             'LineStyle', ':')
        
        hold off
    
end


