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
%Data with motor control fan on
% dataName = {'Cal3_Pitch_Angle_0g';
%             'Cal3_Pitch_Angle_200g';
%             'Cal3_Pitch_Angle_400g';
%             'Cal3_Pitch_Angle_600g';
%             'Cal3_Pitch_Angle_800g';
%             'Cal3_Pitch_Angle_1000g'};

% Data with motor control fan off
dataName = {'Cal4_Pitch_Angle_0g';
            'Cal4_Pitch_Angle_200g';
            'Cal4_Pitch_Angle_400g';
            'Cal4_Pitch_Angle_600g';
            'Cal4_Pitch_Angle_800g';
            'Cal4_Pitch_Angle_1000g'};

dataInfo = {'';
            '0g';
            '200g';
            '400g';
            '600g';
            '800g';
            '1000g'};
        
targetPitchAngle = [0 0.62 1.49 2.36 2.86 3.48];
loadValue = [0 200 400 600 800 1000];
stdTargetPitchAngle = 0.249; % Max error from reading

cut = 50; % Number of data points to cut from start and stop
          % to avoid data when pressing start and stop logging

nFiles = size(dataName,1);  % How many plots
mFiles = size(dataName,2);  % How many coparisson data in one plot
nColumns = 15;              % The number of columns in the data file + 1
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
column.dHL=12;     % Column 12 Axle height front right
column.dHR=13;     % Column 13 Axle height front left
column.dFR=14;     % Column 14 Axle height back right
column.dFL=15;     % Column 15 Axle height front left


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
                    case column.t
                        % Copy time vektor
                        data.ing.(dataName{n,m}) =...
                                      data.raw.(dataName{n,m})(:,column.t);
                    case column.thr
                        % Convert throttle data
                        temp = polyval(cal.throttle.polyVal,...
                                   data.raw.(dataName{n,m})(:,column.thr));
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case column.ste
                        % Convert steering data
                        temp = polyval(cal.steering.polyVal,...
                                   data.raw.(dataName{n,m})(:,column.ste));
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case column.nFL
                   % Convert wheel speed front left data from int to 1/min
                        temp = (cal.wheel.n ./...
                                data.raw.(dataName{n,m})(:,column.nFL));
                        % replace inf with zero
                        temp(~isfinite(temp))=0;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case column.nFR
                   % Convert wheel speed front right data from int to 1/min     
                        temp = (cal.wheel.n ./...
                                data.raw.(dataName{n,m})(:,column.nFR));
                        % replace inf with zero
                        temp(~isfinite(temp))=0;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        
                        clear temp;
                    case column.ax
                        % Convert acceleration data x-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,column.ax)*...
                                                              cal.acc.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case column.ay
                        % Convert acceleration data y-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,column.ay)*....
                                                              cal.acc.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case column.az
                        % Convert acceleration data z-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,column.az)*...
                                                              cal.acc.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case column.gx
                        % Convert gyroscope data x-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,column.gx) *...
                                                             cal.gyro.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case column.gy
                        % Convert gyroscope data y-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,column.gy) *...
                                                             cal.gyro.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case column.gz
                        % Convert gyroscope data z-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,column.gz) *...
                                                             cal.gyro.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                   case column.dFL
                        temp = polyval(cal.potiFL.polyVal,...
                                data.raw.(dataName{n,m})(:,column.dFL))-...
                                cal.offsetPotiFL; 
                        
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                        
                    case column.dFR
                        temp = polyval(cal.potiFR.polyVal,...
                                data.raw.(dataName{n,m})(:,column.dFR))-...
                                cal.offsetPotiFR;
                        
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                        
                    case column.dHL
                        temp = polyval(cal.potiHL.polyVal,...
                                data.raw.(dataName{n,m})(:,column.dHL))-...
                                cal.offsetPotiHL;
                        
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                        
                    case column.dHR
                        temp = polyval(cal.potiHR.polyVal,...
                                data.raw.(dataName{n,m})(:,column.dHR))-...
                                cal.offsetPotiHR;
                        
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                end 
            end
        end
    end
end

