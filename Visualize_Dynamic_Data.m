%% TODO:
% -- Replace all isfield ifs with flagMatrix (better solution)

%% Clear all resources
clear;
clc;
close all;

%% Save Controlls
savePCA = false;
namePCA = 'nn_data.mat';

saveNN = true;
nameNN = 'nn_Test_1.mat';

nColumns = 15;              % The number of columns in the data file + 1

%% Plot Controlls
orginalOverlay = false;

plotTimeData        = true;
plotPotiData        = false;
plotPitchAngle      = true;
plotSpeedData       = true;
plotGforceScatter   = false;
plotControllAccData = false;
plotAccVsControl    = false;
plotHist            = false;
plotPSD             = false;


%% Add path to sub folders
currentPath = pwd;
addpath(genpath(currentPath));
clear currentPath;

%% Load cal struct 
% to create cal struct run Calibration.m first
load('cal');

%% List of data to open and data ending
dataType = {'.txt'};

% dataSet_1: Includes only data with slope = 0 and weight 0g and 900g
load('dataSet_Test.mat');

nFiles = size(dataName,1);  % How many plots
mFiles = size(dataName,2);  % How many coparisson data in one plot
flagMatrix = false(nFiles,mFiles); % Specifies wich data set is to ignore 
                                   % not to plot or process same data sets 
                                   % multipel times
                                   
angleOffset = 1.6; % Offset correktion for pitch angle see Visualize_Static_Data.m

