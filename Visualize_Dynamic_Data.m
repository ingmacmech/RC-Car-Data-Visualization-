%% TODO:
% -- Replace all isfield ifs with flagMatrix (better solution)

%% Clear all resources
clear;
clc;
close all;

%% Add path to sub folders
currentPath = pwd;
addpath(genpath(currentPath));
clear currentPath;

%% Load cal struct 
% to create cal struct run Calibration.m first
load('cal');

%% List of data to open and data ending
dataType = {'.txt'};

dataName = {'Test1_0g_HV_0grad_1' , 'Test1_0g_HV_0grad_2' , 'Test1_0g_HV_0grad_3' , 'Test1_0g_HV_0grad_4';
            'Test2_900gH_0grad_1' , 'Test2_900gH_0grad_2' , 'Test2_900gH_0grad_3' , 'Test2_900gH_0grad_4';
            'Test1_0g_HV_0grad_1' , 'Test2_900gH_0grad_1' , 'Test1_0g_HV_0grad_2' , 'Test2_900gH_0grad_2';
            'Test1_0g_HV_0grad_3' , 'Test2_900gH_0grad_3' , 'Test1_0g_HV_0grad_4' , 'Test2_900gH_0grad_4'
            };

loadMatrix = [      0             ,          0            ,             0         ,           0;
                    1             ,          1            ,             1         ,           1; 
                    0             ,          1            ,             0         ,           1;
                    0             ,          1            ,             0         ,           1]; 

nFiles = size(dataName,1);  % How many plots
mFiles = size(dataName,2);  % How many coparisson data in one plot
nColumns = 11;              % The number of columns in the data file + 1
flagMatrix = false(nFiles,mFiles); % Specifies wich data set is to ignore 
                                   % not to plot or process same data sets 
                                   % multipel times
%% Plot Controlls
filteredOverlay = true;

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

%% Marker styles 
markerType = {'o','+','*','.','x','s','d','^','v','>','<','p','h'};


%% Load data
data.raw = struct;
for n = 1 : nFiles
    for m = 1 : mFiles
        if ~(isfield(data.raw, dataName{n,m}))
            data.raw.(dataName{n,m}) =...
                                load(char(strcat(dataName(n,m),dataType)));
        end
    end
end

%% Add a time vector to the raw data and init flagMatrix 
for n = 1 : nFiles
    for m = 1 : mFiles
        if ~(size(data.raw.(dataName{n,m}),2) >= nColumns) 
            time =...
            (0 : 1/cal.settings.samplingFreq :...
               (length(data.raw.(dataName{n,m}))-1) *...
               1/cal.settings.samplingFreq)';

            data.raw.(dataName{n,m}) = [time , data.raw.(dataName{n,m})];
            flagMatrix(n,m) = true;
            data.ploted.(dataName{n,m}) = 0; %TODO: replace with flagMatrix
            clear time;
        end
    end
end

%% Convert raw data to ing units
data.ing = struct;
for n = 1 : nFiles
    for m = 1 : mFiles
        if ~(isfield(data.ing, dataName{n,m}))
            for i = 1 : nColumns
                switch(i)
                    case 1
                        % Copy time vektor
                        data.ing.(dataName{n,m}) =...
                                            data.raw.(dataName{n,m})(:,t);
                    case 2
                        % Convert throttle data
                        temp = polyval(cal.throttle.polyVal,...
                                       data.raw.(dataName{n,m})(:,thr));
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case 3
                        % Convert steering data
                        temp = polyval(cal.steering.polyVal,...
                                       data.raw.(dataName{n,m})(:,ste));
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case 4
                   % Convert wheel speed front left data from int to 1/min
                        temp = (cal.wheel.n ./...
                                data.raw.(dataName{n,m})(:,nFL));
                        % replace inf with zero
                        temp(~isfinite(temp))=0;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case 5
                   % Convert wheel speed front right data from int to 1/min     
                        temp = (cal.wheel.n ./...
                                data.raw.(dataName{n,m})(:,nFR));
                        % replace inf with zero
                        temp(~isfinite(temp))=0;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        
                        clear temp;
                    case 6
                        % Convert acceleration data x-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,ax)*cal.acc.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case 7
                        % Convert acceleration data y-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,ay)*cal.acc.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case 8
                        % Convert acceleration data z-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,az)*cal.acc.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case 9
                        % Convert gyroscope data x-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,gx) *...
                                                             cal.gyro.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case 10
                        % Convert gyroscope data y-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,gy) *...
                                                             cal.gyro.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case 11
                        % Convert gyroscope data z-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,gz) *...
                                                             cal.gyro.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                end 
            end
        end
    end
