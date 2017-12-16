%% Analysing the nois spectrum from acc and gyro sensor
clear;
close all;
clc;

%% Data captured with and without the van
dataVanON = load('Noise_Van_ON.txt');
dataVanOFF = load('Noise_Van_OFF.txt');
load('nn_Test_1.mat');
load('test.mat');
accDataON = dataVanON(:,5:7) * 1/16384;
gyroDataON = dataVanON(:,8:10) * 1/65.5;

accDataOFF = dataVanOFF(:,5:7) * 1/16384;
gyroDataOFF = dataVanOFF(:,8:10) * 1/65.5;





ingDataON = [accDataON, gyroDataON];
ingDataOFF = [accDataOFF, gyroDataOFF];

fHp = HighPassFilter();
fLp = LowPassFilter();
filter_ax = axFilter();

filteredDataON = filter(fHp,ingDataON,1);
%filteredDataON = filter(fLp,filteredDataON);

filteredDataOFF = filter(fHp,ingDataOFF,1);
%filteredDataOFF = filter(fLp,filteredDataOFF,1);

filteredInput = filter(fHp,nn_input,1);
filteredOutput = filter(fHp,nn_output,1);

filtered_ax = filter(fHp,ax);
%filtered_ax = filter(fLp,filtered_ax);

filtered_axSensor = filter(fHp,ax_sensor);
ax_sensorFilt = filter(filter_ax,ax_sensor);



clear accDataON gyroDataON accDataOFF gyroDataOFF



Fs = 40;
T = 1/Fs;


L_ON = size(filteredDataON,1);
L_OFF = size(filteredDataOFF,1);
L_Input = size(filteredInput,1);
L_Output = size(filteredOutput,1);

L_ax = size(filtered_ax,1);

windowON = 1;%window(@kaiser,L_ON,0.1);
windowOFF = 1;%window(@kaiser,L_OFF,0.1);
windowInput = 1;
windowOutput = 1;


f_ON = Fs*(0:(L_ON/2))/L_ON;
f_OFF = Fs*(0:(L_OFF/2))/L_OFF;
f_Input = Fs*(0:(L_Input/2))/L_Input;
f_Output = Fs*(0:(L_Output/2))/L_Output;
f_ax = Fs*(0:(L_ax/2))/L_ax;

t_ON = (0:L_ON-1)*T;
t_OFF = (0:L_OFF-1)*T;
t_Input = (0:L_Input-1)*T;
t_Output = (0:L_Output-1)*T;
t_ax = (0:L_ax-1)*T;

fftVanON = fft(filteredDataON.*windowON,[],1);
fftVanOFF = fft(filteredDataOFF.*windowOFF,[],1);
fftInput = fft(filteredInput.*windowInput,[],1);
fftOutput = fft(filteredOutput.*windowOutput,[],1);

fftax = fft(filtered_ax,[],1);
fftax_sensor = fft(filtered_axSensor,[],1);

P2_ON = abs(fftVanON/L_ON);
P2_OFF = abs(fftVanOFF/L_OFF);
P2_Input = abs(fftInput/L_Input);
P2_Output = abs(fftOutput/L_Output);

P2_ax = abs(fftax/L_ax);
P2_axSensor = abs(fftax_sensor/L_ax);

P1_ON = P2_ON(1:L_ON/2+1,:);
P1_OFF = P2_OFF(1:L_OFF/2+1,:);
P1_Input = P2_Input(1:L_Input/2+1,:);
P1_Output = P2_Output(1:L_Output/2+1,:);
P1_ax = P2_ax(1:L_ax/2+1,:);
P1_axSensor = P2_axSensor(1:L_ax/2+1,:);


P1_ON(2:end-1,:) = 2*P1_ON(2:end-1,:);
P1_OFF(2:end-1,:) = 2*P1_OFF(2:end-1,:);
P1_Input(2:end-1,:) = 2*P1_Input(2:end-1,:);
P1_Output(2:end-1,:) = 2*P1_Output(2:end-1,:);
P1_ax(2:end-1,:) = 2*P1_ax(2:end-1,:);
P1_axSensor(2:end-1,:) = 2*P1_axSensor(2:end-1,:);

%% PLot Comparrison between unfiltered data acc data  van on and off
figure()
 annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            'Comparrison betwean van on and off for Acc Data',...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