%% Columns
c.t=1;        % Column 1 time vector
c.thr=2;      % Column 2 throttle vector
c.ste=3;      % Column 3 steering vector
c.nFL=4;      % Column 4 wheel speed front left
c.nFR=5;      % Column 5 wheel speed front right
c.ax=6;       % Column 6 acceleration x-Axis
c.ay=7;       % Column 7 acceleration y-Axis
c.az=8;       % Column 8 acceleration z-Axis
c.gx=9;       % Column 9 gyroscope x-Axis
c.gy=10;      % Column 10 gyroscope y-Axis
c.gz=11;      % Column 11 gyroscope z-Axis
c.dHL=12;     % Column 12 Axle height front right
c.dHR=13;     % Column 13 Axle height front left
c.dFR=14;     % Column 14 Axle height back right
c.dFL=15;     % Column 15 Axle height front left


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
                    case c.t
                        % Copy time vektor
                        data.ing.(dataName{n,m}) =...
                                            data.raw.(dataName{n,m})(:,c.t);
                    case c.thr
                        % Convert throttle data
                        temp = polyval(cal.throttle.polyVal,...
                                       data.raw.(dataName{n,m})(:,c.thr));
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case c.ste
                        % Convert steering data
                        temp = polyval(cal.steering.polyVal,...
                                       data.raw.(dataName{n,m})(:,c.ste));
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case c.nFL
                   % Convert wheel speed front left data from int to 1/min
                        temp = (cal.wheel.n ./...
                                data.raw.(dataName{n,m})(:,c.nFL));
                        % replace inf with zero
                        temp(~isfinite(temp))=0;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case c.nFR
                   % Convert wheel speed front right data from int to 1/min     
                        temp = (cal.wheel.n ./...
                                data.raw.(dataName{n,m})(:,c.nFR));
                        % replace inf with zero
                        temp(~isfinite(temp))=0;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        
                        clear temp;
                    case c.ax
                        % Convert acceleration data x-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,c.ax)*cal.acc.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case c.ay
                        % Convert acceleration data y-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,c.ay)*cal.acc.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case c.az
                        % Convert acceleration data z-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,c.az)*cal.acc.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case c.gx
                        % Convert gyroscope data x-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,c.gx) *...
                                                             cal.gyro.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case c.gy
                        % Convert gyroscope data y-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,c.gy) *...
                                                             cal.gyro.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case c.gz
                        % Convert gyroscope data z-axis from int to g
                        temp = data.raw.(dataName{n,m})(:,c.gz) *...
                                                             cal.gyro.mult;
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                    case c.dFL
                        temp = polyval(cal.potiFL.polyVal,...
                                data.raw.(dataName{n,m})(:,c.dFL))-...
                                cal.offsetPotiFL; 
                        
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                        
                    case c.dFR
                        temp = polyval(cal.potiFR.polyVal,...
                                data.raw.(dataName{n,m})(:,c.dFR))-...
                                cal.offsetPotiFR;
                        
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                        
                    case c.dHL
                        temp = polyval(cal.potiHL.polyVal,...
                                data.raw.(dataName{n,m})(:,c.dHL))-...
                                cal.offsetPotiHL;
                        
                        data.ing.(dataName{n,m}) =...
                                          [data.ing.(dataName{n,m}), temp];
                        clear temp;
                        
                    case c.dHR
                        temp = polyval(cal.potiHR.polyVal,...
                                data.raw.(dataName{n,m})(:,c.dHR))-...
                                cal.offsetPotiHR;
                        
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
                   case c.t
                       % Coppy time vector
                       data.filtered.(dataName{n,m}) = ...
                            data.ing.(dataName{n,m})(:,c.t);
                   case c.thr
                       % no change to throttle data
                       data.filtered.(dataName{n,m}) = ...
                            [data.filtered.(dataName{n,m}),...
                             smooth(data.ing.(dataName{n,m})(:,c.thr),...
                             0.003,'rloess')];
                   case c.ste
                       % No change to steering data
                       data.filtered.(dataName{n,m}) = ...
                            [data.filtered.(dataName{n,m}),...
                             smooth(data.ing.(dataName{n,m})(:,c.ste),...
                             0.003,'rloess')];
                   case c.nFL
                       % Smooth wheel speed data to eliminate spikes
                       data.filtered.(dataName{n,m}) = ...
                           [data.filtered.(dataName{n,m}),...
                            smooth(data.ing.(dataName{n,m})(:,c.nFL),...
                            0.003,'rloess')];
                   case c.nFR
                       data.filtered.(dataName{n,m}) = ...
                           [data.filtered.(dataName{n,m}),...
                            smooth(data.ing.(dataName{n,m})(:,c.nFR),...
                            0.003,'rloess')];
                   case c.ax
                       data.filtered.(dataName{n,m}) =...
                           [data.filtered.(dataName{n,m}),...
                           smooth(data.ing.(dataName{n,m})(:,c.ax),...
                           0.0021,'rloess')];                       
                   case c.ay
                       data.filtered.(dataName{n,m}) =...
                           [data.filtered.(dataName{n,m}),...
                           smooth(data.ing.(dataName{n,m})(:,c.ay),...
                           0.0021,'rloess')];
                   case c.az
                       data.filtered.(dataName{n,m}) =...
                           [data.filtered.(dataName{n,m}),...
                           smooth(data.ing.(dataName{n,m})(:,c.az),...
                           0.0021,'rloess')];
                   case c.gx
                       data.filtered.(dataName{n,m}) =...
                           [data.filtered.(dataName{n,m}),...
                           smooth(data.ing.(dataName{n,m})(:,c.gx),...
                           0.0021,'rloess')]; 
                   case c.gy
                       data.filtered.(dataName{n,m}) =...
                           [data.filtered.(dataName{n,m}),...
                           smooth(data.ing.(dataName{n,m})(:,c.gy),...
                           0.0021,'rloess')];
                   case c.gz
                       data.filtered.(dataName{n,m}) =...
                           [data.filtered.(dataName{n,m}),...
                           smooth(data.ing.(dataName{n,m})(:,c.gz),...
                           0.0021,'rloess')];
                   case c.dFL
                       % Not filtered
                       data.filtered.(dataName{n,m}) =...
                           [data.filtered.(dataName{n,m}),...
                            data.ing.(dataName{n,m})(:,c.dFL)];
                   case c.dFR
                       % Not filtered
                       data.filtered.(dataName{n,m}) =...
                           [data.filtered.(dataName{n,m}),...
                            data.ing.(dataName{n,m})(:,c.dFR)];
                   case c.dHL
                       % Not filtered
                       data.filtered.(dataName{n,m}) =...
                           [data.filtered.(dataName{n,m}),...
                            data.ing.(dataName{n,m})(:,c.dHL)];
                   case c.dHR
                       % Not filtered
                       data.filtered.(dataName{n,m}) =...
                           [data.filtered.(dataName{n,m}),...
                            data.ing.(dataName{n,m})(:,c.dHR)];
                        
               end
            end
        end
    end
end

