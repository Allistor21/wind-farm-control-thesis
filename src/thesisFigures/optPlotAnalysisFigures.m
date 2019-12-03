%Script to build optimisation sensitivity figures
close all
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation'

N=5;
Uinf=8;
TIinf=6;
X=5;
wakeModelType = 'jensenCrespo';
objs = (1:1:3);

vecX = [5 8 11];
vecN = [2 5 10];
vecU = [6 8 10];
vecTI = [6 10 14];

clrs = { 'b-*','r-*','k-*';'b--x','r--x','k--x' };
clrs2 = { 'b-^','b:o','b--d';'r-^','r:o','r--d';'k-^','k:o','k--d' };

pitchSize = [0 0 0.7 0.7];
quantSize = [0 0 0.5 0.7];
fontSize=22;
lineWidth = 1.8;
markerSize = 9;

%-----------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------
%-------------------------------------------------------X sensitivity---------------------------------------------------------


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

legend('X=5; obj=1','X=8; obj=1','X=11; obj=1','X=5; obj=2','X=8; obj=2','X=11; obj=2','X=5; obj=3','X=8; obj=3','X=11; obj=3');
legend('Location','southoutside','NumColumns',3);
legend('boxoff');

print('optXpitch','-depsc');

%Code for quatification figure

figure('units','normalized','position',quantSize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);

xlabel('Downstream distance [X*D]');

hold on

for i = 1:length(objs)
    
    yyaxis left
    ylabel('\Delta P [%]');
    y = curStruct.deltaPArray(:,i);
    plot(aux,y,clrs{1,i},'LineWidth', lineWidth, 'MarkerSize',markerSize);
    set(gca,'ycolor','k') 
    
    yyaxis right
    ylabel('\Delta L [%]');
    y = curStruct.deltaLArray(:,i);
    plot(aux,y,clrs{2,i},'LineWidth', lineWidth, 'MarkerSize',markerSize);
    set(gca,'ycolor','k') 
end

hold off
legend('\Delta P, obj=1','\Delta P, obj=2','\Delta P, obj=3','\Delta L, obj=1','\Delta L, obj=2','\Delta L, obj=3')
legend('Location','southoutside','NumColumns',2);
legend('boxoff');

print('optXdeltas','-depsc');


%-----------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------
%-------------------------------------------------------U sensitivity---------------------------------------------------------


load('C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation\optU.mat')
curStruct = structU;
aux = vecU;

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

legend('U=6; obj=1','U=8; obj=1','U=10; obj=1','U=6; obj=2','U=8; obj=2','U=10; obj=2','U=6; obj=3','U=8; obj=3','U=10; obj=3');
legend('Location','southoutside','NumColumns',3);
legend('boxoff');

print('optUpitch','-depsc');

%Code for quatification figure

figure('units','normalized','position',quantSize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);

xlabel('Free-stream wind speed [m/s]');

hold on

for i = 1:length(objs)
    
    yyaxis left
    ylabel('\Delta P [%]');
    y = curStruct.deltaPArray(:,i);
    plot(aux,y,clrs{1,i},'LineWidth', lineWidth, 'MarkerSize',markerSize);
    set(gca,'ycolor','k') 
    
    yyaxis right
    ylabel('\Delta L [%]');
    y = curStruct.deltaLArray(:,i);
    plot(aux,y,clrs{2,i},'LineWidth', lineWidth, 'MarkerSize',markerSize);
    set(gca,'ycolor','k') 
end

hold off

legend('\Delta P, obj=1','\Delta P, obj=2','\Delta P, obj=3','\Delta L, obj=1','\Delta L, obj=2','\Delta L, obj=3')
legend('Location','southoutside','NumColumns',2);
legend('boxoff');

print('optUdeltas','-depsc');


%-----------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------
%-------------------------------------------------------TI sensitivity---------------------------------------------------------


load('C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation\optTI.mat')
curStruct = structTI;
aux = vecTI;

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

legend('TI=6; obj=1','TI=10; obj=1','TI=14; obj=1','TI=6; obj=2','TI=10; obj=2','TI=14; obj=2','TI=6; obj=3','TI=10; obj=3','TI=14; obj=3');
legend('Location','southoutside','NumColumns',3);
legend('boxoff');

print('optTIpitch','-depsc');

%Code for quatification figure

figure('units','normalized','position',quantSize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);

xlabel('Ambient turbulence intensity [%]');

hold on

for i = 1:length(objs)
    
    yyaxis left
    ylabel('\Delta P [%]');
    y = curStruct.deltaPArray(:,i);
    plot(aux,y,clrs{1,i},'LineWidth', lineWidth, 'MarkerSize',markerSize);
    set(gca,'ycolor','k') 
    
    yyaxis right
    ylabel('\Delta L [%]');
    y = curStruct.deltaLArray(:,i);
    plot(aux,y,clrs{2,i},'LineWidth', lineWidth, 'MarkerSize',markerSize);
    set(gca,'ycolor','k') 
end

hold off
legend('\Delta P, obj=1','\Delta P, obj=2','\Delta P, obj=3','\Delta L, obj=1','\Delta L, obj=2','\Delta L, obj=3')
legend('Location','southoutside','NumColumns',2);
legend('boxoff');

print('optTIdeltas','-depsc');


%-----------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------
%-------------------------------------------------------N sensitivity---------------------------------------------------------


load('C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation\optN.mat')
curStruct = structN;
aux = vecN;

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

legend('N=2; obj=1','N=5; obj=1','N=10; obj=1','N=2; obj=2','N=5; obj=2','N=10; obj=2','N=2; obj=3','N=5; obj=3','N=10; obj=3');
legend('Location','southoutside','NumColumns',3);
legend('boxoff');

print('optNpitch','-depsc');

%Code for quatification figure

figure('units','normalized','position',quantSize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);

xlabel('Number of total turbines');

hold on

for i = 1:length(objs)
    
    yyaxis left
    ylabel('\Delta P [%]');
    y = curStruct.deltaPArray(:,i);
    plot(aux,y,clrs{1,i},'LineWidth', lineWidth, 'MarkerSize',markerSize);
    set(gca,'ycolor','k') 
    
    yyaxis right
    ylabel('\Delta L [%]');
    y = curStruct.deltaLArray(:,i);
    plot(aux,y,clrs{2,i},'LineWidth', lineWidth, 'MarkerSize',markerSize);
    set(gca,'ycolor','k') 
end

hold off
legend('\Delta P, obj=1','\Delta P, obj=2','\Delta P, obj=3','\Delta L, obj=1','\Delta L, obj=2','\Delta L, obj=3')
legend('Location','southoutside','NumColumns',2);
legend('boxoff');

print('optNdeltas','-depsc');