subplot(3,1,1)
hold on
plot(t_ON,ingDataON(:,1))
plot(t_OFF,ingDataOFF(:,1))
hold off
xlabel('Time (s)')
ylabel('Acceleration (g)')
legend('Van On','Van Off')
title('Acceleration x-Axis')

subplot(3,1,2)
hold on
plot(t_ON,ingDataON(:,2))
plot(t_OFF,ingDataOFF(:,2))
hold off
xlabel('Time (s)')
ylabel('Acceleration (g)')
legend('Van On','Van Off')
title('Acceleration y-Axis')

subplot(3,1,3)
hold on
plot(t_ON,ingDataON(:,3))
plot(t_OFF,ingDataOFF(:,3))
hold off
xlabel('Time (s)')
ylabel('Acceleration (g)')
legend('Van On','Van Off')
title('Acceleration z-Axis')

%% PLot Comparrison between unfiltered data gyro data  van on and off
figure()
annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            'Comparrison betwean van on and off for Gyro Data',...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
subplot(3,1,1)
hold on
plot(t_ON,ingDataON(:,4))
plot(t_OFF,ingDataOFF(:,4))
hold off
xlabel('Time (s)')
ylabel('Gyroscope (°/s)')
legend('Van On','Van Off')
title('Gyroscope x-Axis')

subplot(3,1,2)
hold on
plot(t_ON,ingDataON(:,5))
plot(t_OFF,ingDataOFF(:,5))
hold off
xlabel('Time (s)')
ylabel('Gyroscope (°/s)')
legend('Van On','Van Off')
title('Gyroscope y-Axis')

subplot(3,1,3)
hold on
plot(t_ON,ingDataON(:,6))
plot(t_OFF,ingDataOFF(:,6))
hold off
xlabel('Time (s)')
ylabel('Gyroscope (°/s)')
legend('Van On','Van Off')
title('Gyroscope z-Axis')


%% Plot comparrison betwean filtered and not filtered acc data van on
figure()
annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            'Comparrison betwean not filtered and filtered acc data van on',...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')

subplot(3,1,1)
hold on
plot(t_ON,ingDataON(:,1))
plot(t_ON,filteredDataON(:,1))
hold off
xlabel('Time (s)')
ylabel('Acceleration (g)')
legend('not filtered','filtered')
title('Acceleration x-Axis')

subplot(3,1,2)
hold on
plot(t_ON,ingDataON(:,2))
plot(t_ON,filteredDataON(:,2))
hold off
xlabel('Time (s)')
ylabel('Acceleration (g)')
legend('not filtered','filtered')
title('Acceleration y-Axis')

subplot(3,1,3)
hold on
plot(t_ON,ingDataON(:,3))
plot(t_ON,filteredDataON(:,3))
hold off
xlabel('Time (s)')
ylabel('Acceleration (g)')
legend('not filtered','filtered')
title('Acceleration z-Axis')

%% Plot comparrison betwean filtered and not filtered acc data van off
figure()
annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            'Comparrison betwean not filtered and filtered acc data van off',...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')

subplot(3,1,1)
hold on
plot(t_OFF,ingDataOFF(:,1))
plot(t_OFF,filteredDataOFF(:,1))
hold off
xlabel('Time (s)')
ylabel('Acceleration (g)')
legend('not filtered','filtered')
title('Acceleration x-Axis')

subplot(3,1,2)
hold on
plot(t_OFF,ingDataOFF(:,2))
plot(t_OFF,filteredDataOFF(:,2))
hold off
xlabel('Time (s)')
ylabel('Acceleration (g)')
legend('not filtered','filtered')
title('Acceleration y-Axis')

subplot(3,1,3)
hold on
plot(t_OFF,ingDataOFF(:,3))
plot(t_OFF,filteredDataOFF(:,3))
hold off
xlabel('Time (s)')
ylabel('Acceleration (g)')
legend('not filtered','filtered')
title('Acceleration z-Axis')

%% PLot Comparrison between unfiltered and filtered gyro data  van on 
figure()
annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            'Comparrison betwean not filtered and filtered Gyro Data van on',...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
subplot(3,1,1)
hold on
plot(t_ON,ingDataON(:,4))
plot(t_ON,filteredDataON(:,4))
hold off
xlabel('Time (s)')
ylabel('Gyroscope (°/s)')
legend('not filtered','filtered')
title('Gyroscope x-Axis')