end



%% Data smothing
data.filtered = struct;
f = Test_Filter();
for n = 1 : nFiles
    for m = 1 : mFiles
        if ~(isfield(data.filtered, dataName{n,m}))
            for i = 1 : nColumns
               switch i
                   case t
                       % Coppy time vector
                       data.filtered.(dataName{n,m}) = ...
                            data.ing.(dataName{n,m})(:,t);
                   case thr
                       % no change to throttle data
                       data.filtered.(dataName{n,m}) = ...
                            [data.filtered.(dataName{n,m}),...
                             data.ing.(dataName{n,m})(:,thr)];
                   case ste
                       % No change to steering data
                       data.filtered.(dataName{n,m}) = ...
                            [data.filtered.(dataName{n,m}),...
                             data.ing.(dataName{n,m})(:,ste)];
                   case nFL
                       % Smooth wheel speed data to eliminate spikes
                       data.filtered.(dataName{n,m}) = ...
                           [data.filtered.(dataName{n,m}),...
                            smooth(data.ing.(dataName{n,m})(:,nFL),...
                            0.004,'rloess')];
                   case nFR
                       data.filtered.(dataName{n,m}) = ...
                           [data.filtered.(dataName{n,m}),...
                            smooth(data.ing.(dataName{n,m})(:,nFR),...
                            0.004,'rloess')];
                   case ax
                       data.filtered.(dataName{n,m}) =...
                           [data.filtered.(dataName{n,m}),...
                           smooth(data.ing.(dataName{n,m})(:,ax),...
                           0.0021,'rloess')];                       
                   case ay
                       data.filtered.(dataName{n,m}) =...
                           [data.filtered.(dataName{n,m}),...
                           smooth(data.ing.(dataName{n,m})(:,ay),...
                           0.0021,'rloess')];
                   case az
                       data.filtered.(dataName{n,m}) =...
                           [data.filtered.(dataName{n,m}),...
                           smooth(data.ing.(dataName{n,m})(:,az),...
                           0.0021,'rloess')];
                   case gx
                       data.filtered.(dataName{n,m}) =...
                           [data.filtered.(dataName{n,m}),...
                           smooth(data.ing.(dataName{n,m})(:,gx),...
                           0.0021,'rloess')]; 
                   case gy
                       data.filtered.(dataName{n,m}) =...
                           [data.filtered.(dataName{n,m}),...
                           smooth(data.ing.(dataName{n,m})(:,gy),...
                           0.0021,'rloess')];
                   case gz
                       data.filtered.(dataName{n,m}) =...
                           [data.filtered.(dataName{n,m}),...
                           smooth(data.ing.(dataName{n,m})(:,gz),...
                           0.0021,'rloess')];
               end
            end
        end
    end
end

%% PCA Analysis on the data
data.pca.set = struct;
data.pca.label = struct;
data.pca.coef = struct;
data.pca.scores = struct;
data.pca.pcvars = struct;
firstEnteringFlag = true;

for n = 1 : nFiles
    for m = 1 : mFiles
        if (flagMatrix(n,m) == true)
            % Put different datasets togeter
            if(firstEnteringFlag == true)
                data.pca.set = data.ing.(dataName{n,m})(:,2:end);
                if(loadMatrix(n,m) == 1)
                    data.pca.label =...
                                  ones(size(data.ing.(dataName{n,m}),1),1);
                else
                    data.pca.label =...
                                  zeros(size(data.ing.(dataName{n,m}),1),1);
                end
                firstEnteringFlag = false;
            else
                data.pca.set = [data.pca.set;...
                                data.ing.(dataName{n,m})(:,2:end)];
                if(loadMatrix(n,m) == 1)
                    data.pca.label =...
                             [data.pca.label;...
                             ones(size(data.ing.(dataName{n,m}),1),1)];
                else
                    data.pca.label =...
                             [data.pca.label;...
                             zeros(size(data.ing.(dataName{n,m}),1),1)];
                end
            end
        end
    end
