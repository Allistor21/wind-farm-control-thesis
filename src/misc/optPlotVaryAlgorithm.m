%Script to plot the results from studying the effect of the fmincon algorithm on the optimisation.
close all
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation'





load('C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation\optX.mat')
curStruct = structX;
aux = vecX;

%Code for \beta figure

figure('units','normalized','position',pitchSize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);

ylabel(['\beta [' char(176) ']']);
%ylim([0 5]);

xlabel('Turbine number');

hold on

for j = 1:length(objs)
    for i = 1:length(aux)
        x = curStruct.resultArray{i,j}.turbineNumber;
        y = curStruct.resultArray{i,j}.pitchSettings;
        plot(x,y,clrs2{j,i},'LineWidth', lineWidth,'MarkerSize',markerSize);
        
        xticks(curStruct.resultArray{i,j}.turbineNumber);
    end   
end

hold off