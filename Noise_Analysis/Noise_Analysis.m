%% Analysing the nois spectrum from acc and gyro sensor
clear;
close all;
clc;

%% Data captured with and without the van
dataVanON = load('Noise_Van_ON.txt');
dataVanOFF = load('Noise_Van_OFF.txt');
load('nn_Test_1.mat');

accDataON = dataVanON(:,5:7) * 1/16384;
gyroDataON = dataVanON(:,8:10) * 1/65.5;

accDataOFF = dataVanOFF(:,5:7) * 1/16384;
gyroDataOFF = dataVanOFF(:,8:10) * 1/65.5;



ingDataON = [accDataON, gyroDataON];
ingDataOFF = [accDataOFF, gyroDataOFF];

fHp = HighPassFilter();
fLp = LowPassFilter();

filteredDataON = filter(fHp,ingDataON,1);
filteredDataON = filter(fLp,filteredDataON);
filteredDataOFF = filter(fHp,ingDataOFF,1);

clear accDataON gyroDataON accDataOFF gyroDataOFF



Fs = 40;
T = 1/Fs;


L_ON = size(filteredDataON,1);
L_OFF = size(filteredDataOFF,1);

windowON = window(@kaiser,L_ON,0.1);
windowOFF = window(@kaiser,L_OFF,0.1);

f_ON = Fs*(0:(L_ON/2))/L_ON;
f_OFF = Fs*(0:(L_OFF/2))/L_OFF;

t_ON = (0:L_ON-1)*T;
t_OFF = (0:L_OFF-1)*T;

fftVanON = fft(filteredDataON.*windowON,[],1);
fftVanOFF = fft(filteredDataOFF.*windowOFF,[],1);

P2_ON = abs(fftVanON/L_ON);
P2_OFF = abs(fftVanOFF/L_OFF);

P1_ON = P2_ON(1:L_ON/2+1,:);
P1_OFF = P2_OFF(1:L_OFF/2+1,:);

P1_ON(2:end-1,:) = 2*P1_ON(2:end-1,:);
P1_OFF(2:end-1,:) = 2*P1_OFF(2:end-1,:);



figure()

subplot(3,1,1)
hold on
plot(t_ON,ingDataON(:,1))
plot(t_OFF,ingDataOFF(:,1))
plot(t_ON,filteredDataON(:,1))
plot(t_OFF,filteredDataOFF(:,1))
hold off

subplot(3,1,2)
hold on
plot(t_ON,ingDataON(:,2))
plot(t_OFF,ingDataOFF(:,2))
plot(t_ON,filteredDataON(:,2))
plot(t_OFF,filteredDataOFF(:,2))
hold off

subplot(3,1,3)
hold on
plot(t_ON,ingDataON(:,3))
plot(t_OFF,ingDataOFF(:,3))
plot(t_ON,filteredDataON(:,3))
plot(t_OFF,filteredDataOFF(:,3))
hold off

figure()

subplot(3,1,1)
hold on
plot(t_ON,ingDataON(:,4))
plot(t_OFF,ingDataOFF(:,4))
plot(t_ON,filteredDataON(:,4))
plot(t_OFF,filteredDataOFF(:,4))
hold off

subplot(3,1,2)
hold on
plot(t_ON,ingDataON(:,5))
plot(t_OFF,ingDataOFF(:,5))
plot(t_ON,filteredDataON(:,5))
plot(t_OFF,filteredDataOFF(:,5))
hold off

subplot(3,1,3)
hold on
plot(t_ON,ingDataON(:,6))
plot(t_OFF,ingDataOFF(:,6))
plot(t_ON,filteredDataON(:,6))
plot(t_OFF,filteredDataOFF(:,6))
hold off

figure()
subplot(3,1,1)
hold on
plot(f_ON,P1_ON(:,1))
hold off

title('Single-Sided Amplitude Spectrum')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(3,1,2)
hold on
plot(f_ON,P1_ON(:,2))
hold off

title('Single-Sided Amplitude Spectrum')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(3,1,3)
hold on
plot(f_ON,P1_ON(:,3))
hold off

title('Single-Sided Amplitude Spectrum')
xlabel('f (Hz)')
ylabel('|P1(f)|')