%% PCA Analysis on the data
% Without poti values
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
                data.pca.set = data.filtered.(dataName{n,m})(:,2:11);
                if(loadMatrix(n,m) > 0)
                    data.pca.label =...
                    ones(size(data.ing.(dataName{n,m}),1),1) *...
                    loadMatrix(n,m);
                else
                    data.pca.label =...
                                  zeros(size(data.ing.(dataName{n,m}),1),1);
                end
                    firstEnteringFlag = false;
            else
                data.pca.set = [data.pca.set;...
                                data.filtered.(dataName{n,m})(:,2:11)];
                if(loadMatrix(n,m) > 0)
                    data.pca.label =...
                             [data.pca.label;...
                             ones(size(data.ing.(dataName{n,m}),1),1)*...
                             loadMatrix(n,m)];
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
if(savePCA == true)            
    save(namePCA,'-struct','data','pca');
end
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

%% Calculating velocity and acceleration from wheel speed
data.speed = struct;
data.rms.pitch = struct;
for n = 1 : nFiles
    for m = 1 : mFiles
        if (flagMatrix == true)
            meanWheelSpeed = (data.filtered.(dataName{n,m})(:,c.nFL)+...
                              data.filtered.(dataName{n,m})(:,c.nFR))/2;
            data.speed.(dataName{n,m}) = (108*pi*meanWheelSpeed)/(1000*60);
            data.speedFilt.(dataName{n,m}) = smooth(data.speed.(dataName{n,m}),0.02,'loess');
            data.acc.(dataName{n,m}) = (diff(data.speedFilt.(dataName{n,m}))./...
                                       diff(data.ing.(dataName{n,m})(:,c.t)))/9.81;
        end
    end
end


%% Calculating pitch angle with data
% TODO: use only data in a certain range
% TODO: Try to use only the data when velocity is smaler than a threshold

data.pitch.acc = struct;
data.pitch.poti.LR = struct; % Pitch angle with FL and HR poti
data.pitch.poti.RL = struct; % Pitch angle with FR and HL poti
for n = 1 : nFiles
    for m = 1 : mFiles
        if (flagMatrix(n,m) == true)
            data.pitch.acc.(dataName{n,m}) =...
                atan(data.ing.(dataName{n,m})(:,c.ax)./...
                     data.ing.(dataName{n,m})(:,c.az))...
                     *180/pi - angleOffset;
                 
            if(nColumns > 11)                     
                data.pitch.poti.LR.(dataName{n,m}) =...
                    atan((data.ing.(dataName{n,m})(:,c.dHR) - ...
                          data.ing.(dataName{n,m})(:,c.dFL))/(cal.lvh*1000))*...
                          180/pi;

                data.pitch.poti.RL.(dataName{n,m}) =...
                    atan((data.ing.(dataName{n,m})(:,c.dHL) - ...
                          data.ing.(dataName{n,m})(:,c.dFR))/(cal.lvh*1000))*...
                          180/pi;
               data.pitch.poti.dRear.(dataName{n,m}) = (polyval(cal.potiHL.polyVal,...
                                data.raw.(dataName{n,m})(:,c.dHL))-...
                                cal.offsetPotiHL +...
                               polyval(cal.potiHR.polyVal,...
                                data.raw.(dataName{n,m})(:,c.dHR))-...
                                cal.offsetPotiHR)/2;
               data.pitch.poti.dFront.(dataName{n,m}) = (polyval(cal.potiFL.polyVal,...
                                data.raw.(dataName{n,m})(:,c.dFL))-...
                                cal.offsetPotiFL +...
                               polyval(cal.potiFR.polyVal,...
                                data.raw.(dataName{n,m})(:,c.dFR))-...
                                cal.offsetPotiFR)/2;
               data.pitch.poti.HF.(dataName{n,m}) =...
                   atan((data.pitch.poti.dRear.(dataName{n,m}) - ...
                          data.pitch.poti.dFront.(dataName{n,m}))/(cal.lvh*1000))*...
                          180/pi;
            end
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
                        [p,f] = pwelch(filter(fHp,...
                                data.ing.(dataName{n,m})(:,c.ax)),...
                                [],[],[],cal.settings.samplingFreq);
                        
                        data.psd.(dataName{n,m}) = [f, p];
                        clear p f;
                    case 2
                        [p,f] = pwelch(filter(fHp,...
                                data.ing.(dataName{n,m})(:,c.ay)),...
                                [],[],[],cal.settings.samplingFreq);
                        
                        data.psd.(dataName{n,m}) =...
                                             [data.psd.(dataName{n,m}), p];
                        clear p f;
                    case 3
                        [p,f] = pwelch(filter(fHp,...
                                data.ing.(dataName{n,m})(:,c.az)),...
                                [],[],[],cal.settings.samplingFreq);
                            
                        data.psd.(dataName{n,m}) =...
                                             [data.psd.(dataName{n,m}), p];
                        clear p f;
                    case 4
                        [p,f] = pwelch(filter(fHp,...
                                data.ing.(dataName{n,m})(:,c.gx)),...
                                [],[],[],cal.settings.samplingFreq);
                            
                        data.psd.(dataName{n,m}) =...
                                             [data.psd.(dataName{n,m}), p];
                        clear p f;
                    case 5
                        [p,f] = pwelch(filter(fHp,...
                                data.ing.(dataName{n,m})(:,c.gy)),...
                                [],[],[],cal.settings.samplingFreq);
                            
                        data.psd.(dataName{n,m}) =...
                                             [data.psd.(dataName{n,m}), p];
                        clear p f;
                    case 6
                        [p,f] = pwelch(filter(fHp,...
                                data.ing.(dataName{n,m})(:,c.gz)),...
                                [],[],[],cal.settings.samplingFreq);
                            
                        data.psd.(dataName{n,m}) =...
                                             [data.psd.(dataName{n,m}), p];
                        clear p f;
                end
            end
        end
    end