end

[data.pca.coef,data.pca.scores,data.pca.pcvars] =...
                                    pca(data.pca.set);

clear firstEnteringFlag;

%% Calculating rms value for Data
data.rms = struct;
data.rms.pitch = struct;
for n = 1 : nFiles
    for m = 1 : mFiles
        if (flagMatrix == true)
            data.rms.(dataName{n,m}) = rms(data.ing.(dataName{n,m}),1);
            data.rms.pitch.(dataName{n,m}) = atan(data.rms.(dataName{n,m})(1,6)/...
                                          data.rms.(dataName{n,m})(1,8));
        end
    end
end

%% Calculating pitch angle with data
data.pitch = struct;

for n = 1 : nFiles
    for m = 1 : mFiles
        if (flagMatrix(n,m) == true)
            data.pitch.(dataName{n,m}) = atan(data.ing.(dataName{n,m})(:,6))./...
                                              data.ing.(dataName{n,m})(:,8);
        end
    end
end

%% Calculate Power Spectral Density for acceleration and gyro data
% Data is filtered with a filter specifyed by psdFilter.m
data.psd = struct;
fHp = psdFilter;

for n = 1 : nFiles
    for m = 1 : mFiles
        if ~(isfield(data.psd, dataName{n,m}))
            for i = 1 : 6
                switch i
                    case 1
                        [p,f] = pwelch(filter(fHp,data.ing.(dataName{n,m})(:,ax)),...
                                       [],[],[],cal.settings.samplingFreq);
                        data.psd.(dataName{n,m}) = [f, p];
                        clear p f;
                    case 2
                        [p,f] = pwelch(filter(fHp,data.ing.(dataName{n,m})(:,ay)),...
                                       [],[],[],cal.settings.samplingFreq);
                        data.psd.(dataName{n,m}) =...
                                             [data.psd.(dataName{n,m}), p];
                        clear p f;
                    case 3
                        [p,f] = pwelch(filter(fHp,data.ing.(dataName{n,m})(:,az)),...
                                       [],[],[],cal.settings.samplingFreq);
                        data.psd.(dataName{n,m}) =...
                                             [data.psd.(dataName{n,m}), p];
                        clear p f;
                    case 4
                        [p,f] = pwelch(filter(fHp,data.ing.(dataName{n,m})(:,gx)),...
                                       [],[],[],cal.settings.samplingFreq);
                        data.psd.(dataName{n,m}) =...
                                             [data.psd.(dataName{n,m}), p];
                        clear p f;
                    case 5
                        [p,f] = pwelch(filter(fHp,data.ing.(dataName{n,m})(:,gy)),...
                                       [],[],[],cal.settings.samplingFreq);
                        data.psd.(dataName{n,m}) =...
                                             [data.psd.(dataName{n,m}), p];
                        clear p f;
                    case 6
                        [p,f] = pwelch(filter(fHp,data.ing.(dataName{n,m})(:,gz)),...
                                       [],[],[],cal.settings.samplingFreq);
                        data.psd.(dataName{n,m}) =...
                                             [data.psd.(dataName{n,m}), p];
                        clear p f;
                end
            end
        end
    end
end

