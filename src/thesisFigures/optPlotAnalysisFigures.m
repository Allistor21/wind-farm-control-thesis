%Script to build optimisation sensitivity figures
close all
clear all

cd 'C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation'

runNumber = 2;

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


load(['C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation\opt_VaryX_' num2str(runNumber) '.mat'])
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

print(['optXpitch_' num2str(runNumber)],'-depsc');

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

print(['optXdeltas_' num2str(runNumber)],'-depsc');

%Code for sum(power) & RSS loads vs parameter, including no control

z = zeros(1,N);

for i = 1:length(aux)
    deltaP = @(theta) sumPower(theta,N,Uinf,TIinf,aux(i),wakeModelType,coeffsFitObjArray1,coeffsFitObjArrayCt);
    deltaL = @(theta) rssLoads(theta,N,Uinf,TIinf,aux(i),wakeModelType,coeffsFitObjArray2,coeffsFitObjArrayCt);

    deltaPArray(i) = deltaP(z);
    deltaLArray(i) = deltaL(z);
end

figure('units','normalized','position',pitchSize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);
xlabel('Downstream distance X [1/D m]');
legend('Location','southoutside','NumColumns',4);
legend('boxoff');

clrs4 = {'c-','c--'};

hold on

yyaxis left

set(gca,'ycolor','k') 
ylabel('Sum of avg power, [kW]');
lgdEntry = 'Sum of power, base';
plot(aux,deltaPArray,clrs4{1},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
legend('-DynamicLegend')

yyaxis right

ylim([1500 1600])
set(gca,'ycolor','k') 
ylabel('rss loads [Nm]');
lgdEntry = 'rss loads, base';
plot(aux,deltaLArray,clrs4{2},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
legend('-DynamicLegend')

load(['C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation\opt_VaryX_2.mat'])

for j = 1:length(objs)
    for i = 1:length(aux)
        deltaP = @(theta) sumPower(theta,N,Uinf,TIinf,aux(i),wakeModelType,coeffsFitObjArray1,coeffsFitObjArrayCt);
        deltaL = @(theta) rssLoads(theta,N,Uinf,TIinf,aux(i),wakeModelType,coeffsFitObjArray2,coeffsFitObjArrayCt);

        deltaPArray(i,j) = deltaP(structX.resultArray{i,j}.pitchSettings);
        deltaLArray(i,j) = deltaL(structX.resultArray{i,j}.pitchSettings);
    end
end

clrs5 = {'b-*','r-*','k-*';'b--x','r--x','k--x'};

for i = 1:length(objs)
    
    yyaxis left
    lgdEntry = ['Sum of power,obj=' num2str(objs(i))];
    plot(aux,deltaPArray(:,i),clrs5{1,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

    yyaxis right
    lgdEntry = ['rss loads,obj=' num2str(objs(i))];
    plot(aux,deltaLArray(:,i),clrs5{2,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

end

hold off

print(['optXobjFunc_' num2str(runNumber)],'-depsc');

%Code for U & TI vs turbine number vs parameter

windsize = [0 0 0.7 0.7]

UArray(1) = Uinf; TIArray(1) = TIinf; CtArray(1) = fitFun(coeffsFitObjArrayCt,0,Uinf,TIinf);

for i = 2:N
    CtArray(i) = fitFun(coeffsFitObjArrayCt,0,UArray(i-1),TIArray(i-1));
    [UArray(i),TIArray(i)] = wakeModel(wakeModelType,CtArray(i),UArray(i-1),5,Uinf,TIinf);
end


figure('units','normalized','position',windsize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);
xlabel('Turbine Number');
legend('Location','southoutside','NumColumns',4);
legend('boxoff');

x = (1:1:5);

hold on

yyaxis left
ylabel('Wind speed [m/s]')
ylim([5 8]);
set(gca,'ycolor','k') 
plot(x,UArray,'c-*','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName','U,base')

yyaxis right
ylabel('Tubulence intensity [%]')
ylim([6 18])
set(gca,'ycolor','k') 
plot(x,TIArray,'c--x','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName','TI,base')

for i = 1:length(objs)
    
    yyaxis left
    lgdEntry = ['U,obj=' num2str(objs(i))];
    plot(x,structX.resultArray{1,i}.turbineU,clrs5{1,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

    yyaxis right
    lgdEntry = ['TI,obj=' num2str(objs(i))];
    plot(x,structX.resultArray{1,i}.turbineTI,clrs5{2,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

end

hold off

print(['optXUTI_P1' num2str(runNumber)],'-depsc');

%---------------------


UArray(1) = Uinf; TIArray(1) = TIinf; CtArray(1) = fitFun(coeffsFitObjArrayCt,0,Uinf,TIinf);

for i = 2:N
    CtArray(i) = fitFun(coeffsFitObjArrayCt,0,UArray(i-1),TIArray(i-1));
    [UArray(i),TIArray(i)] = wakeModel(wakeModelType,CtArray(i),UArray(i-1),8,Uinf,TIinf);
end


figure('units','normalized','position',windsize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);
xlabel('Turbine number');
legend('Location','southoutside','NumColumns',4);
legend('boxoff');

x = (1:1:5);

hold on

yyaxis left
ylabel('Wind speed [m/s]')
ylim([5 8]);
set(gca,'ycolor','k') 
plot(x,UArray,'c-*','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName','U,base')

yyaxis right
ylabel('Tubulence intensity [%]')
ylim([6 18])
set(gca,'ycolor','k') 
plot(x,TIArray,'c--x','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName','TI,base')

for i = 1:length(objs)
    
    yyaxis left
    lgdEntry = ['U,obj=' num2str(objs(i))];
    plot(x,structX.resultArray{2,i}.turbineU,clrs5{1,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

    yyaxis right
    lgdEntry = ['TI,obj=' num2str(objs(i))];
    plot(x,structX.resultArray{2,i}.turbineTI,clrs5{2,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

end

hold off

print(['optXUTI_P2' num2str(runNumber)],'-depsc');

%-----------------------

UArray(1) = Uinf; TIArray(1) = TIinf; CtArray(1) = fitFun(coeffsFitObjArrayCt,0,Uinf,TIinf);

for i = 2:N
    CtArray(i) = fitFun(coeffsFitObjArrayCt,0,UArray(i-1),TIArray(i-1));
    [UArray(i),TIArray(i)] = wakeModel(wakeModelType,CtArray(i),UArray(i-1),11,Uinf,TIinf);
end


figure('units','normalized','position',windsize)

set(gcf,'color','w'); %Set background color
set(gca, 'FontName', 'Arial'); %Set font type and size of axis labels
set(gca, 'FontSize', fontSize);
xlabel('Turbine Number');
legend('Location','southoutside','NumColumns',4);
legend('boxoff');

x = (1:1:5);

hold on

yyaxis left
ylabel('Wind speed [m/s]')
ylim([5 8]);
set(gca,'ycolor','k') 
plot(x,UArray,'c-*','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName','U,base')

yyaxis right
ylabel('Tubulence intensity [%]')
ylim([6 18])
set(gca,'ycolor','k') 
plot(x,TIArray,'c--x','LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName','TI,base')

for i = 1:length(objs)
    
    yyaxis left
    lgdEntry = ['U,obj=' num2str(objs(i))];
    plot(x,structX.resultArray{3,i}.turbineU,clrs5{1,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

    yyaxis right
    lgdEntry = ['TI,obj=' num2str(objs(i))];
    plot(x,structX.resultArray{3,i}.turbineTI,clrs5{2,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

end

hold off

print(['optXUTI_P3' num2str(runNumber)],'-depsc');

%-----------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------
%-------------------------------------------------------U sensitivity---------------------------------------------------------


load(['C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation\opt_VaryU_' num2str(runNumber) '.mat'])
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

print(['optUpitch_' num2str(runNumber)],'-depsc');

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

print(['optUdeltas_' num2str(runNumber)],'-depsc');


%-----------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------
%-------------------------------------------------------TI sensitivity---------------------------------------------------------


load(['C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation\opt_VaryTI_' num2str(runNumber) '.mat'])
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

print(['optTIpitch_' num2str(runNumber)],'-depsc');

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

print(['optTIdeltas_' num2str(runNumber)],'-depsc');


%-----------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------------
%-------------------------------------------------------N sensitivity---------------------------------------------------------


load(['C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation\opt_VaryN_' num2str(runNumber) '.mat'])
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

print(['optNpitch_' num2str(runNumber)],'-depsc');

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

print(['optNdeltas_' num2str(runNumber)],'-depsc');



