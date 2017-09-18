clear;
clc;
close all;

%% Some values
cal.settings.samplingFreq = 20;
cal.settings.f_tim = 18e6;
cal.acc.range = 2;            % Possible values 2, 4, 8, 16 
cal.gyro.range = 500;         % Possible values 250, 500, 1000, 2000
 


%% Load Calibration file and separate vectors 
calData = load('CalData.txt');
t = (0 : 1/cal.settings.samplingFreq :(length(calData(:,1))-1) *...
                                  1/cal.settings.samplingFreq)';
throttle = calData(:,1);
steering = calData(:,2);

%% Set Acceleration and Gyro conversion factor

switch (cal.acc.range)
    case 2
        cal.acc.mult = 1/16384;
    case 4
        cal.acc.mult = 1/8192;
    case 8
        cal.acc.mult = 1/4096;
    case 16
        cal.acc.mult = 1/2048;
end

switch (cal.gyro.range)
    case 250
        cal.gyro.mult = 1/131;
    case 500
        cal.gyro.mult = 1/65.5;
    case 1000
        cal.gyro.mult = 1/32.8;
    case 2000
        cal.gyro.mult = 1/16.4;
end

%% Set wheel speed factors
cal.wheel.n = (cal.settings.f_tim * 60) / 2; % Conversion faktor for wheel speed 


%% Calibration for throttle and steering

% Extract min, max and null Pos for throttle
cal.throttle.maxPos  = mean(throttle( throttle > 5900 ));
cal.throttle.minPos  = mean(throttle( throttle < 3080 ));
cal.throttle.nullPos = mean(throttle( throttle > 4565 & throttle < 4580));

% Extract min, max, and null Pos for steering
cal.steering.maxPos  = mean(steering( steering > 5900 ));
cal.steering.minPos  = mean(steering( steering < 3080 ));
cal.steering.nullPos = mean(steering( steering > 4600 & steering < 4700));

% Linear regression
xThrottle = [cal.throttle.minPos,...
             cal.throttle.nullPos,...
             cal.throttle.maxPos];

xSteering = [cal.steering.minPos,...
             cal.steering.nullPos,...
             cal.steering.maxPos];

yTarget = [-1, 0, 1];

[rThrottle, aThrottle, bThrottle] = regression(xThrottle,yTarget,'one');
fitThrottle = polyval([aThrottle bThrottle], min(throttle):max(throttle));
cal.throttle.polyVal = [aThrottle bThrottle];

[rSteering, aSteering, bSteering] = regression(xSteering,yTarget,'one');
fitSteering = polyval([aSteering bSteering], min(steering):max(steering));
cal.steering.polyVal = [aSteering bSteering];

% Plot Throttle to check cal
figure('units','normalized','outerposition',[0 0 1 1])
subplot(1,2,1)
hold on
plot(t,calData(:,1))
plot([t(1) t(end)],[cal.throttle.maxPos cal.throttle.maxPos], '--r')
text(1,cal.throttle.maxPos+70,['maxPosTrottle = ',...
                            num2str(cal.throttle.maxPos)],...
                           'HorizontalAlignment','left');
                            
plot([t(1) t(end)],[cal.throttle.minPos cal.throttle.minPos], '--r')
text(1,cal.throttle.minPos+70,['minPosTrottle = ',...
                            num2str(cal.throttle.minPos)],...
                           'HorizontalAlignment','left');
                            
plot([t(1) t(end)],[cal.throttle.nullPos cal.throttle.nullPos], '--b')
text(1,cal.throttle.nullPos+70,['nullPosTrottle = ',...
                             num2str(cal.throttle.nullPos)],...
                            'HorizontalAlignment','left');

title('Check Trottle max, min and 0-Position value')
xlabel('Time (s)')
ylabel('Stering Pos (-)')
ylim([2500 6500])
grid minor
hold off

subplot(1,2,2)
hold on
plot(xThrottle,yTarget,'*')
plot(min(throttle):max(throttle),fitThrottle)
text(min(throttle),1,['r = ',...
                            num2str(rThrottle)],...
                           'HorizontalAlignment','left')
xlim([2500 6500])
ylim([-1.2 1.2])
grid minor
ylabel('brake / reverse \leftarrow      \rightarrow forward     ')
hold off

% Plot steering to check cal
figure('units','normalized','outerposition',[0 0 1 1])
subplot(1,2,1)
hold on
plot(t,calData(:,2))

plot([t(1) t(end)],[cal.steering.maxPos cal.steering.maxPos], '--r')
text(1,cal.steering.maxPos+70,['maxPosSteering = ',...
                            num2str(cal.steering.maxPos)],...
                           'HorizontalAlignment','left');
                            
plot([t(1) t(end)],[cal.steering.minPos cal.steering.minPos], '--r')
text(1,cal.steering.minPos+70,['minPosSteering = ',...
                            num2str(cal.steering.minPos)],...
                           'HorizontalAlignment','left');
                            
plot([t(1) t(end)],[cal.steering.nullPos cal.steering.nullPos], '--b')
text(1,cal.steering.nullPos+70,['nullPosTrottle = ',...
                             num2str(cal.steering.nullPos)],...
                            'HorizontalAlignment','left');

title('Check Steering max, min and 0-Position value')
xlabel('Time (s)')
ylabel('Stering Pos (-)')
ylim([2500 6500])
grid minor
hold off

subplot(1,2,2)

hold on
plot(xSteering,yTarget,'*')
plot(min(steering):max(steering),fitSteering)
text(min(steering),1,['r = ',...
                            num2str(rSteering)],...
                           'HorizontalAlignment','left')
xlim([2500 6500])
ylim([-1.2 1.2])
grid minor
ylabel('left turn \leftarrow 0 \rightarrow right turn')
hold off


%% Ask user if he wants to save the cal struct
saveCal = input('Would you like to save the calibration values? (Y/N) ', 's');
if strcmp(saveCal, 'Y')
   save('cal', 'cal');
   fprintf('\nCalibration struct saved!\n');
else
    fprintf('\nCalibration struct NOT saved!\n');
end