%% Plot data vs time
for n = 1 : nFiles
    for m = 1 : mFiles
        % Check if the data has alredy been ploted. If not plot it
        if (data.ploted.(dataName{n,m}) ~= 1)
          figure('units','normalized','outerposition',[0 0 1 1])
                  annotation('textbox', [0 0.9 1 0.1], ...
                  'String',...
                  strcat({''},dataName{n,m},{' - Time Domain'}),...
                  'EdgeColor', 'none', ...
                  'HorizontalAlignment', 'center',...
                  'FontSize',12, 'FontWeight', 'bold','interpreter','none')

            subplot(4,1,1)
                hold on
                plot(data.ing.(dataName{n,m})(:,t),...
                     data.ing.(dataName{n,m})(:,thr))
                plot(data.ing.(dataName{n,m})(:,t),...
                     data.ing.(dataName{n,m})(:,ste))
                
                 if(filteredOverlay == true) 
                    plot(data.filtered.(dataName{n,m})(:,t),...
                         data.filtered.(dataName{n,m})(:,thr))
                    plot(data.filtered.(dataName{n,m})(:,t),...
                         data.filtered.(dataName{n,m})(:,ste))
                    legend('Throttle',...
                           'Steering',...
                           'Filtered Throttle',...
                           'Filtered Steering')
                 else
                     legend('Throttle', 'Steering')
                 end
                
                title('Steering and Throttle')
                xlabel('Time (s)')
                ylabel('(-)')
                grid minor
                ylim([-1.5 1.5])
                hold off

            subplot(4,1,2)
                hold on
                plot(data.ing.(dataName{n,m})(:,t),...
                     data.ing.(dataName{n,m})(:,nFL))
                plot(data.ing.(dataName{n,m})(:,t),...
                     data.ing.(dataName{n,m})(:,nFR))
                
                if(filteredOverlay == true)
                    plot(data.filtered.(dataName{n,m})(:,t),...
                         data.filtered.(dataName{n,m})(:,nFL))
                    plot(data.filtered.(dataName{n,m})(:,t),...
                         data.filtered.(dataName{n,m})(:,nFR))
                     legend('Front left',...
                            'Front right',...
                            'Front left Filtered',...
                            'Front right Filtered')
                    
                else
                    legend('Front left','Front right')
                end
                title('Wheel Speed')
                xlabel('Time (s)')
                ylabel('(1/min)')
                grid minor
                ylim([0 3000])
                hold off

             subplot(4,1,3)
                hold on
                plot(data.ing.(dataName{n,m})(:,t),...
                     data.ing.(dataName{n,m})(:,ax))
                plot(data.ing.(dataName{n,m})(:,t),...
                     data.ing.(dataName{n,m})(:,ay))
                plot(data.ing.(dataName{n,m})(:,t),...
                     data.ing.(dataName{n,m})(:,az))
                
                if(filteredOverlay == true)
                    plot(data.filtered.(dataName{n,m})(:,t),...
                     data.filtered.(dataName{n,m})(:,ax))
                    plot(data.filtered.(dataName{n,m})(:,t),...
                     data.filtered.(dataName{n,m})(:,ay))
                    plot(data.filtered.(dataName{n,m})(:,t),...
                     data.filtered.(dataName{n,m})(:,az))
                    legend('x-Axis','y-Axis','z-Axis',...
                           'x-Axis Filtered',...
                           'y-Axis Filtered',...
                           'z-Axis Filtered')
                else
                    legend('x-Axis','y-Axis','z-Axis')
                end
                title('Acceleration')
                xlabel('Time (s)')
                ylabel('(g)')
                grid minor
                ylim([-(cal.acc.range+0.5), cal.acc.range+0.5])
                hold off

             subplot(4,1,4)
                hold on
                plot(data.ing.(dataName{n,m})(:,t),...
                     data.ing.(dataName{n,m})(:,gx))
                plot(data.ing.(dataName{n,m})(:,t),...
                     data.ing.(dataName{n,m})(:,gy))
                plot(data.ing.(dataName{n,m})(:,t),...
                     data.ing.(dataName{n,m})(:,gz))
                 
                if(filteredOverlay == true)
                    plot(data.filtered.(dataName{n,m})(:,t),...
                         data.filtered.(dataName{n,m})(:,gx))
                plot(data.filtered.(dataName{n,m})(:,t),...
                     data.filtered.(dataName{n,m})(:,gy))
                plot(data.filtered.(dataName{n,m})(:,t),...
                     data.filtered.(dataName{n,m})(:,gz))
                
                legend('x-Axis','y-Axis','z-Axis',...
                       'x-Axis Filtered',...
                       'y-Axis Filtered',...
                       'z-Axis Filtered')
                else
                    legend('x-Axis','y-Axis','z-Axis')
                end
                
                title('Gyroscope')
                xlabel('Time (s)')
                ylabel('(°/s)')
                grid minor
                ylim([-(cal.gyro.range+50), cal.gyro.range+50])
                hold off
                
                %% Set ploted flag
                data.ploted.(dataName{n,m}) = 1;
        end
    end
end