%% Calculating pitch angle with data
data.accPitch = struct;
data.accPitch.std = struct;
data.accPitch.mean = struct;
data.potiPitch.LR = struct;
data.potiPitch.LR.std = struct;
data.potiPitch.LR.mean = struct;
data.potiPitch.RL = struct;
data.potiPitch.RL.std = struct;
data.potiPitch.RL.mean = struct;
firstEnteryFlag = true;
for n = 1 : nFiles
    for m = 1 : mFiles
        if (flagMatrix(n,m) == true)
            data.accPitch.(dataName{n,m}) =...
                                   atan(data.ing.(dataName{n,m})(:,column.ax))./...
                                        data.ing.(dataName{n,m})(:,column.az)*180/pi;
            
            data.accPitch.std.(dataName{n,m}) =...
                                           std(data.accPitch.(dataName{n,m})(cut:end-cut,:));
            data.accPitch.mean.(dataName{n,m}) =...
                                          mean(data.accPitch.(dataName{n,m})(cut:end-cut,:));
            
            data.potiPitch.LR.(dataName{n,m}) =...
                    atan((data.ing.(dataName{n,m})(:,column.dHR) - ...
                          data.ing.(dataName{n,m})(:,column.dFL))/(cal.lvh*1000))*...
                          180/pi;

            data.potiPitch.RL.(dataName{n,m}) =...
                    atan((data.ing.(dataName{n,m})(:,column.dHL) - ...
                          data.ing.(dataName{n,m})(:,column.dFR))/(cal.lvh*1000))*...
                          180/pi;
                      
            data.potiPitch.LR.std.(dataName{n,m}) =...
                                std(data.potiPitch.LR.(dataName{n,m})(cut:end-cut,:));
                       
            data.potiPitch.LR.mean.(dataName{n,m}) = ...
                                mean(data.potiPitch.LR.(dataName{n,m})(cut:end-cut,:));
                            
            data.potiPitch.RL.std.(dataName{n,m}) =...
                                std(data.potiPitch.RL.(dataName{n,m})(cut:end-cut,:));
                       
            data.potiPitch.RL.mean.(dataName{n,m}) = ...
                                mean(data.potiPitch.RL.(dataName{n,m})(cut:end-cut,:));
        end
    end
    
end

%% Fit a linear model for angle and loading

linearModel = fitlm(loadValue,targetPitchAngle,'linear','Intercept',false);

