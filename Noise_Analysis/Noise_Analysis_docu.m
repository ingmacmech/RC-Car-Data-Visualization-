%% Analysing the nois spectrum from acc and gyro sensor
clear;
close all;
clc;

%% Data captured with and without the van
load('nn_Test_1.mat');
load('test.mat');

fHp = HighPassFilter();
fLp = axFilter();

filteredInputHp = nn_input(:,5)* 1/16384;%filter(fHp,nn_input(:,5)* 1/16384,1);
filteredInputLp = filter(fLp,nn_input(:,5)* 1/16384,1);

Fs = 40;
T = 1/Fs;


L_InputHp = size(filteredInputHp,1);
L_InputLp = size(filteredInputLp,1);


windowInputHp = 1;
windowInputLp = 1;


f_InputHp = Fs*(0:(L_InputHp/2))/L_InputHp;
f_InputLp = Fs*(0:(L_InputLp/2))/L_InputLp;

t_InputHp = (0:L_InputHp-1)*T;
t_InputLp = (0:L_InputLp-1)*T;

fftInputHp = fft(filteredInputHp.*windowInputHp,[],1);
fftInputLp = fft(filteredInputLp.*windowInputLp,[],1);


P2_InputHp = abs(fftInputHp/L_InputHp);
P2_InputLp = abs(fftInputLp/L_InputLp);

P1_InputHp = P2_InputHp(1:L_InputHp/2+1,:);
P1_InputLp = P2_InputLp(1:L_InputLp/2+1,:);


P1_InputHp(2:end-1,:) = 2*P1_InputHp(2:end-1,:);
P1_InputLp(2:end-1,:) = 2*P1_InputLp(2:end-1,:);


%% Plot 
figure()

subplot(2,1,1)
hold on
plot(t_InputHp,nn_input(:,5)* 1/16384)
plot(t_InputLp,filteredInputLp)
hold off
grid on
grid minor
title('Beschleunigung x-Achse')
xlabel('Zeit (s)')
ylabel('(g)')
legend('nicht gefiltert','gefiltert')
xlim([0 100])
        
subplot(2,1,2)
hold on
plot(f_InputHp,P1_InputHp)
plot(f_InputLp,P1_InputLp)
hold off
grid on
grid minor
title('Amplituden Spektrum')
xlabel('Frequenz (Hz)')
ylabel('|Amplitude|')
legend('nicht gefiltert','gefiltert')