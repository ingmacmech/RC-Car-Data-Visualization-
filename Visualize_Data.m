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
gyroMult = 1/ 65.5;     % Converstion factor between int and °/s
timerFreq = 18e6;       % Timer frequency for wheel speed
samplingFreq = 20;      % Sampling frequency in Hz

%% List of data to open and data ending
dataType = {'.txt'};

dataName = {'Test_900g_1';
            'Test_900g_2';
            'Test_900g_3'};
           
nFiles = length(dataName);
nColumns = 11;              % The number of columns in the data file + 1

%% Columns
t=1;        % Column 1 time vector
thr=2;      % Column 2 throttle vector
ste=3;      % Column 3 steering vector
nFL=4;      % Column 4 wheel speed front left
nFR=5;      % Column 5 wheel speed front right
ax=6;       % Column 6 acceleration x-Axis
ay=7;       % Column 7 acceleration y-Axis
az=8;       % Column 8 acceleration z-Axis
gx=9;       % Column 9 gyroscope x-Axis
gy=10;      % Column 10 gyroscope y-Axis
gz=11;      % Column 11 gyroscope z-Axis

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
                data.ing.(dataName{n}) = data.raw.(dataName{n})(:,t);
            case 2
                % Convert throttle data
                temp = data.raw.(dataName{n})(:,thr) - nullPostThrottle;
                data.ing.(dataName{n}) = [data.ing.(dataName{n}), temp];
                clear temp;
            case 3
                % Convert steering data
                temp = data.raw.(dataName{n})(:,ste) - nullPosSteering;
                data.ing.(dataName{n}) = [data.ing.(dataName{n}), temp];
                clear temp;
            case 4
                % Convert wheel speed front left data from int to 1/min
                temp = ((data.raw.(dataName{n})(:,nFL)/timerFreq).^(-1))*60;
                data.ing.(dataName{n}) = [data.ing.(dataName{n}), temp];
                clear temp;
            case 5
                % Convert wheel speed front right data from int to 1/min
                temp = ((data.raw.(dataName{n})(:,nFR)/timerFreq).^(-1))*60;
                data.ing.(dataName{n}) = [data.ing.(dataName{n}), temp];
                clear temp;
            case 6
                % Convert acceleration data x-axis from int to g
                temp = data.raw.(dataName{n})(:,ax) * accMult;
                data.ing.(dataName{n}) = [data.ing.(dataName{n}), temp];
                clear temp;
            case 7
                % Convert acceleration data y-axis from int to g
                temp = data.raw.(dataName{n})(:,ay) * accMult;
                data.ing.(dataName{n}) = [data.ing.(dataName{n}), temp];
                clear temp;
            case 8
                % Convert acceleration data z-axis from int to g
                temp = data.raw.(dataName{n})(:,az) * accMult;
                data.ing.(dataName{n}) = [data.ing.(dataName{n}), temp];
                clear temp;
            case 9
                % Convert gyroscope data x-axis from int to g
                temp = data.raw.(dataName{n})(:,gx) * gyroMult;
                data.ing.(dataName{n}) = [data.ing.(dataName{n}), temp];
                clear temp;
            case 10
                % Convert gyroscope data y-axis from int to g
                temp = data.raw.(dataName{n})(:,gy) * gyroMult;
                data.ing.(dataName{n}) = [data.ing.(dataName{n}), temp];
                clear temp;
            case 11
                % Convert gyroscope data z-axis from int to g
                temp = data.raw.(dataName{n})(:,gz) * gyroMult;
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
        plot(data.ing.(dataName{n})(:,t), data.ing.(dataName{n})(:,thr))
        plot(data.ing.(dataName{n})(:,t), data.ing.(dataName{n})(:,ste))
        title('Steering and Throttle')
        xlabel('Time s')
        ylabel('-')
        legend('Throttle', 'Steering')
        grid minor
        hold off
    
    subplot(4,1,2)
        hold on
        plot(data.ing.(dataName{n})(:,t), data.ing.(dataName{n})(:,nFL))
        plot(data.ing.(dataName{n})(:,t), data.ing.(dataName{n})(:,nFR))
        title('Wheel Speed')
        xlabel('Time s')
        ylabel('Revolutions 1/min')
        legend('Front left','Front right')
        grid minor
        hold off
        
     subplot(4,1,3)
        hold on
        plot(data.ing.(dataName{n})(:,t), data.ing.(dataName{n})(:,ax))
        plot(data.ing.(dataName{n})(:,t), data.ing.(dataName{n})(:,ay))
        plot(data.ing.(dataName{n})(:,t), data.ing.(dataName{n})(:,az))
        title('Acceleration')
        xlabel('Time s')
        ylabel('g')
        legend('x-Axis','y-Axis','z-Axis')
        grid minor
        hold off
        
     subplot(4,1,4)
        hold on
        plot(data.ing.(dataName{n})(:,t), data.ing.(dataName{n})(:,gx))
        plot(data.ing.(dataName{n})(:,t), data.ing.(dataName{n})(:,gy))
        plot(data.ing.(dataName{n})(:,t), data.ing.(dataName{n})(:,gz))
        title('Gyroscope')
        xlabel('Time s')
        ylabel('Turn rate °/s')
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
        scatter(data.ing.(dataName{n})(:,ay),...
                data.ing.(dataName{n})(:,ax), 20,...
                data.ing.(dataName{n})(:,az),'filled');
            
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
                             'LineStyle', ':');
        viscircles([0 0], 1, 'Color', 'k', 'LineWidth', 1,...
                             'LineStyle', ':');
        viscircles([0 0], 0.5, 'Color', 'k', 'LineWidth', 1,...
                             'LineStyle', ':');
        
        hold off
    