end

%% Prepare data for Neuronal Network
firstEnteringFlag = true;
if(saveNN == true)
    for n = 1 : nFiles
        for m = 1 : mFiles
            if (flagMatrix(n,m) == true)
                % Put different datasets togeter
                if(firstEnteringFlag == true)
                    nn_input = [data.raw.(dataName{n,m})(1:end-1,2:11),...
                                   data.acc.(dataName{n,m})];
                    nn_output = data.pitch.poti.HF.(dataName{n,m})(1:end-1,1);
                    
                    nn_loadLabel = ones(...
                    size(data.raw.(dataName{n,m})(1:end-1,2:11),1),1)...
                    * loadMatrix(n,m);
                
                    nn_slopeLabel = ones(...
                    size(data.raw.(dataName{n,m})(1:end-1,2:11),1),1)*...
                    slopeMatrix(n,m);
                    
                    firstEnteringFlag = false;
                else
                    nn_input = [nn_input;...
                                    data.raw.(dataName{n,m})(1:end-1,2:11),...
                                    data.acc.(dataName{n,m})];
                    nn_output = [nn_output; data.pitch.poti.HF.(dataName{n,m})(1:end-1,1)];
                    
                    nn_loadLabel = [nn_loadLabel;...
                        ones(size(data.raw.(dataName{n,m})(1:end-1,2:11),1),1)...
                        * loadMatrix(n,m)];
                    
                    nn_slopeLabel = [nn_slopeLabel;
                        ones(size(data.raw.(dataName{n,m})(1:end-1,2:11),1),1)*...
                             slopeMatrix(n,m)];
                end
            end
        end
    end
    save(nameNN,'nn_input','nn_output','nn_loadLabel','nn_slopeLabel')
end
clear firstEnteringFlag;

