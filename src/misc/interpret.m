%interpretar os resultados: efeito do X
close all
clear all

%Load fits
load C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\NREL5MW_AxialCase\data\fit_data\fitStudy_51.mat

%Figure parameters.
pitchSize = [0 0 0.7 0.7];
quantSize = [0 0 0.5 0.7];
fontSize=22;
lineWidth = 1.8;
markerSize = 9;

%Define optimiser inputs.
N = 5;
Uinf = 8;
TIinf = 6;
X = 7;
wakeModelType = 'jensenCrespo';
objs = (1:1:3);

%Plot deltaP and deltaL vs. X, no control on

vecX = [5 8 11];
z = zeros(1,N);

for i = 1:length(vecX)
    deltaP = @(theta) sumPower(theta,N,Uinf,TIinf,vecX(i),wakeModelType,coeffsFitObjArray1,coeffsFitObjArrayCt);
    deltaL = @(theta) rssLoads(theta,N,Uinf,TIinf,vecX(i),wakeModelType,coeffsFitObjArray2,coeffsFitObjArrayCt);

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

clrs = {'c-','c--'};

hold on

yyaxis left

ylabel('Sum of avg power, [kW]');
lgdEntry = 'Sum of power, base';
plot(vecX,deltaPArray,clrs{1},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
legend('-DynamicLegend')

yyaxis right

ylabel('rss loads [Nm]');
lgdEntry = 'rss loads, base';
plot(vecX,deltaLArray,clrs{2},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
legend('-DynamicLegend')

load(['C:\Users\mfram\Documents\GitHub\wind-farm-control-thesis\results\optimisation\opt_VaryX_2.mat'])

for j = 1:length(objs)
    for i = 1:length(vecX)
        deltaP = @(theta) sumPower(theta,N,Uinf,TIinf,vecX(i),wakeModelType,coeffsFitObjArray1,coeffsFitObjArrayCt);
        deltaL = @(theta) rssLoads(theta,N,Uinf,TIinf,vecX(i),wakeModelType,coeffsFitObjArray2,coeffsFitObjArrayCt);

        deltaPArray(i,j) = deltaP(structX.resultArray{i,j}.pitchSettings);
        deltaLArray(i,j) = deltaL(structX.resultArray{i,j}.pitchSettings);
    end
end

clrs2 = {'b-*','r-*','k-*';'b--x','r--x','k--x'};

for i = 1:length(objs)
    
    yyaxis left
    lgdEntry = ['Sum of power,obj=' num2str(objs(i))];
    plot(vecX,deltaPArray(:,i),clrs2{1,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

    yyaxis right
    lgdEntry = ['rss loads,obj=' num2str(objs(i))];
    plot(vecX,deltaLArray(:,i),clrs2{2,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

end

hold off


%---------------------


UArray(1) = Uinf; TIArray(1) = TIinf; CtArray(1) = fitFun(coeffsFitObjArrayCt,0,Uinf,TIinf);

for i = 2:N
    CtArray(i) = fitFun(coeffsFitObjArrayCt,0,UArray(i-1),TIArray(i-1));
    [UArray(i),TIArray(i)] = wakeModel(wakeModelType,CtArray(i),UArray(i-1),8,Uinf,TIinf);
end


figure('units','normalized','position',pitchSize)

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
    plot(x,structX.resultArray{2,i}.turbineU,clrs2{1,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

    yyaxis right
    lgdEntry = ['TI,obj=' num2str(objs(i))];
    plot(x,structX.resultArray{2,i}.turbineTI,clrs2{2,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

end

hold off


%------------------


UArray(1) = Uinf; TIArray(1) = TIinf; CtArray(1) = fitFun(coeffsFitObjArrayCt,0,Uinf,TIinf);

for i = 2:N
    CtArray(i) = fitFun(coeffsFitObjArrayCt,0,UArray(i-1),TIArray(i-1));
    [UArray(i),TIArray(i)] = wakeModel(wakeModelType,CtArray(i),UArray(i-1),5,Uinf,TIinf);
end


figure('units','normalized','position',pitchSize)

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
    plot(x,structX.resultArray{1,i}.turbineU,clrs2{1,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

    yyaxis right
    lgdEntry = ['TI,obj=' num2str(objs(i))];
    plot(x,structX.resultArray{1,i}.turbineTI,clrs2{2,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

end

hold off

%-----------------------

UArray(1) = Uinf; TIArray(1) = TIinf; CtArray(1) = fitFun(coeffsFitObjArrayCt,0,Uinf,TIinf);

for i = 2:N
    CtArray(i) = fitFun(coeffsFitObjArrayCt,0,UArray(i-1),TIArray(i-1));
    [UArray(i),TIArray(i)] = wakeModel(wakeModelType,CtArray(i),UArray(i-1),11,Uinf,TIinf);
end


figure('units','normalized','position',pitchSize)

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
    plot(x,structX.resultArray{3,i}.turbineU,clrs2{1,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

    yyaxis right
    lgdEntry = ['TI,obj=' num2str(objs(i))];
    plot(x,structX.resultArray{3,i}.turbineTI,clrs2{2,i},'LineWidth', lineWidth,'MarkerSize',markerSize,'DisplayName',lgdEntry)
    legend('-DynamicLegend')

end

hold off