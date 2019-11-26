%Sript to plot the figure 4.2.1, comparison of two-turbine setup simulation
%scenario between FASTnAT and literature, Gebraad
close all
clear all
cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\modelValidation\windFarm'

load('C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\modelValidation\windFarm\fig421workspace.mat');
outputArray = {'Power','CombRootMc1','RtAeroCt','RtTSR'};

for i = 1:length(offset)
    [FAST2ATArray{i},newOutList] = FASTnATprocess(FAST2ATArray{i},outputArray,OutList);
    
    for j = [1 2]
        TSRs(i,j) = FAST2ATArray{i}.turbineData{j}(1,4);
        Pwrs(i,j) = FAST2ATArray{i}.turbineData{j}(1,1);
    end
    
    Pwrs(i,3) = Pwrs(i,1) + Pwrs(i,2);
end

Pwrs = Pwrs ./ 1000;

%--------------------------------------------

figure('Position', [0 0 900 600])

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', 18); 

xlabel('pitch offset turbine 1 (�)');
xlim([0 5]);

ylabel('TSR');
ylim([6.5 10]);

hold on

for i = [1 2]
    plot(offset,TSRs(:,i))
end

hold off

legend('Turbine 1','Turbine 2');
legend('Location','northeast');
legend('boxoff');

print('TSRVsPitchFASTnAT','-dpng');

%--------------------------------------------

figure('Position', [0 0 900 600])

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', 18); 

xlabel('pitch offset turbine 1 (�)');
xlim([0 5]);

ylabel('Power (MW)');
ylim([0 4]);

hold on

for i = 1:3
    plot(offset,Pwrs(:,i))
end

hold off

legend('Turbine 1','Turbine 2','Total');
legend('Location','northeast');
legend('boxoff');

print('PowerVsPitchFASTnAT','-dpng');


