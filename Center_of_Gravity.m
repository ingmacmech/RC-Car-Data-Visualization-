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

tilt_angle =  [ 63.6 , 64.1;
                63.9 , 63.9;
                63.8 , 63.8;
                63.5 , 63.8;
                63.8 , 63.8] * pi/180;

l_RL = 250 / 1000; % Wheel track (m)
l_RL_ = 295 / 1000; % Outer wheel track (m)
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
h_S = l_RL_ ./ (2*tan(tilt_angle)) *1000;



figure()
hold on
viscircles([0 (d_wheel/2)], d_wheel/2, 'Color', 'k', 'LineWidth', 1); % Front wheel 
viscircles([l_VH*1000 d_wheel/2], d_wheel/2, 'Color', 'k', 'LineWidth', 1); % Rear wheel
plot([d_wheel/2,l_VH*1000 - d_wheel/2],[30,30],'k')
plot(mean(l_SV),mean(mean(h_S,1)),'+','MarkerSize',20);

grid minor
daspect([1 1 1])
axis([-(d_wheel/2+10) , l_VH*1000+d_wheel/2+10 , 0 , 200 ])
hold off

figure()
hold on
rectangle('Position',[ -d_wheel/2, l_RL*1000/2, d_wheel , 40],'Curvature',0.2) % Wheel front right
rectangle('Position',[ -d_wheel/2, -(l_RL*1000/2+40), d_wheel, 40],'Curvature',0.2) % Wheel front left
rectangle('Position',[ l_VH*1000-d_wheel/2, -(l_RL*1000/2+45), d_wheel, 45],'Curvature',0.2) % Wheel rear left
rectangle('Position',[ l_VH*1000-d_wheel/2, l_RL*1000/2, d_wheel , 45],'Curvature',0.2) % Wheel front right
plot(mean(l_SV),(mean(l_SL)-l_RL*1000/2),'+','MarkerSize',20)
text(0,(mean(l_SL)-l_RL*1000/2)-20 ,['l_{SV} = ',...
                                                num2str(mean(l_SV)),' mm / ',...
                                                'l_{SV} = ',...
                                                num2str(mean(l_SH)),' mm / ',...
                                                'l_{SL} = ',...
                                                num2str(mean(l_SL)),' mm / ',...
                                                'l_{SR} = ',...
                                                num2str(mean(l_SR)),' mm'],...
                            'HorizontalAlignment','left');
daspect([1 1 1])
axis([-(d_wheel/2+10) , l_VH*1000+d_wheel/2+10 , -200 , 200 ])
grid minor
hold off