%% Plot Time Data acceleration and gyro
for n = 1 : nFiles
    figure('units','normalized','outerposition',[0 0 1 1])

    annotation('textbox', [0 0.9 1 0.1], ...
               'String',...
               strcat({''},dataName{n,m},{' - Acceleration and Gyroscope Data'}),...
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

%% Plot Time data for poti values
for n = 1 : nFiles
    figure('units','normalized','outerposition',[0 0 1 1])

    annotation('textbox', [0 0.9 1 0.1], ...
               'String',...
               strcat({''},dataName{n,m},{' - Potentiometer Data'}),...
               'EdgeColor', 'none', ...
               'HorizontalAlignment', 'center',...
               'FontSize',12, 'FontWeight', 'bold','interpreter','none')

    subplot(4,1,1)
    hold on
    for m = 1 : mFiles
        plot(data.ing.(dataName{n,m})(:,column.t),...
             data.ing.(dataName{n,m})(:,column.dFL))
    end
    hold off
    title('')
    ylabel('')
    xlabel('Time (s)')
    grid minor

    subplot(4,1,2)
    hold on
    for m = 1 : mFiles
        plot(data.ing.(dataName{n,m})(:,column.t),...
             data.ing.(dataName{n,m})(:,column.dFR))
    end
    hold off
    title('')
    ylabel('')
    xlabel('Time (s)')
    grid minor

    subplot(4,1,3)
    hold on
    for m = 1 : mFiles
        plot(data.ing.(dataName{n,m})(:,column.t),...
             data.ing.(dataName{n,m})(:,column.dHL))
    end
    hold off
    title('')
    ylabel('')
    xlabel('Time (s)')
    grid minor
    
    subplot(4,1,4)
    hold on
    for m = 1 : mFiles
        plot(data.ing.(dataName{n,m})(:,column.t),...
             data.ing.(dataName{n,m})(:,column.dHR))
    end
    hold off
    title('')
    ylabel('')
    xlabel('Time (s)')
    grid minor
end

%% Plot linear Modell
figure('units','normalized','outerposition',[0 0 1 1])

annotation('textbox', [0 0.9 1 0.1], ...
               'String',...
               'Linear Model for load and angle',...
               'EdgeColor', 'none', ...
               'HorizontalAlignment', 'center',...
               'FontSize',12, 'FontWeight', 'bold','interpreter','none')

hold on
plot(loadValue,targetPitchAngle,'-*b')
plot(loadValue,linearModel.Fitted,'--r')
%plot(loadValue, 0.003592727272727*loadValue,'-g')
hold off
grid on
grid minor
xlabel('Beladungszustand (g)')
ylabel('Nickwinkel (°)')
legend('Gemessen','Lineares Model')

%% Plot estimation of pitch angle without acceleration offset correction
figure('units','normalized','outerposition',[0 0 1 1])
    
    annotation('textbox', [0 0.9 1 0.1], ...
               'String',...
               'Estimation for pitch angle without correction',...
               'EdgeColor', 'none', ...
               'HorizontalAlignment', 'center',...
               'FontSize',12, 'FontWeight', 'bold','interpreter','none')
hold on
for n = 1 : nFiles
    for m = 1 : mFiles
        if(n == 1)
             errorbar(n,data.accPitch.mean.(dataName{n,m}),...
                   data.accPitch.std.(dataName{n,m}),...
                   'ob',...
                   'HandleVisibility','on')
             errorbar(n,data.potiPitch.LR.mean.(dataName{n,m}),...
                      data.potiPitch.LR.std.(dataName{n,m}),...
                      'og',...
                      'HandleVisibility','on')
             errorbar(n,data.potiPitch.RL.mean.(dataName{n,m}),...
                      data.potiPitch.RL.std.(dataName{n,m}),...
                      'ok',...
                      'HandleVisibility','on')
             errorbar(n,targetPitchAngle(n),stdTargetPitchAngle,...
                  '*r',...
                  'HandleVisibility','on')
        else
            errorbar(n,data.accPitch.mean.(dataName{n,m}),...
                       data.accPitch.std.(dataName{n,m}),...
                       'ob',...
                       'HandleVisibility','off')
            errorbar(n,data.potiPitch.LR.mean.(dataName{n,m}),...
                      data.potiPitch.LR.std.(dataName{n,m}),...
                      'og',...
                      'HandleVisibility','off')
            errorbar(n,data.potiPitch.RL.mean.(dataName{n,m}),...
                      data.potiPitch.RL.std.(dataName{n,m}),...
                      'ok',...
                      'HandleVisibility','off')
             errorbar(n,targetPitchAngle(n),stdTargetPitchAngle,...
                   '*r',...
                   'HandleVisibility','off')
        end
    end
end
hold off

xticks(0:nFiles+1)
set(gca,'XtickLabel',dataInfo)
xlim([0 nFiles+1])
grid minor
xlabel('Load Condition')
ylabel('Pitch angle (°)')
legend('Aceleration Data','Potentiometer Data LR','Potentiometer Data RL','Target Value')

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
    if n == 1
       errorbar(n,data.accPitch.mean.(dataName{n,m})-...
               data.accPitch.mean.(dataName{nOffset,mOffset}),...
               data.accPitch.std.(dataName{n,m}),...
               'ob',...
               'HandleVisibility','on')
       errorbar(n,data.potiPitch.LR.mean.(dataName{n,m}),...
                  data.potiPitch.LR.std.(dataName{n,m}),...
                  'og',...
                  'HandleVisibility','on')
       errorbar(n,data.potiPitch.RL.mean.(dataName{n,m}),...
                  data.potiPitch.RL.std.(dataName{n,m}),...
                  'ok',...
                  'HandleVisibility','on')
              
       errorbar(n,targetPitchAngle(n),stdTargetPitchAngle,...
                '*r',...
                'HandleVisibility','on')
    else
        errorbar(n,data.accPitch.mean.(dataName{n,m})-...
                   data.accPitch.mean.(dataName{nOffset,mOffset}),...
                   data.accPitch.std.(dataName{n,m}),...
                   'ob',...
                   'HandleVisibility','off')
        errorbar(n,data.potiPitch.LR.mean.(dataName{n,m}),...
                  data.potiPitch.LR.std.(dataName{n,m}),...
                  'og',...
                  'HandleVisibility','off')
              
        errorbar(n,data.potiPitch.RL.mean.(dataName{n,m}),...
                  data.potiPitch.RL.std.(dataName{n,m}),...
                  'ok',...
                  'HandleVisibility','off')
              
         errorbar(n,targetPitchAngle(n),stdTargetPitchAngle,...
               '*r',...
               'HandleVisibility','off')
    end
end
hold off

xticks([0:nFiles+1])
set(gca,'XtickLabel',dataInfo)
xlim([0 nFiles+1])
grid minor
xlabel('Load Condition')
ylabel('Pitch angle (°)')
legend('Aceleration Data','Potentiometer Data LR','Potentiometer Data RL','Target Value')