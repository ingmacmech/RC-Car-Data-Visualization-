%% Visualize PCA Analyse
clc;
clear;
close all;

%% Load data
% For new data run first Visualize_Dynamic_Data.m
load('pcaAnalysis.mat');

%% Plot combinations for 3D plot 

combo = [1,2,3;
         1,2,4;
         1,2,5;
         1,2,6;
         1,2,7;
         1,2,8;
         1,2,9;
         1,2,10;
         1,3,4;
         1,3,5;
         1,3,6;
         1,3,7;
         1,3,8;
         1,3,9;
         1,3,10;
         1,4,5;
         1,4,6;
         1,4,7;
         1,4,8;
         1,4,9;
         1,4,10;
         1,5,6;
         1,5,7;
         1,5,8;
         1,5,9;
         1,5,10;
         1,6,7;
         1,6,8;
         1,6,9;
         1,6,10;
         1,7,8;
         1,7,9;
         1,7,10];

nCombo = size(combo,1);

%% Plot 2D first two main axis

figure('units','normalized','outerposition',[0 0 1 1])
            annotation('textbox', [0 0.9 1 0.1], ...
            'String',...
            'PCA Analysis',...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center',...
            'FontSize',12, 'FontWeight', 'bold','interpreter','none')
        


hold on
scatter(pca.scores(pca.label==0,1),...
        pca.scores(pca.label==0,2),'b')
scatter(pca.scores(pca.label==1,1),...
        pca.scores(pca.label==1,2),'r')
    grid minor
hold off

xlabel(['PCA1 (',...
        num2str(round(pca.pcvars(1)/sum(pca.pcvars)*100)),'%)'])
ylabel(['PCA2 (',...
        num2str(round(pca.pcvars(2)/sum(pca.pcvars)*100)),'%)'])
title('Data reduced to first two main axis')


%% Plot 3D Combos
for n = 1 : nCombo

figure('units','normalized','outerposition',[0 0 1 1])

hold on
scatter3(pca.scores(pca.label==0,combo(n,1)),...
         pca.scores(pca.label==0,combo(n,2)),...
         pca.scores(pca.label==0,combo(n,3)),'b')
     
scatter3(pca.scores(pca.label==1,combo(n,1)),...
         pca.scores(pca.label==1,combo(n,2)),...
         pca.scores(pca.label==1,combo(n,3)),'r')
     grid minor
     
hold off
view(3)
xlabel(['PCA',...
        num2str(combo(n,1)),...
        ' (',...
        num2str(round(pca.pcvars(combo(n,1))/sum(pca.pcvars)*100)),' %)'])
ylabel(['PCA',...
        num2str(combo(n,2)),...
        ' (',...
        num2str(round(pca.pcvars(combo(n,2))/sum(pca.pcvars)*100)),' %)'])
zlabel(['PCA',...
        num2str(combo(n,3)),...
        ' (',...
        num2str(round(pca.pcvars(combo(n,3))/sum(pca.pcvars)*100)),' %)'])
title(['PCA Analysis reduced to 3D',...
       '(PCA',...
       num2str(combo(n,1)),...
       '/PCA',...
       num2str(combo(n,2)),...
       '/PCA',...
       num2str(combo(n,3)),...
       ')']);

end

