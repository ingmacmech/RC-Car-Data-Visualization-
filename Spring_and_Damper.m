%% Spring rate
clc;
clear;
close all;
% Data 
s = [0 3 6 9 12 15]';
front_right = [  0    0   0   0   0;
                142  142 141 142 143;
                287  284 287 287 287;
                437  436 463 438 438;
                589  592 589 591 591;
                749  748 747 750 751]/1000 * 9.81;
          
front_left = [  0   0   0   0   0;
               141 141 139 141 140 ;
               284 283 283 283 281 ;
               428 426 426 427 425 ;
               579 578 579 579 578 ;
               733 732 734 729 731 ]/1000 * 9.81;
          
rear_left  = [ 0   0   0   0   0;
              92  94  94  93  94;
              184 185 188 187 189 ;
              278 281 285 285 282 ;
              375 375 381 380 381 ;
              473 463 479 476 473 ]/1000 * 9.81;
          
rear_right = [ 0   0   0   0   0;
               93  95  94  94  94;
              187 189 189 188 188 ;
              283 286 286 286 283 ;
              377 382 381 381 378 ;
              477 477 476 480 476 ]/1000 * 9.81;
          
%% Regression



%% Plot Data

figure()
subplot(2,2,1)
hold on
plot(s, front_left(:,1), '+')
plot(s, front_left(:,2), '+')
plot(s, front_left(:,3), '+')
plot(s, front_left(:,4), '+')
plot(s, front_left(:,5), '+')
hold off


subplot(2,2,2)
hold on
plot(s, front_right(:,1), '+')
plot(s, front_right(:,2), '+')
plot(s, front_right(:,3), '+')
plot(s, front_right(:,4), '+')
plot(s, front_right(:,5), '+')
hold off

subplot(2,2,3)
hold on
plot(s, rear_left(:,1), '+')
plot(s, rear_left(:,2), '+')
plot(s, rear_left(:,3), '+')
plot(s, rear_left(:,4), '+')
plot(s, rear_left(:,5), '+')
hold off


subplot(2,2,4)
hold on
plot(s, rear_right(:,1), '+')
plot(s, rear_right(:,2), '+')
plot(s, rear_right(:,3), '+')
plot(s, rear_right(:,4), '+')
plot(s, rear_right(:,5), '+')
hold off

