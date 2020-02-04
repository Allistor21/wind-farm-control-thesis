%Script to plot figures for choosing a scaling factor for the optimiser's cost function 3.

close all
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\testScalingFactors'

figSize1 = [0 0 900 900];
figSize2 = [0 0 1200 600];
fontSize = 30;
lineWidth = 2.5;
markerSize = 10;

clrsArray = {'g-o';'r-s';'b-p';'k-x'};


numbs = 0:1:3;


figure('position',figSize2)

set(gcf,'color','w');
set(gca, 'FontName', 'Arial');
set(gca, 'FontSize', fontSize);

legend('-DynamicLegend');
legend('Location','best');
legend('boxoff');

ylim([0 5]);
ylabel(['\beta_{i} [' char(176) ']']);

xlabel('scaling factor')

x = 1:1:5;

hold on

for i = 1:length(numbs)

    load(['run' num2str(numbs(i))]);

    lgdEntry = ['a=' num2str(a)];
    plot(x,optimiserOut3.pitchSettings,clrsArray{i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
end

hold off

grid on