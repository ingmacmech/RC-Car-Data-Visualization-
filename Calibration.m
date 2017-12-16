clear;
clc;
close all;

savePlots = true;
%% Add Cal_Data Path
currentPath = pwd;
addpath(genpath(currentPath));
clear currentPath;

%% Values hav to been set 
cal.settings.samplingFreq = 40;
cal.settings.f_tim = 18e6;
cal.acc.range = 2;            % Possible values 2, 4, 8, 16 
cal.gyro.range = 500;         % Possible values 250, 500, 1000, 2000
 
%% Veihicle parameters
cal.lvh = 0.325; % Radstand


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

%% Poti Calibration

% Data for front Axle
potiDataV = {'Cal1_Poti_V_0.TXT';
              'Cal1_Poti_V_2.TXT';
              'Cal1_Poti_V_4.TXT';
              'Cal1_Poti_V_6.TXT';
              'Cal1_Poti_V_8.TXT';
              'Cal1_Poti_V_10.TXT';
              'Cal1_Poti_V_12.TXT';
              'Cal1_Poti_V_14.TXT';
              'Cal1_Poti_V_16.TXT';
              'Cal1_Poti_V_18.TXT';
              'Cal1_Poti_V_20.TXT';
              'Cal1_Poti_V_22.TXT';
              'Cal1_Poti_V_24.TXT';
              'Cal1_Poti_V_26.TXT';
              'Cal1_Poti_V_28.TXT';
              'Cal1_Poti_V_30.TXT';
              'Cal1_Poti_V_32.TXT';
              'Cal1_Poti_V_34.TXT';
              'Cal1_Poti_V_36.TXT';
              'Cal1_Poti_V_38.TXT'};
          
% potiDataH = {'Cal1_Poti_H_0.TXT';
%               'Cal1_Poti_H_2.TXT';
%               'Cal1_Poti_H_4.TXT';
%               'Cal1_Poti_H_6.TXT';
%               'Cal1_Poti_H_8.TXT';
%               'Cal1_Poti_H_10.TXT';
%               'Cal1_Poti_H_12.TXT';
%               'Cal1_Poti_H_14.TXT';
%               'Cal1_Poti_H_16.TXT';
%               
%               'Cal1_Poti_H_20.TXT';
%               'Cal1_Poti_H_22.TXT';
%               'Cal1_Poti_H_24.TXT';
%               'Cal1_Poti_H_26.TXT';
%               'Cal1_Poti_H_28.TXT';
%               'Cal1_Poti_H_30.TXT';
%               'Cal1_Poti_H_32.TXT';
%               'Cal1_Poti_H_34.TXT';
%               'Cal1_Poti_H_36.TXT';
%               'Cal1_Poti_H_38.TXT';
%               'Cal1_Poti_H_40.TXT';
%               'Cal1_Poti_H_42.TXT';
%               'Cal1_Poti_H_44.TXT';
%               'Cal1_Poti_H_46.TXT'};

potiDataH = {'Cal2_Poti_H_0.TXT';
              'Cal2_Poti_H_2.TXT';
              'Cal2_Poti_H_4.TXT';
              'Cal2_Poti_H_6.TXT';
              'Cal2_Poti_H_8.TXT';
              'Cal2_Poti_H_10.TXT';
              'Cal2_Poti_H_12.TXT';
              'Cal2_Poti_H_14.TXT';
              'Cal2_Poti_H_16.TXT';
              'Cal2_Poti_H_18.TXT';
              'Cal2_Poti_H_20.TXT';
              'Cal2_Poti_H_22.TXT';
              'Cal2_Poti_H_24.TXT';
              'Cal2_Poti_H_26.TXT';
              'Cal2_Poti_H_28.TXT';
              'Cal2_Poti_H_30.TXT';
              'Cal2_Poti_H_32.TXT';
              'Cal2_Poti_H_34.TXT';
              'Cal2_Poti_H_36.TXT';
              'Cal2_Poti_H_38.TXT';
              'Cal2_Poti_H_40.TXT';
              'Cal2_Poti_H_42.TXT';
              'Cal2_Poti_H_44.TXT';
              'Cal2_Poti_H_46.TXT';
              'Cal2_Poti_H_48.TXT';
              };