% %% Plot filtered data
% for n = 1 : nFiles
%     for m = 1 : mFiles
%         if (data.ploted.(dataName{n,m}) ~= 2)
%            figure('units','normalized','outerposition',[0 0 1 1])
%                    annotation('textbox', [0 0.9 1 0.1], ...
%                   'String',...
%                    strcat({''},dataName{n,m},{' -Check filtered Data'}),...
%                   'EdgeColor', 'none', ...
%                   'HorizontalAlignment', 'center',...
%                   'FontSize',12, 'FontWeight', 'bold','interpreter','none')
%             
%             subplot(6,1,1)
%                 hold on
%                 plot(data.filtered.(dataName{n,m})(:,1),...
%                      data.filtered.(dataName{n,m})(:,2))
%                 plot(data.ing.(dataName{n,m})(:,t),...
%                      data.ing.(dataName{n,m})(:,ax))
%                 
%                 title('Acceleration x-Axis')
%                 xlabel('Time (s)')
%                 ylabel('(g)')
%                 legend('filtered','orginal')
%                 ylim([-(cal.acc.range+0.5) cal.acc.range+0.5])
%                 hold off
%                 
%             subplot(6,1,2)
%                 hold on
%                 plot(data.filtered.(dataName{n,m})(:,1),...
%                      data.filtered.(dataName{n,m})(:,3))
%                 plot(data.ing.(dataName{n,m})(:,t),...
%                      data.ing.(dataName{n,m})(:,ay))
%                 
%                 title('Acceleration y-Axis')
%                 xlabel('Time (s)')
%                 ylabel('(g)')
%                 legend('filtered','orginal')
%                 ylim([-(cal.acc.range+0.5) cal.acc.range+0.5])
%                 hold off
%                             
%             subplot(6,1,3)
%                 hold on
%                 plot(data.filtered.(dataName{n,m})(:,1),...
%                      data.filtered.(dataName{n,m})(:,4))
%                 plot(data.ing.(dataName{n,m})(:,t),...
%                      data.ing.(dataName{n,m})(:,az))
%                 
%                 title('Acceleration z-Axis')
%                 xlabel('Time (s)')
%                 ylabel('(g)')
%                 legend('filtered','orginal')
%                 ylim([-(cal.acc.range+0.5) cal.acc.range+0.5])
%                 hold off
%             
%            subplot(6,1,4)
%                 hold on
%                 plot(data.filtered.(dataName{n,m})(:,1),...
%                      data.filtered.(dataName{n,m})(:,5))
%                 plot(data.ing.(dataName{n,m})(:,t),...
%                      data.ing.(dataName{n,m})(:,gx))
%                 
%                 title('Gyroscope x-Axis')
%                 xlabel('Time (s)')
%                 ylabel('(°/s)')
%                 legend('filtered','orginal')
%                 ylim([-(cal.gyro.range+50) cal.gyro.range+50])
%                 hold off
%             
%            subplot(6,1,5)
%                 hold on
%                 plot(data.filtered.(dataName{n,m})(:,1),...
%                      data.filtered.(dataName{n,m})(:,6))
%                 plot(data.ing.(dataName{n,m})(:,t),...
%                      data.ing.(dataName{n,m})(:,gy))
%                 
%                 title('Gyroscope y-Axis')
%                 xlabel('Time (s)')
%                 ylabel('(°/s)')
%                 legend('filtered','orginal')
%                 ylim([-(cal.gyro.range+50) cal.gyro.range+50])
%                 hold off
%                  
%           subplot(6,1,6)
%                 hold on
%                 plot(data.filtered.(dataName{n,m})(:,1),...
%                      data.filtered.(dataName{n,m})(:,7))
%                 plot(data.ing.(dataName{n,m})(:,t),...
%                      data.ing.(dataName{n,m})(:,gz))
%                 
%                 title('Gyroscope z-Axis')
%                 xlabel('Time (s)')
%                 ylabel('(°/s)')
%                 legend('filtered','orginal')
%                 ylim([-(cal.gyro.range+50) cal.gyro.range+50])
%                 hold off
%                 
%             data.ploted.(dataName{n,m}) = 2;
%         end
%     end
% end