%% Plot sensor data vs time
if(plotTimeData == true)
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
                plot(data.filtered.(dataName{n,m})(:,c.t),...
                     data.filtered.(dataName{n,m})(:,c.thr))
                plot(data.filtered.(dataName{n,m})(:,c.t),...
                     data.filtered.(dataName{n,m})(:,c.ste))
                
                 if(orginalOverlay == true)     
                    plot(data.ing.(dataName{n,m})(:,c.t),...
                         data.ing.(dataName{n,m})(:,c.thr))
                    plot(data.ing.(dataName{n,m})(:,c.t),...
                         data.ing.(dataName{n,m})(:,c.ste))
                    legend('Smoothed Throttle',...
                            'Smoothed Steering',...
                            'Throttle',...
                            'Steering')
                 else
                     legend('Smoothed Throttle',...
                           'Smoothed Steering')
                 end
                
                title('Steering and Throttle')
                xlabel('Time (s)')
                ylabel('(-)')
                grid minor
                ylim([-1.5 1.5])
                hold off

            subplot(4,1,2)
                hold on
                plot(data.filtered.(dataName{n,m})(:,c.t),...
                     data.filtered.(dataName{n,m})(:,c.nFL))
                plot(data.filtered.(dataName{n,m})(:,c.t),...
                     data.filtered.(dataName{n,m})(:,c.nFR))
                
                if(orginalOverlay == true)       
                    plot(data.ing.(dataName{n,m})(:,c.t),...
                         data.ing.(dataName{n,m})(:,c.nFL))
                    plot(data.ing.(dataName{n,m})(:,c.t),...
                         data.ing.(dataName{n,m})(:,c.nFR))
                    legend('Smoothed Front left',...
                           'Smoothed Front right',...
                           'Orginal Front left',...
                           'Orginal Front right')
                     
                else
                    legend('Smoothed Front left',...
                           'Smoothed Front right')
                end
                title('Wheel Speed')
                xlabel('Time (s)')
                ylabel('(1/min)')
                grid minor
                ylim([0 3000])
                hold off

             subplot(4,1,3)
                hold on
                plot(data.filtered.(dataName{n,m})(:,c.t),...
                     data.filtered.(dataName{n,m})(:,c.ax))
                plot(data.filtered.(dataName{n,m})(:,c.t),...
                     data.filtered.(dataName{n,m})(:,c.ay))
                plot(data.filtered.(dataName{n,m})(:,c.t),...
                     data.filtered.(dataName{n,m})(:,c.az))
                
                if(orginalOverlay == true)
                    plot(data.ing.(dataName{n,m})(:,c.t),...
                         data.ing.(dataName{n,m})(:,c.ax))
                    plot(data.ing.(dataName{n,m})(:,c.t),...
                         data.ing.(dataName{n,m})(:,c.ay))
                    plot(data.ing.(dataName{n,m})(:,c.t),...
                         data.ing.(dataName{n,m})(:,c.az))
                     legend('Smoothed x-Axis',...
                            'Smoothed y-Axis',...
                            'Smoothed z-Axis',...
                           'x-Axis','y-Axis','z-Axis')
                else
                    legend('Smoothed x-Axis',...
                           'Smoothed y-Axis',...
                           'Smoothed z-Axis')
                end
                title('Acceleration')
                xlabel('Time (s)')
                ylabel('(g)')
                grid minor
                ylim([-(cal.acc.range+0.5), cal.acc.range+0.5])
                hold off

             subplot(4,1,4)
                hold on
                   plot(data.filtered.(dataName{n,m})(:,c.t),...
                         data.filtered.(dataName{n,m})(:,c.gx))
                plot(data.filtered.(dataName{n,m})(:,c.t),...
                     data.filtered.(dataName{n,m})(:,c.gy))
                plot(data.filtered.(dataName{n,m})(:,c.t),...
                     data.filtered.(dataName{n,m})(:,c.gz))
                
                 
                if(orginalOverlay == true)
                    plot(data.ing.(dataName{n,m})(:,c.t),...
                     data.ing.(dataName{n,m})(:,c.gx))
                plot(data.ing.(dataName{n,m})(:,c.t),...
                     data.ing.(dataName{n,m})(:,c.gy))
                plot(data.ing.(dataName{n,m})(:,c.t),...
                     data.ing.(dataName{n,m})(:,c.gz))
                 legend('Smoothed x-Axis',...
                        'Smoothed y-Axis',...
                        'Smoothed z-Axis',...
                        'x-Axis','y-Axis','z-Axis')
                
                 
                else
                    legend('Smoothed x-Axis',...
                           'Smoothed y-Axis',...
                           'Smoothed z-Axis')
                
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
end

