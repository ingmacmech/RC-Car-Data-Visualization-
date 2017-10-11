%% Visualize static data

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

dataName = {'Test12_0g_Statisch_1';
            'Test13_200g_Statisch_1';
            'Test14_400g_Statisch_1';
            'Test15_600g_Statisch_1';
            'Test16_900g_Statisch_1'};

dataInfo = {'';
            'Loaded';
            'Loaded 200g';
            'Loaded 400g';
            'Loaded 600g';
            'Loaded 900g'};
        
targetPitchAngle = [0 0.8 1.7 2.5 3.4];

nFiles = size(dataName,1);  % How many plots
mFiles = size(dataName,2);  % How many coparisson data in one plot
nColumns = 11;              % The number of columns in the data file + 1
flagMatrix = false(nFiles,mFiles); % Specifies wich data set is to ignore 
                                   % not to plot or process same data sets 
                                   % multipel times
%% Set data set with wich the offset is corrected
nOffset = 1;
mOffset = 1;
%% Columns
column.t=1;        % Column 1 time vector
column.thr=2;      % Column 2 throttle vector
column.ste=3;      % Column 3 steering vector
column.nFL=4;      % Column 4 wheel speed front left
column.nFR=5;      % Column 5 wheel speed front right
column.ax=6;       % Column 6 acceleration x-Axis
column.ay=7;       % Column 7 acceleration y-Axis
column.az=8;       % Column 8 acceleration z-Axis
column.gx=9;       % Column 9 gyroscope x-Axis
column.gy=10;      % Column 10 gyroscope y-Axis
column.gz=11;      % Column 11 gyroscope z-Axis


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
                                      data.raw.(dataName{n,m})(:,column.t);
                    case 2
                        % Convert throttle data
                        temp = polyval(cal.throttle.polyVal,...
                                   data.raw.(dataName{n,m})(:,column.thr));
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case 3
                        % Convert steering data
                        temp = polyval(cal.steering.polyVal,...
                                   data.raw.(dataName{n,m})(:,column.ste));
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case 4
                   % Convert wheel speed front left data from int to 1/min
                        temp = (cal.wheel.n ./...
                                data.raw.(dataName{n,m})(:,column.nFL));
                        % replace inf with zero
                        temp(~isfinite(temp))=0;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case 5
                   % Convert wheel speed front right data from int to 1/min     
                        temp = (cal.wheel.n ./...
                                data.raw.(dataName{n,m})(:,column.nFR));
                        % replace inf with zero
                        temp(~isfinite(temp))=0;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        
                        clear temp;
                    case 6
                        % Convert acceleration data x-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,column.ax)*...
                                                              cal.acc.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case 7
                        % Convert acceleration data y-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,column.ay)*....
                                                              cal.acc.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case 8
                        % Convert acceleration data z-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,column.az)*...
                                                              cal.acc.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case 9
                        % Convert gyroscope data x-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,column.gx) *...
                                                             cal.gyro.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case 10
                        % Convert gyroscope data y-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,column.gy) *...
                                                             cal.gyro.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case 11
                        % Convert gyroscope data z-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,column.gz) *...
                                                             cal.gyro.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                end 
            end
        end
    end
end

%% Calculating pitch angle with data
data.pitch = struct;
data.pitch.std = struct;
data.pitch.mean = struct;
firstEnteryFlag = true;
for n = 1 : nFiles
    for m = 1 : mFiles
        if (flagMatrix(n,m) == true)
            data.pitch.(dataName{n,m}) =...
                                   atan(data.ing.(dataName{n,m})(:,6))./...
                                        data.ing.(dataName{n,m})(:,8)*180/pi;
            data.pitch.std.(dataName{n,m}) =...
                                           std(data.pitch.(dataName{n,m}));
            data.pitch.mean.(dataName{n,m}) =...
                                          mean(data.pitch.(dataName{n,m}));
        end
    end
end


%% Plot Time Data
for n = 1 : nFiles
    
    figure('units','normalized','outerposition',[0 0 1 1])
    
    annotation('textbox', [0 0.9 1 0.1], ...
               'String',...
               strcat({''},dataName{n,m},{' - Static tests'}),...
               'EdgeColor', 'none', ...
               'HorizontalAlignment', 'center',...
               'FontSize',12, 'FontWeight', 'bold','interpreter','none')
    
    subplot(3,1,1)
    hold on
    for m = 1 : mFiles
        plot(data.ing.(dataName{n,m})(:,column.t),...
             data.ing.(dataName{n,m})(:,column.ax))
    end
    hold off
    title('Acceleration x-Axis')
    ylabel('(g)')
    xlabel('Time (s)')
    grid minor
    
    subplot(3,1,2)
    hold on
    for m = 1 : mFiles
        plot(data.ing.(dataName{n,m})(:,column.t),...
             data.ing.(dataName{n,m})(:,column.az))
    end
    hold off
    title('Acceleration z-Axis')
    ylabel('(g)')
    xlabel('Time (s)')
    grid minor
    
    subplot(3,1,3)
    hold on
    for m = 1 : mFiles
        plot(data.ing.(dataName{n,m})(:,column.t),...
             data.ing.(dataName{n,m})(:,column.gy))
    end
    hold off
    title('Gyroscope y-Axis')
    ylabel('(g)')
    xlabel('Time (s)')
    grid minor
    
end

%% Plot estimation of pitch angle without correction
figure('units','normalized','outerposition',[0 0 1 1])
    
    annotation('textbox', [0 0.9 1 0.1], ...
               'String',...
               'Estimation for pitch angle without correction',...
               'EdgeColor', 'none', ...
               'HorizontalAlignment', 'center',...
               'FontSize',12, 'FontWeight', 'bold','interpreter','none')
hold on
for n = 1 : nFiles
    errorbar(n,data.pitch.mean.(dataName{n,m}),...
               data.pitch.std.(dataName{n,m}),'ob')
    plot(n,targetPitchAngle(n),'+r')
end
hold off

xticks([0:nFiles+1])
set(gca,'XtickLabel',dataInfo)
xlim([0 nFiles+1])
grid minor

%% Plot estimation of pitch angle with offset correction
figure('units','normalized','outerposition',[0 0 1 1])
    
    annotation('textbox', [0 0.9 1 0.1], ...
               'String',...
               'Estimation for pitch angle without correction',...
               'EdgeColor', 'none', ...
               'HorizontalAlignment', 'center',...
               'FontSize',12, 'FontWeight', 'bold','interpreter','none')
hold on
for n = 1 : nFiles
    errorbar(n,data.pitch.mean.(dataName{n,m})-...
               data.pitch.mean.(dataName{nOffset,mOffset}),...
               data.pitch.std.(dataName{n,m}),'ob')
    plot(n,targetPitchAngle(n),'+r','MarkerSize',20)
end
hold off

xticks([0:nFiles+1])
set(gca,'XtickLabel',dataInfo)
xlim([0 nFiles+1])
grid minor