%% Plot g-force data scatter 
for n = 1 : nFiles
    figure('units','normalized','outerposition',[0 0 1 1])
            annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            'g-Force scatter plot',...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
    hold on
        for m = 1 : mFiles
            scatter(data.ing.(dataName{n,m})(:,ay),...
                    data.ing.(dataName{n,m})(:,ax),20,...
                    data.ing.(dataName{n,m})(:,az),markerType{m});
        end
        xlabel('y-Axis (g)')
        ylabel('x-Axis (g)')
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
        legend(dataName(n,:),'interpreter','none')
        
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
           ylabel('(g)')
           ylim([-2 2])
           grid minor
           
           yyaxis right
           plot(data.ing.(dataName{n})(:,t),data.ing.(dataName{n})(:,thr));
           ylabel('-')
           xlabel('Time (s)')
           ylim([-1.5 1.5])
           legend('x-Axis Acceleration','Throttle')
           hold off
           
        subplot(3,1,2)
           hold on
           title('y-Axis acceleration and steering')
           yyaxis left
           plot(data.ing.(dataName{n})(:,t),data.ing.(dataName{n})(:,ay));
           ylabel('(g)')
           ylim([-2 2])
           grid minor
           
           yyaxis right
           plot(data.ing.(dataName{n})(:,t),data.ing.(dataName{n})(:,ste));
           ylabel('(-)')
           xlabel('Time (s)')
           ylim([-1.5 1.5])
           legend('y-Axis Acceleration','Steering')
           hold off
           
        subplot(3,1,3)
           hold on
           title('z-Axis acceleration and throttle')
           yyaxis left
           plot(data.ing.(dataName{n})(:,t),data.ing.(dataName{n})(:,az));
           ylabel('(g)')
           ylim([-2 2])
           grid minor
           
           yyaxis right
           plot(data.ing.(dataName{n})(:,t),data.ing.(dataName{n})(:,thr));
           ylabel('(-)')
           xlabel('Time (s)')
           ylim([-1.5 1.5])
           legend('z-Axis Acceleration','Throttle')
           hold off
end

%% Plot each acceleration axis data vs RC-Controll values
for n = 1 : nFiles
    figure('units','normalized','outerposition',[0 0 1 1])
            annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            'Acceleration data vs RC-Controll Data',...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
    
    subplot(2,3,1)
        hold on
        for m = 1 : mFiles
            plot(data.ing.(dataName{n,m})(:,thr),...
                 data.ing.(dataName{n,m})(:,ax),markerType{m});
        end
        axis([-1.5 1.5 -(cal.acc.range+0.5) cal.acc.range+0.5])
        xlabel('Throttle (-)')
        ylabel('x-Axis (g)')
        title('Throttle vs Acceleration x-Axis')
        grid minor
        hold off
    
    subplot(2,3,2)
        hold on
        for m = 1 : mFiles
            plot(data.ing.(dataName{n,m})(:,thr),...
                 data.ing.(dataName{n,m})(:,ay),markerType{m});
        end
        axis([-1.5 1.5 -(cal.acc.range+0.5) cal.acc.range+0.5])
        xlabel('Throttle (-)')
        ylabel('y-Axis (g)')
        title('Throttle vs Acceleration y-Axis')
        grid minor
        
         hold off
        
    subplot(2,3,3)
        hold on
        for m = 1 : mFiles
            plot(data.ing.(dataName{n,m})(:,thr),...
                 data.ing.(dataName{n,m})(:,az),markerType{m});
        end
        axis([-1.5 1.5 -(cal.acc.range+0.5) cal.acc.range+0.5])
        xlabel('Throttle (-)')
        ylabel('z-Axis (g)')
        title('Throttle vs Acceleration z-Axis')
        grid minor
        hold off
        
    subplot(2,3,4)
        hold on
        for m = 1 : mFiles
            plot(data.ing.(dataName{n,m})(:,ste),...
                 data.ing.(dataName{n,m})(:,ax),markerType{m});
        end
        axis([-1.5 1.5 -(cal.acc.range+0.5) cal.acc.range+0.5])
        xlabel('Steering (-)')
        ylabel('x-Axis (g)')
        title('Steering vs Acceleration x-Axis')
        grid minor
        hold off
        
    subplot(2,3,5)
        hold on
        for m = 1 : mFiles
            plot(data.ing.(dataName{n,m})(:,ste),...
                 data.ing.(dataName{n,m})(:,ay),markerType{m});
        end
        
        axis([-1.5 1.5 -(cal.acc.range+0.5) cal.acc.range+0.5])
        xlabel('Steering (-)')
        ylabel('y-Axis (g)')
        grid minor
        title('Steering vs Acceleration y-Axis')
        hold off
        
    subplot(2,3,6)
        hold on
        for m = 1 : mFiles
            plot(data.ing.(dataName{n,m})(:,ste),...
                 data.ing.(dataName{n,m})(:,az),markerType{m});
        end
         axis([-1.5 1.5 -(cal.acc.range+0.5) cal.acc.range+0.5])
        xlabel('Steering (-)')
        ylabel('z-Axis (g)')
        grid minor
        title('Steering vs Acceleration z-Axis')
        hold off
    
