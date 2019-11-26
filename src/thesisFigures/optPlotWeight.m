%Script to plot the figure for testing several opt weights.
close all
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation'

load('C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation\optWeights.mat')

clrs = { 'b-','r-','k-'};

pitchSize = [0 0 0.7 0.7];
quantSize = [0 0 0.5 0.7];
fontSize = 22;
lineWidth = 1.8;
markerSize = 15;

%Code for plotting pitch

figure('units','normalized','position',pitchSize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);

ylabel('Pitch setting [degree]');
%ylim([0 2]);

xlabel('Turbine number');

hold on

for i = 1:length(structWeights.weightArray)
    x = structWeights.resultArray{i}.turbineNumber;
    y = structWeights.resultArray{i}.pitchSettings;
    plot(x,y,clrs{i},'LineWidth', lineWidth,'MarkerSize',markerSize)

    xticks(structWeights.resultArray{i}.turbineNumber);
end

hold off

legend('\alpha = 0.3','\alpha = 0.6','\alpha = 0.9');
legend('Location','southoutside','NumColumns',3);
legend('boxoff');

%Code for plotting quantification

figure('units','normalized','position',quantSize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);

xlabel('Relative weight');

x = structWeights.weightArray;

hold on

yyaxis left
ylabel('Change in avg power (%)');
y = structWeights.deltaPArray;
plot(x,y,'k-','LineWidth', lineWidth, 'MarkerSize',markerSize);
set(gca,'ycolor','k') 
    
yyaxis right
ylabel('Change in SD of CRBM (%)');
y = structWeights.deltaLArray;
plot(x,y,'k--','LineWidth', lineWidth, 'MarkerSize',markerSize);
set(gca,'ycolor','k') 

hold off

legend('\Delta P','\Delta L');
legend('Location','southoutside','NumColumns',2);
legend('boxoff');