springTravelV = 0:2:38;
% springTravelH = [0,2,4,6,8,10,12,14,16,20,22,24,26,28,30,32,34,36,38,40,42,44,46];
springTravelH = 0:2:48;
nStepsV = size(potiDataV,1);
nStepsH = size(potiDataH,1);

potiValueFR = zeros(nStepsV,1);
potiValueFL = zeros(nStepsV,1);
potiValueHR = zeros(nStepsV,1);
potiValueHL = zeros(nStepsV,1);



for n = 1 : nStepsV % Load only the necessary data for front axle
    temp = load(potiDataV{n});
    potiValueFR(n) = mean(temp(:,13));
    potiValueFL(n) = mean(temp(:,14));
    clear temp;
end

for n = 1 : nStepsH % Load only the necessary data for front axle
    temp = load(potiDataH{n});
    potiValueHR(n) = mean(temp(:,12));
    potiValueHL(n) = mean(temp(:,11));
    clear temp;
end


% poti offset calibration data
calDataPoti = load('Cal3_Pitch_Angle_0g.txt');

t_poti = (0 : 1/cal.settings.samplingFreq :(length(calDataPoti(:,1))-1) *...
                                  1/cal.settings.samplingFreq)';
potiOffsetHL = calDataPoti(:,11);
potiOffsetHR = calDataPoti(:,12);
potiOffsetFR = calDataPoti(:,13);
potiOffsetFL = calDataPoti(:,14);



