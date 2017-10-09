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

dataName = {'Test9_0g_H_Statisch_1';
            'Test10_900g_H_Statisch_1';
            'Test11_0g_900g_Statisch_1'};
        
nFiles = size(dataName,1);  % How many plots
mFiles = size(dataName,2);  % How many coparisson data in one plot
nColumns = 11;              % The number of columns in the data file + 1
flagMatrix = false(nFiles,mFiles); % Specifies wich data set is to ignore 
                                   % not to plot or process same data sets 
                                   % multipel times
                                   
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
                                        data.ing.(dataName{n,m})(:,8);
            data.pitch.std.(dataName{n,m}) =...
                                           std(data.pitch.(dataName{n,m}));
            data.pitch.mean.(dataName{n,m}) =...
                                          mean(data.pitch.(dataName{n,m}));
%             if (firstEnteryFlag == true)
%                 data.pitch.name = {dataName{n,m} [data]}; 
%             else
%                 data.pitch.name = {data.pitch.name;dataName{n,m}};
%             end
        end
    end
end


%% Plot 
figure()
hold on

errorbar()

figure()