end

%% Plot histogramm for acceleration data
for n = 1 : nFiles
     figure('units','normalized','outerposition',[0 0 1 1])
            annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            ' Acceleration Histograms',...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none');
        
     subplot(3,1,1)
        hold on
        for m = 1 : mFiles
            h1 = histogram(data.ing.(dataName{n,m})(:,ax));
            h1.Normalization = 'probability';
            h1.BinWidth = 0.1;
        end
        xlim([-2 2])
        ylabel('Normalized Occurencies (-)')
        xlabel('Acceleration x-Axis (g)')
        legend(dataName(n,:),'interpreter','none')
        hold off
     
     subplot(3,1,2)
        hold on
        for m = 1 : mFiles
            h1 = histogram(data.ing.(dataName{n,m})(:,ay));
            h1.Normalization = 'probability';
            h1.BinWidth = 0.1;
        end      
        xlim([-2 2])
        ylabel('Normalized Occurencies (-)')
        xlabel('Acceleration y-Axis (g)')
        legend(dataName(n,:),'interpreter','none')
        hold off

     subplot(3,1,3)
        hold on
        for m = 1 : mFiles
            h1 = histogram(data.ing.(dataName{n,m})(:,az));
            h1.Normalization = 'probability';
            h1.BinWidth = 0.1;
        end      
        xlim([-2 2])
        ylabel('Normalized Occurencies (-)')
        xlabel('Acceleration z-Axis (g)')
        legend(dataName(n,:),'interpreter','none')
        hold off
end

%% Plot power spectral density
for n = 1 : nFiles
    figure('units','normalized','outerposition',[0 0 1 1])
            annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            ' Welch Power Spectral Density Estimation',...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
     
     subplot(2,3,1)
        hold on
        for m = 1 : mFiles
            plot(data.psd.(dataName{n,m})(:,1),...
                 db(data.psd.(dataName{n,m})(:,2)));
        end
        title('Acceleration x-Axis')
        xlabel('Frequency (Hz)')
        ylabel('Power/Frequency (db/Hz)')
        legend(dataName(n,:),'interpreter','none')
        hold off
        
     subplot(2,3,2)
        hold on
        for m = 1 : mFiles
            plot(data.psd.(dataName{n,m})(:,1),...
                 db(data.psd.(dataName{n,m})(:,3)));
        end
        title('Acceleration y-Axis')
        xlabel('Frequency (Hz)')
        ylabel('Power/Frequency (db/Hz)')
        legend(dataName(n,:),'interpreter','none')
        hold off
        
     subplot(2,3,3)
        hold on
        for m = 1 : mFiles
            plot(data.psd.(dataName{n,m})(:,1),...
                 db(data.psd.(dataName{n,m})(:,4)));
        end
        title('Acceleration z-Axis')
        xlabel('Frequency (Hz)')
        ylabel('Power/Frequency (db/Hz)')
        legend(dataName(n,:),'interpreter','none')
        hold off
        
    subplot(2,3,4)
        hold on
        for m = 1 : mFiles
            plot(data.psd.(dataName{n,m})(:,1),...
                 db(data.psd.(dataName{n,m})(:,5)));
        end
        title('Gyroscope x-Axis')
        xlabel('Frequency (Hz)')
        ylabel('Power/Frequency (db/Hz)')
        legend(dataName(n,:),'interpreter','none')
        hold off
        
    subplot(2,3,5)
        hold on
        for m = 1 : mFiles
            plot(data.psd.(dataName{n,m})(:,1),...
                 db(data.psd.(dataName{n,m})(:,6)));
        end
        title('Gyroscope y-Axis')
        xlabel('Frequency (Hz)')
        ylabel('Power/Frequency (db/Hz)')
        legend(dataName(n,:),'interpreter','none')
        hold off
        
    subplot(2,3,6)
        hold on
        for m = 1 : mFiles
            plot(data.psd.(dataName{n,m})(:,1),...
                 db(data.psd.(dataName{n,m})(:,7)));
        end
        title('Gyroscope z-Axis')
        xlabel('Frequency (Hz)')
        ylabel('Power/Frequency (db/Hz)')
        legend(dataName(n,:),'interpreter','none')
        hold off