% Fit a linear model to the data
[rPotiFR, aPotiFR, bPotiFR] = regression(potiValueFR,springTravelV','one');
fitPotiFR = polyval([aPotiFR bPotiFR], min(potiValueFR):max(potiValueFR));


[rPotiFL, aPotiFL, bPotiFL] = regression(potiValueFL,springTravelV','one');
fitPotiFL = polyval([aPotiFL bPotiFL], min(potiValueFL):max(potiValueFL));

[rPotiHR, aPotiHR, bPotiHR] = regression(potiValueHR,springTravelH','one');
fitPotiHR = polyval([aPotiHR bPotiHR], min(potiValueHR):max(potiValueHR));

[rPotiHL, aPotiHL, bPotiHL] = regression(potiValueHL,springTravelH','one');
fitPotiHL = polyval([aPotiHL bPotiHL], min(potiValueHL):max(potiValueHL));

% Set intersept to neutral position (without load)
% Caluculating the offset
cal.offsetPotiFR = mean(polyval([aPotiFR bPotiFR],potiOffsetFR));
cal.offsetPotiFL = mean(polyval([aPotiFL bPotiFL],potiOffsetFL));
cal.offsetPotiHR = mean(polyval([aPotiHR bPotiHR],potiOffsetHR));
cal.offsetPotiHL = mean(polyval([aPotiHL bPotiHL],potiOffsetHL));

% Set cal values for potis
cal.potiFL.polyVal = [aPotiFL bPotiFL];
cal.potiFR.polyVal = [aPotiFR bPotiFR];
cal.potiHL.polyVal = [aPotiHL bPotiHL];
cal.potiHR.polyVal = [aPotiHR bPotiHR];

figure('units','normalized','outerposition',[0 0 1 1])
hold on
plot(potiValueFL,springTravelV,'-*b')
plot(min(potiValueFL):max(potiValueFL),fitPotiFL,'--r')
hold off
grid minor
grid on
xlabel('ADC-Wert Poti (-)')
ylabel('Federweg (mm)')
legend('Gemessen','Lineares Model','Location','northwest')
ylim([-5 50])


figure('units','normalized','outerposition',[0 0 1 1])

% annotation('textbox', [0 0.9 1 0.1], ...
%                'String',...
%                'Potentiometer Calibration',...
%                'EdgeColor', 'none', ...
%                'HorizontalAlignment', 'center',...
%                'FontSize',12, 'FontWeight', 'bold','interpreter','none')
subplot(2,2,1)
hold on
plot(potiValueFL,springTravelV,'-*b')
plot(min(potiValueFL):max(potiValueFL),fitPotiFL,'--r')
hold off
grid minor
grid on
xlabel('ADC Poti Value (-)')
ylabel('\Delta Spring Travel (mm)')
title('Calibration potentiometer front left')
legend('measured','fitted','Location','northwest')
ylim([-5 50])

subplot(2,2,2)
hold on
plot(potiValueFR,springTravelV,'-*b')
plot(min(potiValueFR):max(potiValueFR),fitPotiFR,'--r')
hold off
grid minor
grid on
xlabel('ADC Poti Value (-)')
ylabel('\Delta Spring Travel (mm)')
title('Calibration potentiometer front right')
legend('measured','fitted','Location','northwest')
ylim([-5 50])

subplot(2,2,3)
hold on
plot(potiValueHL,springTravelH,'-*b')
plot(min(potiValueHL):max(potiValueHL),fitPotiHL,'--r')
hold off
grid minor
grid on
xlabel('ADC Poti Value (-)')
ylabel('\Delta Spring Travel (mm)')
title('Calibration potentiometer rear left')
legend('measured','fitted','Location','northwest')
ylim([-5 50])

subplot(2,2,4)
hold on
plot(potiValueHR,springTravelH,'-*b')
plot(min(potiValueHR):max(potiValueHR),fitPotiHR,'--r')
hold off
grid minor
grid on
xlabel('ADC Poti Value (-)')
ylabel('\Delta Spring Travel (mm)')
title('Calibration potentiometer rear right')
legend('measured','fitted','Location','northwest')
ylim([-5 50])

if(savePlots == true)
    h = gcf;
    set(h, 'PaperOrientation','landscape');
    set(h,'PaperUnits' ,'normalized');
    set(h, 'PaperPosition', [0 0 1 1]);
    print(gcf, '-dpdf', 'Poti_Kal')
end


%% Load Calibration file and separate vectors 
calDataControll = load('CalData_Stearing_Throttle.txt');

t_controll = (0 : 1/cal.settings.samplingFreq :(length(calDataControll(:,1))-1) *...
                                  1/cal.settings.samplingFreq)';

throttle = calDataControll(:,1);
steering = calDataControll(:,2);




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
plot(t_controll,calDataControll(:,1))
plot([t_controll(1) t_controll(end)],[cal.throttle.maxPos cal.throttle.maxPos], '--r')
text(1,cal.throttle.maxPos+70,['maxPosTrottle = ',...
                            num2str(cal.throttle.maxPos)],...
                           'HorizontalAlignment','left');
                            
plot([t_controll(1) t_controll(end)],[cal.throttle.minPos cal.throttle.minPos], '--r')
text(1,cal.throttle.minPos+70,['minPosTrottle = ',...
                            num2str(cal.throttle.minPos)],...
                           'HorizontalAlignment','left');
                            
plot([t_controll(1) t_controll(end)],[cal.throttle.nullPos cal.throttle.nullPos], '--b')
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
plot(t_controll,calDataControll(:,2))

plot([t_controll(1) t_controll(end)],[cal.steering.maxPos cal.steering.maxPos], '--r')
text(1,cal.steering.maxPos+70,['maxPosSteering = ',...
                            num2str(cal.steering.maxPos)],...
                           'HorizontalAlignment','left');
                            
plot([t_controll(1) t_controll(end)],[cal.steering.minPos cal.steering.minPos], '--r')
text(1,cal.steering.minPos+70,['minPosSteering = ',...
                            num2str(cal.steering.minPos)],...
                           'HorizontalAlignment','left');
                            
plot([t_controll(1) t_controll(end)],[cal.steering.nullPos cal.steering.nullPos], '--b')
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

%% Test calibration for Poti