%% Plot Poti data
if(plotPotiData == true)
if(nColumns > 11)
for n = 1 : nFiles
    for m = 1 : mFiles
        if (flagMatrix(n,m) == true)
            
            figure('units','normalized','outerposition',[0 0 1 1])
            
            annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            strcat({''},dataName{n,m},...
            {' Potentiometer Data'}),...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
            
            subplot(4,1,1)
            hold on
            plot(data.filtered.(dataName{n,m})(:,c.t),...
                 data.filtered.(dataName{n,m})(:,c.dFL))
            
            if(orginalOverlay == true)
            plot(data.ing.(dataName{n,m})(:,c.t),...
                 data.ing.(dataName{n,m})(:,c.dFL))
            end
            hold off
            xlabel('Time (sec)')
            ylabel('deflection (mm)')
            grid minor
            title('Spring deflection front left')
            
            subplot(4,1,2)
            hold on
            plot(data.filtered.(dataName{n,m})(:,c.t),...
                 data.filtered.(dataName{n,m})(:,c.dFR))
            
            if(orginalOverlay == true)
            plot(data.ing.(dataName{n,m})(:,c.t),...
                 data.ing.(dataName{n,m})(:,c.dFR))
            end
            hold off
            xlabel('Time (sec)')
            ylabel('deflection (mm)')
            grid minor
            title('Spring deflection front right')
            
            subplot(4,1,3)
            hold on
            plot(data.filtered.(dataName{n,m})(:,c.t),...
                 data.filtered.(dataName{n,m})(:,c.dHL))
            
            if(orginalOverlay == true)
            plot(data.ing.(dataName{n,m})(:,c.t),...
                 data.ing.(dataName{n,m})(:,c.dHL))
            end
            hold off
            xlabel('Time (sec)')
            ylabel('deflection (mm)')
            grid minor
            title('Spring deflection rear left')
            
            subplot(4,1,4)
            hold on
            plot(data.filtered.(dataName{n,m})(:,c.t),...
                 data.filtered.(dataName{n,m})(:,c.dHR))
            
            if(orginalOverlay == true)
            plot(data.ing.(dataName{n,m})(:,c.t),...
                 data.ing.(dataName{n,m})(:,c.dHR))
            end
            hold off
            xlabel('Time (sec)')
            ylabel('deflection (mm)')
            grid minor
            title('Spring deflection rear right')
        end
    end
end
end
end

%% Plot pitch angle
if(plotPitchAngle == true)
if(nColumns > 11)
for n = 1 : nFiles
    for m = 1 : mFiles
        if (flagMatrix(n,m) == true)
            figure('units','normalized','outerposition',[0 0 1 1])
            
            annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            strcat({''},dataName{n,m},...
            {' Calculated pitch angle'}),...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
            
            subplot(4,1,1)
            hold on
            plot(data.ing.(dataName{n,m})(:,c.t),data.pitch.poti.LR.(dataName{n,m}))
            hold off
            grid minor
            title('Pitch angle from poti front left and rear right')
            xlabel('Time (sec)')
            ylabel('angle (°)')
            
            subplot(4,1,2)
            hold on
            plot(data.ing.(dataName{n,m})(:,c.t),data.pitch.poti.RL.(dataName{n,m}))
            hold off
            grid minor
            title('Pitch angle from poti front right and rear left')
            xlabel('Time (sec)')
            ylabel('angle (°)')
            
            subplot(4,1,3)
            hold on
            plot(data.ing.(dataName{n,m})(:,c.t),data.pitch.poti.HF.(dataName{n,m}))
            hold off
            grid minor
            title('Pitch angle from poti front left/right and rear left/right')
            xlabel('Time (sec)')
            ylabel('angle (°)')
            
            subplot(4,1,4)
            hold on
            plot(data.ing.(dataName{n,m})(:,c.t),data.pitch.acc.(dataName{n,m}))
            hold off
            grid minor
            title('Pitch angle from aceleromeer x-Axis and z-Axis')
            xlabel('Time (sec)')
            ylabel('angle (°)')
            
        end
    end
end
end
end

%% Plot Speed and acceleration derived from wheel speed
if(plotSpeedData == true)
for n = 1 : nFiles
    for m = 1 : mFiles
        if (flagMatrix(n,m) == true)
            figure('units','normalized','outerposition',[0 0 1 1])
            
            annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            strcat({''},dataName{n,m},...
            {' Calculated speed and acceleration'}),...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
            
            subplot(3,1,1)
            hold on
            plot(data.ing.(dataName{n,m})(:,c.t),data.speed.(dataName{n,m}))
            plot(data.ing.(dataName{n,m})(:,c.t),data.speedFilt.(dataName{n,m}))
            hold off
            grid on
            grid minor
            title('Vehicle Speed')
            xlabel('Time (sec)')
            ylabel('speed (m/s)')
            
            subplot(3,1,2)
            hold on
            plot(data.ing.(dataName{n,m})(:,c.t),data.speedFilt.(dataName{n,m})*3.6)
            hold off
            grid on
            grid minor
            title('Vehicle Speed')
            xlabel('Time (sec)')
            ylabel('speed (km/h)')
            
            subplot(3,1,3)
            hold on
            plot(data.ing.(dataName{n,m})(1:end-1,c.t),data.acc.(dataName{n,m}))
            hold off
            grid on
            grid minor
            title('Vehicle Acceleration')
            xlabel('Time (sec)')
            ylabel('acc (g)')
            
                        
        end
    end
