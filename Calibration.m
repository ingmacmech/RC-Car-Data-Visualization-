clear;
clc;
close all;

%% Some values
samplingFreq = 20;

%% Load Calibration file and separate vectors 
calData = load('CalData.txt');
t = (0 : 1/samplingFreq :(length(calData(:,1))-1) *...
                                  1/samplingFreq)';
throttle = calData(:,1);
steering = calData(:,2);

%% Calibration for throttle and steering

% Extract min, max and null Pos for throttle
maxPosThrottle  = mean(throttle( throttle > 5900 ));
minPosThrottle  = mean(throttle( throttle < 3080 ));
nullPosThrottle = mean(throttle( throttle > 4565 & throttle < 4580));

% Extract min, max, and null Pos for steering
maxPosSteering  = mean(steering( steering > 5900 ));
minPosSteering  = mean(steering( steering < 3080 ));
nullPosSteering = mean(steering( steering > 4600 & steering < 4700));

% Linear regression
xThrottle = [minPosThrottle, nullPosThrottle, maxPosThrottle];
xSteering = [minPosSteering, nullPosSteering, maxPosSteering];
yTarget = [-1, 0, 1];

[rThrottle, aThrottle, bThrottle] = regression(xThrottle,yTarget,'one');
fitThrottle = polyval([aThrottle bThrottle], min(throttle):max(throttle));

[rSteering, aSteering, bSteering] = regression(xSteering,yTarget,'one');
fitSteering = polyval([aSteering bSteering], min(steering):max(steering));

% Plot Throttle to check cal
figure('units','normalized','outerposition',[0 0 1 1])
subplot(1,2,1)
hold on
plot(t,calData(:,1))
plot([t(1) t(end)],[maxPosThrottle maxPosThrottle], '--r')
text(1,maxPosThrottle+70,['maxPosTrottle = ',...
                            num2str(maxPosThrottle)],...
                           'HorizontalAlignment','left');
                            
plot([t(1) t(end)],[minPosThrottle minPosThrottle], '--r')
text(1,minPosThrottle+70,['minPosTrottle = ',...
                            num2str(minPosThrottle)],...
                           'HorizontalAlignment','left');
                            
plot([t(1) t(end)],[nullPosThrottle nullPosThrottle], '--b')
text(1,nullPosThrottle+70,['nullPosTrottle = ',...
                             num2str(nullPosThrottle)],...
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

plot([t(1) t(end)],[maxPosSteering maxPosSteering], '--r')
text(1,maxPosSteering+70,['maxPosSteering = ',...
                            num2str(maxPosSteering)],...
                           'HorizontalAlignment','left');
                            
plot([t(1) t(end)],[minPosSteering minPosSteering], '--r')
text(1,minPosSteering+70,['minPosSteering = ',...
                            num2str(minPosSteering)],...
                           'HorizontalAlignment','left');
                            
plot([t(1) t(end)],[nullPosSteering nullPosSteering], '--b')
text(1,nullPosSteering+70,['nullPosTrottle = ',...
                             num2str(nullPosSteering)],...
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

%% Fill all values into a calibration struct
cal.throttle.polyVal = [aThrottle bThrottle];
cal.throttle.maxPos = maxPosThrottle;
cal.throttle.minPos = minPosThrottle;
cal.throttle.nullPos = nullPosThrottle;

cal.steering.polyVal = [aSteering bSteering];
cal.steering.maxPos = maxPosSteering;
cal.steering.minPos = minPosSteering;
cal.steering.nullPos = nullPosSteering;

%% Ask user if he wants to save the cal struct
saveCal = input('Would you like to save the calibration values? (Y/N) ', 's');
if strcmp(saveCal, 'Y')
   save('cal');
   fprintf('\nCal struct saved!\n');
end