end

%% Plot PCA Analysis
figure('units','normalized','outerposition',[0 0 1 1])
            annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            ' Welch Power Spectral Density Estimation',...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
        


hold on
scatter(data.pca.scores(data.pca.label==0,1),...
        data.pca.scores(data.pca.label==0,2),'b')
scatter(data.pca.scores(data.pca.label==1,1),...
        data.pca.scores(data.pca.label==1,2),'r')
    grid minor
hold off

xlabel(["PCA1 (",...
        num2str(round(data.pca.pcvars(1)/sum(data.pca.pcvars)*100)),'%)'])
ylabel(["PCA2 (",...
        num2str(round(data.pca.pcvars(2)/sum(data.pca.pcvars)*100)),'%)'])
title('PCA Analysis reduced to 2D')

    
figure('units','normalized','outerposition',[0 0 1 1])
            annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            ' Welch Power Spectral Density Estimation',...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')

hold on
scatter3(data.pca.scores(data.pca.label==0,1),...
         data.pca.scores(data.pca.label==0,2),...
         data.pca.scores(data.pca.label==0,3),'b')
     
scatter3(data.pca.scores(data.pca.label==1,1),...
         data.pca.scores(data.pca.label==1,2),...
         data.pca.scores(data.pca.label==1,3),'r')
     grid minor
     
hold off

xlabel(["PCA1 (",...
        num2str(round(data.pca.pcvars(1)/sum(data.pca.pcvars)*100)),'%)'])
ylabel(["PCA2 (",...
        num2str(round(data.pca.pcvars(2)/sum(data.pca.pcvars)*100)),'%)'])
zlabel(["PCA3 (",...
        num2str(round(data.pca.pcvars(3)/sum(data.pca.pcvars)*100)),'%)'])
title('PCA Analysis reduced to 3D (PCA1/PCA2/PCA3)')


figure('units','normalized','outerposition',[0 0 1 1])
            annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            ' Welch Power Spectral Density Estimation',...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
        


hold on
scatter(data.pca.scores(data.pca.label==0,2),...
        data.pca.scores(data.pca.label==0,3),'b')
scatter(data.pca.scores(data.pca.label==1,2),...
        data.pca.scores(data.pca.label==1,3),'r')
    grid minor
hold off

xlabel(["PCA2 (",...
        num2str(round(data.pca.pcvars(2)/sum(data.pca.pcvars)*100)),'%)'])
ylabel(["PCA3 (",...
        num2str(round(data.pca.pcvars(3)/sum(data.pca.pcvars)*100)),'%)'])
title('PCA Analysis reduced to 2D (PCA2/PCA3)')


figure('units','normalized','outerposition',[0 0 1 1])
            annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            ' Welch Power Spectral Density Estimation',...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
        


hold on
scatter(data.pca.scores(data.pca.label==0,4),...
        data.pca.scores(data.pca.label==0,5),'b')
scatter(data.pca.scores(data.pca.label==1,4),...
        data.pca.scores(data.pca.label==1,5),'r')
    grid minor
hold off

xlabel(["PCA4 (",...
        num2str(round(data.pca.pcvars(2)/sum(data.pca.pcvars)*100)),'%)'])
ylabel(["PCA5 (",...
        num2str(round(data.pca.pcvars(3)/sum(data.pca.pcvars)*100)),'%)'])
title('PCA Analysis reduced to 2D (PCA4/PCA5)')