subplot(3,1,2)
hold on
plot(t_ON,ingDataON(:,5))
plot(t_ON,filteredDataON(:,5))
hold off
xlabel('Time (s)')
ylabel('Gyroscope (°/s)')
legend('not filtered','filtered')
title('Gyroscope y-Axis')

subplot(3,1,3)
hold on
plot(t_ON,ingDataON(:,6))
plot(t_ON,filteredDataON(:,6))
hold off
xlabel('Time (s)')
ylabel('Gyroscope (°/s)')
legend('not filtered','filtered')
title('Gyroscope z-Axis')

%% PLot Comparrison between unfiltered and filtered gyro data  van off 
figure()
annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            'Comparrison betwean not filtered and filtered Gyro Data van off',...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
subplot(3,1,1)
hold on
plot(t_OFF,ingDataOFF(:,4))
plot(t_OFF,filteredDataOFF(:,4))
hold off
xlabel('Time (s)')
ylabel('Gyroscope (°/s)')
legend('not filtered','filtered')
title('Gyroscope x-Axis')

subplot(3,1,2)
hold on
plot(t_OFF,ingDataOFF(:,5))
plot(t_OFF,filteredDataOFF(:,5))
hold off
xlabel('Time (s)')
ylabel('Gyroscope (°/s)')
legend('not filtered','filtered')
title('Gyroscope y-Axis')

subplot(3,1,3)
hold on
plot(t_OFF,ingDataOFF(:,6))
plot(t_OFF,filteredDataOFF(:,6))
hold off
xlabel('Time (s)')
ylabel('Gyroscope (°/s)')
legend('not filtered','filtered')
title('Gyroscope z-Axis')

%% Plot spectrum fan on
figure()
annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            'Single-Sided Amplitude Spectrum van on',...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')

subplot(3,2,1)
hold on
plot(f_ON,P1_ON(:,1))
hold off

title('Acceleration x-Axis')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(3,2,3)
hold on
plot(f_ON,P1_ON(:,3))
hold off

title('Acceleration y-Axis')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(3,2,5)
hold on
plot(f_ON,P1_ON(:,3))
hold off

title('Acceleration z-Axis')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(3,2,2)
hold on
plot(f_ON,P1_ON(:,4))
hold off

title('Gyroscope x-Axis')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(3,2,4)
hold on
plot(f_ON,P1_ON(:,5))
hold off

title('Gyroscope y-Axis')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(3,2,6)
hold on
plot(f_ON,P1_ON(:,6))
hold off

title('Gyroscope z-Axis')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%% Plot spectrum fan off
figure()
annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            'Single-Sided Amplitude Spectrum van off',...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')

subplot(3,2,1)
hold on
plot(f_OFF,P1_OFF(:,1))
hold off

title('Acceleration x-Axis')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(3,2,3)
hold on
plot(f_OFF,P1_OFF(:,3))
hold off

title('Acceleration y-Axis')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(3,2,5)
hold on
plot(f_OFF,P1_OFF(:,3))
hold off

title('Acceleration z-Axis')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(3,2,2)
hold on
plot(f_OFF,P1_OFF(:,4))
hold off

title('Gyroscope x-Axis')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(3,2,4)
hold on
plot(f_OFF,P1_OFF(:,5))
hold off

title('Gyroscope y-Axis')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(3,2,6)
hold on
plot(f_OFF,P1_OFF(:,6))
hold off

title('Gyroscope z-Axis')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%% Plot spectrum ax and ax Sensor
figure()
annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            'Single-Sided Amplitude Spectrum ',...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')

subplot(3,1,1)
hold on
plot(t_ax,ax_sensor)
plot(t_ax,ax)
hold off
        
        
        
subplot(3,1,2)
hold on
plot(f_ax,P1_axSensor)
plot(f_ax,P1_ax)

hold off

title('')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(3,1,3)
hold on
plot(t_ax,ax_sensorFilt)
plot(t_ax,ax)
hold off

%% Plot spectrum ax and ax Sensor
figure()

subplot(2,1,1)
hold on
plot(t_ax,ax_sensor)
plot(t_ax,ax_sensorFilt)
hold off
grid on
grid minor
title('Vergleich')
xlabel('Zeit (s)')
ylabel('Beschleunigung (g)')

        
        
        
subplot(2,1,2)
hold on
plot(f_ax,P1_axSensor)
plot(f_ax,P1_ax)

hold off

title('Amplituden Spektrum')
xlabel('f (Hz)')
ylabel('|P1(f)|')