end

%% Plot the acceleration data and corresponding RC-Controll values
for n = 1 : nFiles
    
    figure('units','normalized','outerposition',[0 0 1 1])
            annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            strcat({''},dataName{n},...
           {' Acceleration data and corresponding RC-Controll values'}),...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
        
        subplot(3,1,1)
           hold on
           title('x-Axis acceleration and throttle')
           yyaxis left
           plot(data.ing.(dataName{n})(:,t),data.ing.(dataName{n})(:,ax));
           ylabel('g')
           ylim([-2 2])
           grid minor
           
           yyaxis right
           plot(data.ing.(dataName{n})(:,t),data.ing.(dataName{n})(:,thr));
           ylabel('-')
           xlabel('Time s')
           ylim([-2000 2000])
           legend('x-Axis Acceleration','Throttle')
           hold off
           
        subplot(3,1,2)
           hold on
           title('y-Axis acceleration and steering')
           yyaxis left
           plot(data.ing.(dataName{n})(:,t),data.ing.(dataName{n})(:,ay));
           ylabel('g')
           ylim([-2 2])
           grid minor
           
           yyaxis right
           plot(data.ing.(dataName{n})(:,t),data.ing.(dataName{n})(:,ste));
           ylabel('Steering -')
           xlabel('Time s')
           ylim([-2000 2000])
           legend('y-Axis Acceleration','Steering')
           hold off
           
        subplot(3,1,3)
           hold on
           title('z-Axis acceleration and throttle')
           yyaxis left
           plot(data.ing.(dataName{n})(:,t),data.ing.(dataName{n})(:,az));
           ylabel('g')
           ylim([-2 2])
           grid minor
           
           yyaxis right
           plot(data.ing.(dataName{n})(:,t),data.ing.(dataName{n})(:,thr));
           ylabel('Throttle -')
           xlabel('Time s')
           ylim([-2000 2000])
           legend('z-Axis Acceleration','Throttle')
           hold off
end

%% Plot each acceleration axis data vs RC-Controll valuesa
for n = 1 : nFiles
    figure('units','normalized','outerposition',[0 0 1 1])
            annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            strcat({''},dataName{n},...
           {' Acceleration vs. RC-Controll Data'}),...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
    
    subplot(2,3,1)
        hold on
        plot(data.ing.(dataName{n})(:,thr)/1000,...
             data.ing.(dataName{n})(:,ax),'+');
        axis([-2 2 -2 2])
        xlabel('Throttle -')
        ylabel('x-Axis g')
        grid minor
        hold off
    
    subplot(2,3,2)
        hold on
        plot(data.ing.(dataName{n})(:,thr)/1000,...
             data.ing.(dataName{n})(:,ay),'+');
        axis([-2 2 -2 2])
        xlabel('Throttle -')
        ylabel('y-Axis g')
        grid minor
        
         hold off
        
    subplot(2,3,3)
        hold on
        plot(data.ing.(dataName{n})(:,thr)/1000,...
             data.ing.(dataName{n})(:,az),'+');
        axis([-2 2 -2 2])
        xlabel('Throttle -')
        ylabel('z-Axis g')
        grid minor
        hold off
        
    subplot(2,3,4)
        hold on
        plot(data.ing.(dataName{n})(:,ste)/1000,...
             data.ing.(dataName{n})(:,ax),'+');
        axis([-2 2 -2 2])
        xlabel('Steering -')
        ylabel('x-Axis g')
        grid minor
        hold off
        
    subplot(2,3,5)
        hold on
        plot(data.ing.(dataName{n})(:,ste)/1000,...
             data.ing.(dataName{n})(:,ay),'+');
        axis([-2 2 -2 2])
        xlabel('Steering -')
        ylabel('y-Axis g')
        grid minor
        hold off
        
    subplot(2,3,6)
        hold on
        plot(data.ing.(dataName{n})(:,ste)/1000,...
             data.ing.(dataName{n})(:,az),'+');
        axis([-2 2 -2 2])
        xlabel('Steering -')
        ylabel('z-Axis g')
        grid minor
        hold off
    
end

%% Plot histogramm for acceleration data
for n = 1 : nFiles
     figure('units','normalized','outerposition',[0 0 1 1])
            annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            strcat({''},dataName{n},...
           {' Acceleration Histograms'}),...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
        
     subplot(3,1,1)
        hold on
        histogram(data.ing.(dataName{n})(:,ax),30);
        xlim([-2 2])
        ylabel('Occurencies')
        xlabel('Acceleration x-Axis')
        hold off
       
     subplot(3,1,2)
        hold on
        histogram(data.ing.(dataName{n})(:,ay),30);
        xlim([-2 2])
        ylabel('Occurencies')
        xlabel('Acceleration y-Axis')
        hold off

     subplot(3,1,3)
        hold on
        histogram(data.ing.(dataName{n})(:,az),30);
        xlim([-2 2])
        ylabel('Occurencies')
        xlabel('Acceleration z-Axis')
        hold off
end
