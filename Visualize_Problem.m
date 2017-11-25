%% Plot Problem to solve
close
clear
clc

load('dataForProblem.mat')



n = 20;

alpha_0 = 0;
alpha_6 = 6*pi/180;
g = 1;
dotV = linspace(-2,2,n); 
theta = linspace(-7,7,n)*pi/180;

[X,Y] = meshgrid(dotV,theta);


ax_0 = X.*cos(Y) + g*sin(alpha_0+Y);
az_0 = -X.*sin(Y) + g*cos(alpha_0+Y);

ax_6 = X.*cos(Y) + g*sin(alpha_6+Y);
az_6 = -X.*sin(Y) + g*cos(alpha_6+Y);

test = sin(X)+cos(Y);
C = X.*Y;
figure()
hold on
surf(X,Y*180/pi,ax_0)
surf(X,Y*180/pi,az_0)
scatter3(acc.Test51_0g_TiefGarageLuzern_1,...
        pitch.poti.HF.Test51_0g_TiefGarageLuzern_1(1:end-1,1),...
        ing.Test51_0g_TiefGarageLuzern_1(1:end-1,6),'+r')
scatter3(acc.Test50_200g_TiefGarageLuzern_1,...
        pitch.poti.HF.Test50_200g_TiefGarageLuzern_1(1:end-1,1),...
        ing.Test50_200g_TiefGarageLuzern_1(1:end-1,6),'+b')

scatter3(acc.Test51_0g_TiefGarageLuzern_1,...
        pitch.poti.HF.Test51_0g_TiefGarageLuzern_1(1:end-1,1),...
        ing.Test51_0g_TiefGarageLuzern_1(1:end-1,8),'or')
scatter3(acc.Test50_200g_TiefGarageLuzern_1,...
        pitch.poti.HF.Test50_200g_TiefGarageLuzern_1(1:end-1,1),...
        ing.Test50_200g_TiefGarageLuzern_1(1:end-1,8),'ob')
    
    
grid on
grid minor
hold off
xlabel('Beschleunigung Fahrzeug (g)')
ylabel('Nickwinkel (°)')
zlabel('ax')