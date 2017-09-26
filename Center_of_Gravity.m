%% Center of Gravaty estimation
clc;
clear;
close all;

%% Save Plots
savePlots = false;

%% Data 
%               VL    VR    HL    HR
wheel_force = [ 406 , 428 , 705 , 660 ;
                404 , 429 , 708 , 656 ;
                404 , 432 , 711 , 654 ;
                399 , 432 , 712 , 654 ;
                402 , 428 , 708 , 657 ;] / 1000 * 9.81;

l_RL = 250 / 1000; % Wheel track (m)
l_VH = 330 / 1000; % Wheel base  (m)

d_wheel = 110; % Wheel diameter (mm)

%% 
%                       FV = VL + VR                          FH = HL + HR            
axel_force = [ wheel_force(:,1) + wheel_force(:,1) , wheel_force(:,3) + wheel_force(:,4) ];
%                       FL = VL + HL                          FR = VR + HL
side_force = [ wheel_force(:,1) + wheel_force(:,3) , wheel_force(:,2) + wheel_force(:,4) ];

F_G = axel_force(:,1) + axel_force(:,2);

% x Coordinate
l_SH = ((axel_force(:,1) * l_VH) ./  F_G) * 1000;   % Distance in (mm)
l_SV = l_VH * 1000 - l_SH;                          % Distance in (mm)

% y Coordinate
l_SL = ((side_force(:,2) * l_RL) ./ F_G) * 1000;    % Distance in (mm)
l_SR = l_RL * 1000 - l_SL;                          % Distance in (mm)

% z Coordinate




figure()
subplot(2,1,1)
hold on
viscircles([0 (d_wheel/2)], d_wheel/2, 'Color', 'k', 'LineWidth', 1); % Front wheel 
viscircles([l_VH*1000 d_wheel/2], d_wheel/2, 'Color', 'k', 'LineWidth', 1); % Rear wheel


grid minor

axis([-(d_wheel/2+10) , l_VH*1000+d_wheel/2+10 , 0 , 200 ])

subplot()