end
end

%% Plot g-force data scatter
if(plotGforceScatter == true)
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
            scatter(data.ing.(dataName{n,m})(:,c.ay),...
                    data.ing.(dataName{n,m})(:,c.ax),20,...
                    data.ing.(dataName{n,m})(:,c.az),markerType{m});
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
end

%% Plot the acceleration data and corresponding RC-Controll values
if(plotControllAccData == true)
for n = 1 : nFiles
    
    figure('units','normalized','outerposition',[0 0 1 1])
            annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            strcat({''},dataName{n,m},...
           {' Acceleration data and corresponding RC-Controll values'}),...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
        
        subplot(3,1,1)
           hold on
           title('x-Axis acceleration and throttle')
           yyaxis left
           plot(data.ing.(dataName{n})(:,c.t),data.ing.(dataName{n})(:,c.ax));
           ylabel('(g)')
           ylim([-2 2])
           grid minor
           
           yyaxis right
           plot(data.ing.(dataName{n})(:,c.t),data.ing.(dataName{n})(:,c.thr));
           ylabel('-')
           xlabel('Time (s)')
           ylim([-1.5 1.5])
           legend('x-Axis Acceleration','Throttle')
           hold off
           
        subplot(3,1,2)
           hold on
           title('y-Axis acceleration and steering')
           yyaxis left
           plot(data.ing.(dataName{n})(:,c.t),data.ing.(dataName{n})(:,c.ay));
           ylabel('(g)')
           ylim([-2 2])
           grid minor
           
           yyaxis right
           plot(data.ing.(dataName{n})(:,c.t),data.ing.(dataName{n})(:,c.ste));
           ylabel('(-)')
           xlabel('Time (s)')
           ylim([-1.5 1.5])
           legend('y-Axis Acceleration','Steering')
           hold off
           
        subplot(3,1,3)
           hold on
           title('z-Axis acceleration and throttle')
           yyaxis left
           plot(data.ing.(dataName{n})(:,c.t),data.ing.(dataName{n})(:,c.az));
           ylabel('(g)')
           ylim([-2 2])
           grid minor
           
           yyaxis right
           plot(data.ing.(dataName{n})(:,c.t),data.ing.(dataName{n})(:,c.thr));
           ylabel('(-)')
           xlabel('Time (s)')
           ylim([-1.5 1.5])
           legend('z-Axis Acceleration','Throttle')
           hold off
end
end

%% Plot each acceleration axis data vs RC-Controll values
if(plotAccVsControl == true)
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
            plot(data.ing.(dataName{n,m})(:,c.thr),...
                 data.ing.(dataName{n,m})(:,c.ax),markerType{m});
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
            plot(data.ing.(dataName{n,m})(:,c.thr),...
                 data.ing.(dataName{n,m})(:,c.ay),markerType{m});
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
            plot(data.ing.(dataName{n,m})(:,c.thr),...
                 data.ing.(dataName{n,m})(:,c.az),markerType{m});
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
            plot(data.ing.(dataName{n,m})(:,c.ste),...
                 data.ing.(dataName{n,m})(:,c.ax),markerType{m});
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
            plot(data.ing.(dataName{n,m})(:,c.ste),...
                 data.ing.(dataName{n,m})(:,c.ay),markerType{m});
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
            plot(data.ing.(dataName{n,m})(:,c.ste),...
                 data.ing.(dataName{n,m})(:,c.az),markerType{m});
        end
         axis([-1.5 1.5 -(cal.acc.range+0.5) cal.acc.range+0.5])
        xlabel('Steering (-)')
        ylabel('z-Axis (g)')
        grid minor
        title('Steering vs Acceleration z-Axis')
        hold off
    
end
end

%% Plot histogramm for acceleration data
if(plotHist == true)
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
            h1 = histogram(data.ing.(dataName{n,m})(:,c.ax));
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
            h1 = histogram(data.ing.(dataName{n,m})(:,c.ay));
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
            h1 = histogram(data.ing.(dataName{n,m})(:,c.az));
            h1.Normalization = 'probability';
            h1.BinWidth = 0.1;
        end      
        xlim([-2 2])
        ylabel('Normalized Occurencies (-)')
        xlabel('Acceleration z-Axis (g)')
        legend(dataName(n,:),'interpreter','none')
        hold off
end
end

%% Plot power spectral density
if(plotPSD == true)
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
end
