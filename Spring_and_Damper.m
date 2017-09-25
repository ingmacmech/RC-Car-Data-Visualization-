%% Spring rate
clc;
clear;
close all;

%% Save Plots
savePlots = false;

%% Data 
s = [0 3 6 9 12 15]';
front_right = [  0    0   0   0   0;
                142  142 141 142 143;
                287  284 287 287 287;
                437  436 436 438 438;
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
mean_front_left = mean(front_left,2);
mean_front_right = mean(front_right,2);
mean_rear_left = mean(rear_left,2);
mean_rear_right = mean(rear_right,2);

f_front_left = fitlm(s,mean_front_left,'linear','Intercept',false);
f_front_right = fitlm(s,mean_front_right,'linear','Intercept',false);
f_rear_left = fitlm(s,mean_rear_left,'linear','Intercept',false);
f_rear_right = fitlm(s,mean_rear_right,'linear','Intercept',false);

%% Plot Data

figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,2,1)
hold on
plot(s, front_left(:,1), '+b','HandleVisibility','off')
plot(s, front_left(:,2), '+b','HandleVisibility','off')
plot(s, front_left(:,3), '+b','HandleVisibility','off')
plot(s, front_left(:,4), '+b','HandleVisibility','off')
plot(s, front_left(:,5), '+b')
plot(s, f_front_left.Fitted,'--r')
text(5,2,['Federkonstannte [k] = ',...
          num2str(f_front_left.Coefficients.Estimate) ,...
          '$\frac{N}{mm}$'],...
          'HorizontalAlignment','left','interpreter','latex');
hold off
grid minor
ylabel('\Delta Kraft (N)')
xlabel('\Delta Weg (mm)')
title('Federkennlinie vorne links')
legend('Data','Fit','Location','southeast')


subplot(2,2,2)
hold on
plot(s, front_right(:,1), '+b','HandleVisibility','off')
plot(s, front_right(:,2), '+b','HandleVisibility','off')
plot(s, front_right(:,3), '+b','HandleVisibility','off')
plot(s, front_right(:,4), '+b','HandleVisibility','off')
plot(s, front_right(:,5), '+')
plot(s, f_front_right.Fitted,'--r')
text(5,2,['Federkonstannte [k] = ',...
          num2str(f_front_right.Coefficients.Estimate) ,...
          '$\frac{N}{mm}$'],...
          'HorizontalAlignment','left','interpreter','latex');
hold off
grid minor
ylabel('\Delta Kraft (N)')
xlabel('\Delta Weg (mm)')
title('Federkennlinie vorne rechts')
legend('Data','Fit','Location','southeast')

subplot(2,2,3)
hold on
plot(s, rear_left(:,1), '+b','HandleVisibility','off')
plot(s, rear_left(:,2), '+b','HandleVisibility','off')
plot(s, rear_left(:,3), '+b','HandleVisibility','off')
plot(s, rear_left(:,4), '+b','HandleVisibility','off')
plot(s, rear_left(:,5), '+b')
plot(s, f_rear_left.Fitted,'--r')
text(7,2,['Federkonstannte [k] = ',...
          num2str(f_rear_left.Coefficients.Estimate) ,...
          '$\frac{N}{mm}$'],...
          'HorizontalAlignment','left','interpreter','latex');

hold off
grid minor
ylabel('\Delta Kraft (N)')
xlabel('\Delta Weg (mm)')
title('Federkennlinie hinten links')
legend('Data','Fit','Location','southeast')


subplot(2,2,4)
hold on
plot(s, rear_right(:,1), '+b','HandleVisibility','off')
plot(s, rear_right(:,2), '+b','HandleVisibility','off')
plot(s, rear_right(:,3), '+b','HandleVisibility','off')
plot(s, rear_right(:,4), '+b','HandleVisibility','off')
plot(s, rear_right(:,5), '+b')
plot(s, f_rear_right.Fitted,'--r')
text(7,2,['Federkonstannte [k] = ',...
          num2str(f_rear_right.Coefficients.Estimate) ,...
          '$\frac{N}{mm}$'],...
          'HorizontalAlignment','left','interpreter','latex');

hold off
grid minor
ylabel('\Delta Kraft (N)')
xlabel('\Delta Weg (mm)')
title('Federkennlinie hinten rechts')
legend('Data','Fit','Location','southeast')
if(savePlots == true)
    h = gcf;
    set(h, 'PaperOrientation','landscape');
    set(h,'PaperUnits' ,'normalized');
    set(h, 'PaperPosition', [0 0 1 1]);
    print(gcf, '-dpdf', 'Federkennlinien')
end

figure('units','normalized','outerposition',[0 0 1 1])
hold on
plot(s,f_front_left.Fitted)
plot(s,f_front_right.Fitted)
plot(s,f_rear_left.Fitted)
plot(s,f_rear_right.Fitted)
hold off
grid minor
title('Vergleich Federkennlinien')
ylabel('\Delta Kraft (N)')
xlabel('\Delta Weg (mm)')
legend('FL','FR','HL','HR','Location','southeast')

if(savePlots == true)
    h = gcf;
    set(h, 'PaperOrientation','landscape');
    set(h,'PaperUnits' ,'normalized');
    set(h, 'PaperPosition', [0 0 1 1]);
    print(gcf, '-dpdf', 'Federkennlinien_Vergleich')
end
